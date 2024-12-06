{

exception Eof
open Mll_types
open Parser

}

rule tokens = parse
  | [' ' '\n']+ { tokens lexbuf }
  | '[' { L_BRAKET }
  | ']' { R_BRAKET }
  | '#' { SHARP }
  | ['0'-'9' '-']+[' ']+['0'-'9' ':']+ { TIME(Lexing.lexeme lexbuf) }
  | ['0'-'9']+ { NUMBER(int_of_string(Lexing.lexeme lexbuf)) }
  | "\tBEGIN_MESSAGE:" { messages lexbuf }
  | ":END_MESSAGE" { tokens lexbuf }
  | "\tAUDIT:" { audit lexbuf }
  | "heartbeat recieved from" { HEARTBEAT }
  | "connected" { CONNECTED }
  | "command" { COMMAND }
  | "disconnected" { DISCONNECTED }
  | "peer" { PEER }
  | "port" { PORT }
  | "client" { CLIENT }
  | ['0'-'9']?['0'-'9']?['0'-'9']'.'['0'-'9']?['0'-'9']?['0'-'9']'.'['0'-'9']?['0'-'9']?['0'-'9']'.'['0'-'9']?['0'-'9']?['0'-'9'] { IP_ADDR(Lexing.lexeme lexbuf) }
  | '/' { SLASH }
  | ['A'-'Z']['A'-'Z'] { ADDR(Lexing.lexeme lexbuf) }
  | ['a'-'z' 'A'-'Z']+ { SERVER(Lexing.lexeme lexbuf) }
  | eof { raise Eof }
and messages = parse
  | ":END_MESSAGE" { tokens lexbuf }
  | [' ' 'a'-'z' 'A'-'Z' '0'-'9' '\n']+ { MESSAGE(Lexing.lexeme lexbuf) }
and audit = parse
  | '\n' { tokens lexbuf }
  | [^ '\n']+ { audit lexbuf }

{

let _ =
  let ic = open_in "mll.txt" in
  let lb = Lexing.from_channel ic in
  try
    while true do
      let m = Parser.main tokens lb in
      match m with
        | Connected (_, _, s) -> Printf.printf "Connect! %s\n" s
        | Heartbeat (q, _) -> Printf.printf "Heartbeat! %s\n" q.host
        | Command (_, _, s) -> Printf.printf "Command %s\n" s
        | Disconnect (q, _, _) -> Printf.printf "Disconnect %s\n" q.host
    done
  with
    | Eof -> close_in ic
    | Parsing.Parse_error
    | Failure(_) ->
      Printf.printf "Between location %i and %i\n"
        (Lexing.lexeme_start lb)
        (Lexing.lexeme_end lb);
      close_in ic;
      exit 1

}
