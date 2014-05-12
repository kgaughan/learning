open Parser
open Lexer

let _ =
  try
    let buf = Lexing.from_channel stdin in
    while true do
      let result = Parser.root Lexer.read buf in
      print_int result;
      print_newline ();
      flush stdout
    done
  with Lexer.Eof ->
    exit 0
