{
  type number =
    | Int of int
    | Float of float

  let current = Stack.create ()

  let op int_op float_op x y =
    match x, y with
      | Int n, Int m -> Int (int_op n m)
      | Int n, Float m -> Float (float_op (float_of_int n) m)
      | Float n, Int m -> Float (float_op n (float_of_int m))
      | Float n, Float m -> Float (float_op n m)

    let add = op (+) (+.)
    let subtract = op (-) (-.)
    let multiply = op ( * ) ( *. )
    let divide = op (/) (/.)

    let exec op =
      let f = Stack.pop current in
      let s = Stack.pop current in
      Stack.push (op s f) current

    let string_of_number x =
      match x with
        | Int n -> Printf.sprintf "%i" n
        | Float n -> Printf.sprintf "%f" n
}

rule tokens = parse
  | [' ' '\n'] { tokens lexbuf }
  | (['0'-'9']+ as num) {
    Stack.push (Int (int_of_string num)) current
  }
  | (['0'-'9']+'.'['0'-'9']* as fl) {
    Stack.push (Float (float_of_string fl)) current
  }
  | '+' { exec add }
  | '-' { exec subtract }
  | '*' { exec multiply }
  | '/' { exec divide }
  | '%' {
    (* Swap top two stack elements *)
    let f = Stack.pop current in
    let s = Stack.pop current in
    Stack.push f current;
    Stack.push s current
  }
  | 'p' {
    Printf.printf "%s\n" (string_of_number (Stack.top current));
    flush stdout
  }
  | 'q' { exit 0 }

{
  let _ =
    let lb = Lexing.from_channel stdin in
    while true do
      tokens lb
    done
}
