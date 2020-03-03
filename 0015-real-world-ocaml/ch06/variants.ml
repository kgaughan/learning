open Core

type basic_colour =
  | Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White

let basic_colour_to_int = function
  | Black -> 0
  | Red -> 1
  | Green -> 2
  | Yellow -> 3
  | Blue -> 4
  | Magenta -> 5
  | Cyan -> 6
  | White -> 7

let colour_by_number number text =
  sprintf "\027[38;5;%dm%s\027[0m" number text

type weight =
  | Regular
  | Bold

type colour =
  (* basic colours, regular, and bold *)
  | Basic of (basic_colour * weight)
  (* 6x6x6 colour cube *)
  | RGB of (int * int * int)
  (* 24 greyscale levels *)
  | Grey of int

let colour_to_int = function
  | Basic (basic_colour, weight) ->
      let base =
        match weight with
        | Bold -> 8
        | Regular -> 0
      in base + basic_colour_to_int basic_colour
  | RGB (r, g, b) -> 16 + b + g * 6 + r * 36
  | Grey i -> 232 + i

let colour_print colour s =
  printf "%s\n" (colour_by_number (colour_to_int colour) s)
