(*
 * db.ocaml
 *
 * Financial database from Chapter 5 of Practical OCaml
 *)

open Hashtbl;;
open Marshal;;

type position = {
  symbol: string;
  holding: int;
  pprice: float;
};;

type account = {
  name: string;
  max_ind_holding: float;
  pos: position list;
};;

let cur_prices = [
  ("IBM", 82.48);
  ("GOOG", 406.16);
  ("AMAT", 18.04);
  ("INTC", 19.24);
  ("MMM", 81.03);
  ("AMD", 33.69);
  ("AAPL", 69.79);
  ("GS", 161.02);
  ("AMZN", 37.09);
  ("ALD", 30.75);
  ("Y", 278.9);
  ("AFC", 0.);
  ("BCO", 51.05);
  ("BSX", 21.57);
  ("CC", 24.65);
  ("CSCO", 20.81);
  ("C", 47.66);
  ("CZN", 13.22);
  ("DO", 91.22);
  ("DELL", 29.76);
  ("COO", 53.18);
  ("CA", 26.8);
  ("DYN", 4.83);
  ("FAST", 46.64);
  ("FDX", 117.1);
];;

let gen_account acdb accname max_holding init_pos = 
  if (Hashtbl.mem acdb accname) then
    raise (Invalid_argument "Account name already in use")
  else
    Hashtbl.add acdb accname {name = accname;
                              max_ind_holding = max_holding;
                              pos = init_pos};;

let account_buy (symb, price) quant acc =
  {acc with pos =
    ({symbol = symb;
      holding = quant;
      pprice = price} :: acc.pos)};;

let account_sell (symb, price) acc =
  let rec seller sym prc pos_list soldq soldv newposlst =
    match pos_list with
    | [] -> ((soldq, soldv), {acc with pos = newposlst})
    | h :: t -> if (h.symbol = sym) then
                  seller sym prc t (soldq + h.holding)
                         (((float_of_int h.holding) *.
                           (prc -. h.pprice)) +. soldv)
                         newposlst
                else
                  seller sym prc t soldq soldv (h :: newposlst)
  in seller symb price acc.pos 0 0. [];;

let buy db account_name (symbol_name, price) quantity =
  let acc = Hashtbl.find db account_name in
  Hashtbl.replace db account_name
                  (account_buy (symbol_name, price) quantity acc);;

let sell db account_name (symbol_name, price) =
  let acc = Hashtbl.find db account_name in
  let ((quant, profit), newacc) = account_sell (symbol_name, price) acc in
  Hashtbl.replace db account_name newacc;
  (quant, profit);;

let store_db accounts_db filename =
  let f = open_out_bin filename in
  Marshal.to_channel f accounts_db [];
  close_out f;;

let load_db filename =
  let f = open_in_bin filename in
  let v = ((Marshal.from_channel f): (string, account) Hashtbl.t) in
  close_in f;
  v;;

let symbols_in_account acc =
  List.map (fun x -> x.symbol) acc.pos;;

let value_at_purchase acc =
  List.fold_left (fun y x -> ((float_of_int x.holding) *. x.pprice) +. y)
                 0. acc.pos;;

let current_value acc cur_prices =
  List.fold_left (fun y x -> ((float_of_int x.holding) *.
                              (List.assoc x.symbol cur_prices)) +. y)
                 0. acc.pos;;

let profit_and_loss acc cur_prices =
  (current_value acc cur_prices) -. (value_at_purchase acc);;

let total_pandl accdb cur_prices =
  List.fold_left (+.) 0.
                 (Hashtbl.fold (fun x y z -> (profit_and_loss y cur_prices) :: z)
                               accdb []);;

let percent_holding acc cur_prices =
  let curval = current_value acc cur_prices in
  List.map (fun x -> (x.symbol, (((float_of_int x.holding) *.
                                  (List.assoc x.symbol cur_prices)) /.
                                 curval)))
           acc.pos;;

let needs_rebal acc cur_prices =
  let percnt_hold = percent_holding acc cur_prices in
  List.filter (fun x -> (snd x) > acc.max_ind_holding)
              percnt_hold;;

let contains_symbol symb acc =
  List.fold_left (fun x y -> if (x) then x else y) false
                 (List.map (fun x -> x.symbol = symb) acc);;

let accounts_holding symb accdb =
  Hashtbl.fold (fun x y z -> if (contains_symbol symb y.pos) then
                               (x :: z)
                             else
                               z)
               accdb [];;

let print_position pos =
  print_string "Holding: ";
  print_int pos.holding;
  print_string (" " ^ pos.symbol ^ "@");
  print_float pos.pprice;
  print_newline ();;

let print_account acct =
  print_string ("Account ID: " ^ acct.name);
  print_newline ();
  List.iter print_position acct.pos;;

let summary_stats items =
  let total = List.fold_left (+.) 0. items in
  let mean = (total /. (float_of_int (List.length items))) in
  let median = List.nth items ((List.length items) / 2) in
  let std_dev =
    sqrt ((List.fold_left (fun y n -> ((n -. mean) *. (n -. mean)) +. y)
                          0.
                          items) /. (float_of_int (List.length items))) in
  total, mean, median, std_dev;;

let rec top_n source acc counter =
  match source with
  | h :: t when (counter = 0) -> List.rev acc
  | h :: t when (counter > 0) -> top_n t (h :: acc) (counter - 1)
  | _ -> assert false;;

