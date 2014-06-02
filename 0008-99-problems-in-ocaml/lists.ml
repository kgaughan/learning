let rec last lst =
  match lst with
  | [] -> None
  | hd :: [] -> Some hd
  | _ :: tl -> last tl

let rec last_two lst =
  match lst with
  | [] | [_]  -> None
  | [x; y] -> Some (x, y)
  | _ :: tl -> last_two tl

let rec at i lst =
  match lst with
  | [] -> None
  | hd :: tl -> if i = 1 then
                  Some hd
                else if i < 1 then 
                  None
                else
                  at (i - 1) tl

let length lst =
  let rec iter n lst =
    match lst with
    | _ :: tl -> iter (n + 1) tl
    | [] -> n
  in iter 0 lst

let rev lst =
  let rec iter acc lst =
    match lst with
    | [] -> acc
    | hd :: tl -> iter (hd :: acc) tl
  in iter [] lst

let is_palindrome lst =
  List.for_all2 (=) lst (rev lst)

type 'a node =
  | One of 'a
  | Many of 'a node list

let flatten lst =
  let rec iter acc lst =
    match lst with
    | [] -> acc
    | One v :: tl -> iter (v :: acc) tl
    | Many lst' :: tl -> iter (iter acc lst') tl
  in rev (iter [] lst)

let compress lst =
  let rec iter acc lst =
    match lst with
    | [] -> acc
    | [a] -> a :: acc
    | a :: (b :: _ as tl) -> iter (if a = b then acc else (a :: acc)) tl
  in rev (iter [] lst)

let rle_enc lst =
  let rec iter acc cur len rest =
    match rest with
    | [] -> (len, cur) :: acc
    | hd :: tl -> if hd = cur then
                    iter acc cur (len + 1) tl
                  else
                    iter ((len, cur) :: acc) hd 1 tl
  in match lst with
     | [] -> []
     | hd :: tl -> rev (iter [] hd 1 tl)

let pack lst =
  let rec expand' acc len ch =
    if len = 0 then acc else expand' (ch :: acc) (len - 1) ch in
  let expand (len, ch) = expand' [] len ch in
  List.map expand (rle_enc lst)
