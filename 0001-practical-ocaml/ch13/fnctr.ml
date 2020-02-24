module type EXAMPLE =
  sig
    type maybe
    val plus: int * int -> int * int -> int * int
    val minus: int * int -> int * int -> int * int
  end

module Dbg_E: EXAMPLE =
  struct
    type maybe = X | Y
    let plus x y =
      Printf.printf "%i %i\n%i %i\n" (fst x) (snd x) (fst y) (snd y);
      ((fst x), (fst y))
    let minus x y =
      Printf.printf "%i %i\n%i %i\n" (fst x) (snd x) (fst y) (snd y);
      ((snd y), (snd x))
  end

module type F_TOR = functor(E: EXAMPLE) ->
  sig
    val plus: int -> int -> int -> int -> int * int
    val minus: int -> int -> int -> int -> int * int
  end

module F_tor: F_TOR = functor(E: EXAMPLE) ->
  struct
    let plus x y z m = E.plus (x, y) (z, m)
    let minus x y z m = E.minus (x, y) (z, m)
  end

module F = F_tor(
  struct
    type maybe = A | B
    let plus x y = ((fst x), (fst y))
    let minus x y = ((snd y), (snd x))
  end)

module F' = F_tor(Dbg_E)
