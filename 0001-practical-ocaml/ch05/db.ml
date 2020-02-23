(*
 * db.ml
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
