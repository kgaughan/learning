%{
(* This is the header. Comments here work as normal. *)

let parse_error msg = print_string msg
%}

%token SET UNSET EQUAL EOF SEMI
%token <string> VAR_NAME
%start main
%type <(string * string) list> main

%%

main:
vars EOF { $1 }
;

/* but comments here do not */

vars:
  SET VAR_NAME EQUAL VAR_NAME SEMI { [($2, $4)] }
| UNSET VAR_NAME SEMI { [] }
| vars SET VAR_NAME EQUAL VAR_NAME SEMI { ($3, $5) :: $1 }
| vars UNSET VAR_NAME SEMI { List.remove_assoc $3 $1 }
;

%%

(* The trailer is here. This section is just copied verbatim.
   The %% is not required if you don't have anything in here. *)
