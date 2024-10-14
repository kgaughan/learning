module type A = sig
  val a : int
  val b : int -> int
end

module type B = sig
  val a : unit -> unit
end

module C =
functor
  (S : A)
  (T : B)
  ->
  struct
    let q m = S.b m
    let d f = T.a f
  end

module D = C (struct
  let a = 10
  let b x = x * a
end)

module E = D (struct
  let a () = ()
end)
