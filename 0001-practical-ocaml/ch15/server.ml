module SimpleServer : sig
  val echo_server : string -> int -> unit
  val server : string -> int -> (in_channel -> out_channel -> unit) -> unit
end = struct
  let server_setup ip portnum =
    let s = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
    let sock_address = Unix.ADDR_INET (Unix.inet_addr_of_string ip, portnum) in
    ignore (Unix.bind s sock_address);
    ignore (Unix.listen s 10);
    ignore (Unix.setsockopt s Unix.SO_REUSEADDR true);
    s

  let server i p f =
    let s = server_setup i p in
    let a = Unix.accept s in
    let i = Unix.in_channel_of_descr (fst a) in
    let o = Unix.out_channel_of_descr (fst a) in
    try f i o with End_of_file -> Unix.shutdown (fst a) Unix.SHUTDOWN_ALL

  let echo_server i p =
    let loop i o =
      let ic = Scanf.Scanning.from_channel i in
      while true do
        Scanf.bscanf ic "%c" (fun x -> Printf.fprintf o "%c" x);
        flush o
      done
    in
    server i p loop
end
