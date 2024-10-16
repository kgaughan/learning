type token_type = Query of string | Ham of string | Spam of string

module Client : sig
  val connect : string -> int -> unit
  val query : string -> float
  val ham : string -> int -> int
  val spam : string -> int -> int
  val disconnect : unit -> unit
end = struct
  let cons = ref (stdin, stdout)

  let connect ip portnum =
    let sockaddr = Unix.ADDR_INET (Unix.inet_addr_of_string ip, portnum) in
    let c = Unix.open_connection sockaddr in
    cons := c

  let query tok =
    let ic = Scanf.Scanning.from_channel (fst cons.contents) in
    Printf.fprintf (snd cons.contents) "Query %s\n" tok;
    flush (snd cons.contents);
    Scanf.bscanf ic "|%f|\n" (fun x -> x)

  let ham tok count =
    let ic = Scanf.Scanning.from_channel (fst cons.contents) in
    Printf.fprintf (snd cons.contents) "Ham %s %d\n" tok count;
    flush (snd cons.contents);
    Scanf.bscanf ic "|%d|\n" (fun x -> x)

  let spam tok count =
    let ic = Scanf.Scanning.from_channel (fst cons.contents) in
    Printf.fprintf (snd cons.contents) "Spam %s %d\n" tok count;
    flush (snd cons.contents);
    Scanf.bscanf ic "|%d|\n" (fun x -> x)

  let disconnect () = Unix.shutdown_connection (fst cons.contents)
end

let usage =
  "client [-server IP] [-port PORT] [-query WORD] (-spam WORD | -ham \
   WORD) [-count N]\n"

let ipaddr = ref "127.0.0.1"
let port = ref 8889
let action = ref (Query "chess")
let count = ref 0

let specs =
  [
    ("-server", Arg.String (fun x -> ipaddr := x), "IP address of the server");
    ("-port", Arg.Int (fun x -> port := x), "Port number to use");
    ("-query", Arg.String (fun x -> action := Query x), "Query a word");
    ("-count", Arg.Int (fun x -> count := x), "What is the count");
    ( "-spam",
      Arg.String (fun x -> action := Spam x),
      "Update a spam word (requires -score)" );
    ( "-ham",
      Arg.String (fun x -> action := Ham x),
      "Update a ham word (requires -score)" );
  ]

let () =
  Arg.parse specs (fun x -> ()) usage;
  Client.connect !ipaddr !port;
  (match !action with
  | Query m -> Printf.printf "%s is %f spam\n" m (Client.query m)
  | Spam m ->
      ignore (Client.spam m !count);
      Printf.printf "OK!\n"
  | Ham m ->
      ignore (Client.ham m !count);
      Printf.printf "OK!\n");
  Client.disconnect ()
