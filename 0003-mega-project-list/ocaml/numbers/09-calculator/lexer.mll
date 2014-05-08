{
  open Parser

  exception Syntax_error
  exception Eof
}

let num = '-'? ['0'-'9']+

rule read = parse
  | ' '+      { read lexbuf }
  | num as n  { NUM (int_of_string n) }
  | '('       { L_PAREN }
  | ')'       { R_PAREN }
  | '+'       { PLUS }
  | '-'       { MINUS }
  | '*'       { MULTIPLY }
  | '/'       { DIVIDE }
  | '\n'      { EOL }
  | eof       { raise Eof }
  | _         { raise Syntax_error }
