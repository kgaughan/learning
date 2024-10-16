module StringMap : sig
  type key = String.t
  type 'a t = 'a Map.Make(String).t

  val empty : 'a t
  val is_empty : 'a t -> bool
  val add : key -> 'a -> 'a t -> 'a t
  val find : key -> 'a t -> 'a
  val remove : key -> 'a t -> 'a t
  val mem : key -> 'a t -> bool
  val iter : (key -> 'a -> unit) -> 'a t -> unit
  val map : ('a -> 'b) -> 'a t -> 'b t
  val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
  val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
  val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
end

val goodmap : int StringMap.t
val badmap : int StringMap.t
val goodcount : int
val badcount : int

val spam_prob_of_channel : in_channel -> float
(** returns a probability of spam from a given in_channel *)

val spam_prob_of_string : string -> float
(** returns a probability of spam from a given string *)

val spam_prob_of_file : string -> float
(** return a probability of spam from a given file *)

val train_ham : in_channel -> unit
(** trains the database on a given ham *)

val train_spam : in_channel -> unit
(** trains the database on a given spam *)

val paul_graham :
  StringMap.key -> int StringMap.t -> int StringMap.t -> int -> int -> float
