open Core

module type ID = sig
  type t

  val of_string: string -> t

  val to_string: t -> string
end

module String_id = struct
  type t = string

  let of_string x = x

  let to_string x = x
end

module Username : ID = String_id

module Hostname : ID = String_id

type session_info = {
  user: Username.t;
  host: Hostname.t;
  when_started: Time.t;
}

let sessions_have_same_user s1 s2 = s1.user = s2.user

module Interval = struct
  type t =
    | Interval of (int * int)
    | Empty

  let create low high =
    if hight < low then
      Empty
    else
      Interval (low, high)
end

module Extended_interval = struct
  include Interval

  let contains t x =
    match t with
    | Empty -> false
    | Interval (low, high) ->
        x >= low && x <= high
end

let rec intersperse lst el =
  match lst with
  | [] | [_] -> lst
  | x :: y :: tl -> x :: el :: intersperse (y :: tl) el


