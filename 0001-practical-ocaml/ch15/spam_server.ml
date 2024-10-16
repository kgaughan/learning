module SelectServer = struct
  type token_type =
    | Spam of string * int
    | Query of string
    | Ham of string * int

  type connection = {
    fd : Unix.file_descr;
    addr : Unix.sockaddr;
    mutable input_buffer : bytes;
    output_queue : token_type Queue.t;
  }

  let add_string conn =
    let strbuf = Bytes.create 32 in
    let res = Unix.read conn.fd strbuf 0 32 in
    match res with
    | 0 ->
        Printf.printf "Failed to get anything!\n";
        flush stdout;
        false
    | n when res < 32 ->
        conn.input_buffer <-
          Bytes.cat conn.input_buffer (Bytes.sub strbuf 0 res);
        true
    | _ ->
        conn.input_buffer <- Bytes.cat conn.input_buffer strbuf;
        true

  let server_setup ip portnum =
    let s = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
    let sock_address = Unix.ADDR_INET (Unix.inet_addr_of_string ip, portnum) in
    ignore (Unix.bind s sock_address);
    ignore (Unix.listen s 10);
    ignore (Unix.setsockopt s Unix.SO_REUSEADDR true);
    ignore (Unix.set_nonblock s);
    s

  let server i p f =
    let s = server_setup i p in
    let a = Unix.accept s in
    let i = Unix.in_channel_of_descr (fst a) in
    let o = Unix.out_channel_of_descr (fst a) in
    try f i o with End_of_file -> Unix.shutdown (fst a) Unix.SHUTDOWN_ALL

  let newconn (fdsc, ad) =
    {
      fd = fdsc;
      addr = ad;
      input_buffer = Bytes.empty;
      output_queue = Queue.create ();
    }

  let get_token sb = Scanf.bscanf sb "%s@\n%n" (fun t count -> (t, count))

  let get_score sb =
    Scanf.bscanf sb "%s %d@\n%n" (fun t freq count -> (t, freq, count))

  let rec scan_buffer sb conn taken =
    let total =
      try
        Scanf.bscanf sb "%s@ %n" (fun q count ->
            match q with
            | "Query" ->
                let t, newcount = get_token sb in
                Queue.push (Query t) conn.output_queue;
                count + newcount
            | "Ham" ->
                let t, freq, newcount = get_score sb in
                Queue.push (Ham (t, freq)) conn.output_queue;
                count + newcount
            | "Spam" ->
                let t, freq, newcount = get_score sb in
                Queue.push (Spam (t, freq)) conn.output_queue;
                count + newcount
            | "" -> raise End_of_file
            | _ -> count)
      with End_of_file -> 0
    in
    match total with
    | 0 -> (
        if taken = 0 then ()
        else
          let strlen = Bytes.length conn.input_buffer - total in
          match strlen with
          | 0 -> conn.input_buffer <- Bytes.empty
          | _ -> (
              try conn.input_buffer <- Bytes.sub conn.input_buffer taken strlen
              with Invalid_argument m ->
                Printf.printf "%s %d %d\n"
                  (Bytes.to_string conn.input_buffer)
                  taken strlen;
                conn.input_buffer <- Bytes.empty))
    | _ -> scan_buffer sb conn total

  let process_data connlist =
    List.iter
      (fun (y, conn) ->
        let sb =
          Scanf.Scanning.from_string (Bytes.to_string conn.input_buffer)
        in
        scan_buffer sb conn 0)
      connlist

  let rec run_results conn goodmap badmap goodcount badcount =
    let write s =
      let b = String.to_bytes s in
      ignore (Unix.write conn.fd b 0 (Bytes.length b))
    in
    let lookup m map = try Spam.StringMap.find m map with Not_found -> 0 in
    match conn with
    | n when Queue.is_empty conn.output_queue ->
        (goodmap, badmap, goodcount, badcount)
    | _ -> (
        let nextv = Queue.pop conn.output_queue in
        match nextv with
        | Query m ->
            write
              (Printf.sprintf "|%f|\n"
                 (Spam.paul_graham m goodmap badmap goodcount badcount));
            run_results conn goodmap badmap goodcount badcount
        | Spam (m, f) ->
            let curval = lookup m badmap in
            write (Printf.sprintf "|%d|\n" (badcount + f));
            run_results conn goodmap
              (Spam.StringMap.add m (f + curval) badmap)
              goodcount (badcount + f)
        | Ham (m, f) ->
            let curval = lookup m goodmap in
            write (Printf.sprintf "|%d|\n" (goodcount + f));
            run_results conn
              (Spam.StringMap.add m (f + curval) goodmap)
              badmap (goodcount + f) badcount)

  let rec results connlist goodmap badmap goodcount badcount =
    match connlist with
    | [] -> (goodmap, badmap, goodcount, badcount)
    | (f, h) :: t ->
        let g, b, gc, bc = run_results h goodmap badmap goodcount badcount in
        results t g b gc bc

  let multiplex_server connlist timeout (goodmap : int Spam.StringMap.t) badmap
      goodcount badcount =
    let socks = List.map (fun (m, y) -> m) connlist in
    let r, _, _ = Unix.select socks [] [] timeout in
    let (to_shutdown : Unix.file_descr list) =
      List.filter (fun x -> not (add_string (List.assoc x connlist))) r
    in
    let _, w, _ = Unix.select [] socks [] timeout in
    process_data connlist;
    Printf.printf "Writing to %d\n" (List.length w);
    Printf.printf "Reading from %d of %d\n" (List.length to_shutdown)
      (List.length r);
    let gmap, bmap, gcount, bcount =
      results
        (List.filter (fun (x, y) -> List.mem x w) connlist)
        goodmap badmap goodcount badcount
    in
    let bad, good =
      List.partition (fun (x, y) -> List.mem x to_shutdown) connlist
    in
    Printf.printf "Shutting down: %d of %d\n" (List.length bad)
      (List.length good);
    flush stdout;
    List.iter
      (fun (x, y) ->
        try Unix.shutdown x Unix.SHUTDOWN_ALL
        with Unix.Unix_error (Unix.ENOTCONN, _, _) -> ())
      bad;
    (good, gmap, bmap, gcount, bcount)

  let rec newcon server_socket connlist goodmap badmap goodcount badcount =
    let a =
      try
        let m = Unix.accept server_socket in
        Printf.printf "Got connection from %s\n"
          (Unix.getnameinfo (snd m) [ Unix.NI_NOFQDN ]).Unix.ni_hostname;
        flush stdout;
        Some m
      with
      | Unix.Unix_error (Unix.EAGAIN, _, _) -> None
      | Sys.Break ->
          List.iter
            (fun (x, y) ->
              try Unix.shutdown x Unix.SHUTDOWN_ALL
              with Unix.Unix_error (Unix.ENOTCONN, _, _) -> ())
            connlist;
          Unix.shutdown server_socket Unix.SHUTDOWN_ALL;
          exit 1
    in
    match a with
    | Some nc ->
        let clst, gmap, bmap, gcount, bcount =
          multiplex_server
            ((fst nc, newconn nc) :: connlist)
            12.0 goodmap badmap goodcount badcount
        in
        newcon server_socket clst gmap bmap gcount bcount
    | None ->
        let clst, gmap, bmap, gcount, bcount =
          multiplex_server connlist 12.0 goodmap badmap goodcount badcount
        in
        newcon server_socket clst gmap bmap gcount bcount

  let run_server i p =
    let s = server_setup i p in
    newcon s [] Spam.goodmap Spam.badmap Spam.goodcount Spam.badcount
end
