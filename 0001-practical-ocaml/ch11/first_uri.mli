exception Error of int

exception Unreg_protocol of (string * int)

type email = Email of (string * string)

type uri = File of string
         | Http of (string * string)
         | Mailto of email

type t = uri

val get_error: int -> string

val compare: t -> t -> int

val basename: t -> string

val is_relative: t -> bool

val concat: t -> string -> uri

val check_suffix: t -> string -> bool

val chop_suffix: t -> string -> t

val chop_extension: t -> t

val quote: t -> string

val string_of_uri: t -> string

val uri_of_string: string -> t