let top_10 db new_prices =
  let lst = List.sort (fun (m, n) (x, y) -> compare y n)
                      (Hashtbl.fold (fun x y z -> ((x, profit_and_loss y new_prices) :: z)) db []) in
  top_n lst [] 10;;

let bottom_10 db new_prices =
  let lst = List.sort (fun (m, n) (x, y) -> compare n y)
                      (Hashtbl.fold (fun x y z -> ((x, profit_and_loss y new_prices) :: z)) db []) in
  top_n lst [] 10;;

let print_top_report title lst =
  let rec toprep buf items =
    match items with
    | [] ->
      let (sum, mn, med, stdev) = summary_stats (List.map (fun (x, y) -> y) lst) in
        Buffer.add_string buf "------------------\n";
        Buffer.add_string buf (Printf.sprintf "Sum:\t%-0.2f\n" sum);
        Buffer.add_string buf (Printf.sprintf "Mean:\t%-0.2f\n" mean);
        Buffer.add_string buf (Printf.sprintf "Median:\t%-0.2f\n" med);
        Buffer.add_string buf (Printf.sprintf "Stdev:\t%-0.2f\n" stdev);
        print_string (Buffer.contents buf)
    | (sy, pr) :: t ->
        Buffer.add_string buf (Printf.sprintf "%s:\t%-0.2f\n" sy pr);
        toprep buf t
  in
  let newbuf = Buffer.create 100 in
  Buffer.add_string newbuf title;
  Buffer.add_string newbuf "\n------------------\n";
  Buffer.add_char newbuf '\n';
  toprep newbuf lst;;

let price_to_string (m, n) =
  Printf.sprintf "%s %0.4f" m n;;

let string_of_position pos =
  Printf.sprintf "%s %i %0.4f" pos.symbol pos.holding pos.pprice;;

let price_from_string s =
  Scanf.sscanf s "%s %f" (fun x y -> x, y);;

let position_of_string s =
  Scanf.sscanf s "%s %i %0.4f" (fun x y z -> {symbol = x;
                                              holding = y;
                                              pprice = z});;

let string_of_account acct =
  let rec build_pos poslist accum =
    match poslist with
    | [] -> Buffer.contents accum
    | h :: t -> Buffer.add_char accum '|';
                Buffer.add_string accum (string_of_position h);
                build_pos t accum
  in
  let temp_buf = Buffer.create 100 in
  Buffer.add_string temp_buf acct.name;
  Buffer.add_char temp_buf '|';
  Buffer.add_string temp_buf (string_of_float acct.max_ind_holding);
  build_pos acct.pos temp_buf;;

let export_accounts db filename =
  let oc = open_out filename in
  Hashtbl.iter (fun key data -> Printf.fprintf oc "%s\n" (string_of_account data)) db;
  close_out oc;;

let account_of_string str =
  let rec build_pos sb accum =
    let getnextch =
      try
        Scanf.bscanf sb "%c"
                     (fun issep ->
                      match issep with
                      | '|' -> Scanf.bscanf sb "%s %i %f"
                                            (fun x y z ->
                                             Some {symbol = x;
                                                   holding = y;
                                                   pprice = z})
                      | _ -> raise (Invalid_argument "Malformed position"))
      with End_of_file -> None
    in
    match getnextch with
    | None -> accum
    | Some p -> build_pos sb (p :: accum)
  in
  let scan_buffer = Scanf.Scanning.from_string str in
  let acc_name, mih = Scanf.bscanf scan_buffer "%s@|%f" (fun x y -> x, y) in
  let pslist = build_pos scan_buffer [] in
  {name = acc_name;
   max_ind_holding = mih;
   pos = pslist};;

let import_accounts dstore filename =
  let ic = open_in filename in
  let rec iaccts chan store =
    let newacc =
      try
        Some (account_of_string (input_line ic))
      with End_of_file -> None
    in
    match newacc with
    | None -> ()
    | Some p -> Hashtbl.add store p.name p;
                iaccts ic store
  in
  let res = iaccts ic dstore in
  close_in ic;
  res;;

let rand_char () =
  let flip = Random.bool () in
  match flip with
  | true -> Char.chr ((Random.int 9) + 48)
  | false -> Char.chr ((Random.int 26) + 97);;

let random_acct_name len =
  let rec ran indx str =
    match indx with
    | 0 -> str.[0] <- rand_char ();
           str
    | _ -> str.[indx] <- rand_char ();
           ran (indx - 1) str
  in
  ran (len - 1) (String.create len);;

let rec gen_random_pos_list len accu price_list =
  match len with
  | 0 -> accu
  | _ -> let (sym, price) =
           List.nth price_list (Random.int (List.length price_list)) in
         gen_random_pos_list (len - 1) ({symbol = sym;
                                         holding = (Random.int 1000);
                                         pprice = price} :: accu) price_list;;

let gen_random_account current_prices =
  {name = (random_acct_name 5);
   max_ind_holding = ((Random.float 0.8) + 0.2);
   pos = gen_random_pos_list ((Random.int 9) + 1) [] current_prices};;

let rec populate_db rand_cands store current_prices =
  match rand_cands with
  | 0 -> ()
  | _ -> let newacc = gen_random_account current_prices in
         Hashtbl.add store newacc.name newacc;
         populate_db (rand_cands - 1) store current_prices;;
