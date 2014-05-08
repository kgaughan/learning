%token <int> NUM
%token PLUS MINUS MULTIPLY DIVIDE
%token L_PAREN R_PAREN
%token EOL

%left PLUS MINUS
%left MULTIPLY DIVIDE

%start root
%type <int> root

%%

root:
  | expr EOL             { $1 }
  ;

expr:
  | NUM                  { $1 }
  | L_PAREN expr R_PAREN { $2 }
  | expr PLUS expr       { $1 + $3 }
  | expr MINUS expr      { $1 - $3 }
  | expr MULTIPLY expr   { $1 * $3 }
  | expr DIVIDE expr     { $1 / $3 }
  ;
