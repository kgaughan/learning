let distance (x1, y1) (x2, y2) =
  sqrt ((x1 -. x2) ** 2. +. (y1 -. y2) ** 2.)

let my_favourite_language = function
  | first :: the_rest -> first
  | [] -> "OCaml" (* a good default! *)

let rec sum = function
  | [] -> 0
  | hd :: tl -> hd + sum tl

(** Remove sequential duplication *)
let rec destutter = function
  | [] -> []
  | [hd] -> [hd]
  | hd1 :: hd2 :: tl ->
      if hd1 = hd2 then
        destutter (hd1 :: tl)
      else
        hd1 :: destutter (hd2 :: tl)

let divide x = function
  | 0 -> None
  | y -> Some (x / y)

(*
let log_entry maybe_time message =
  let time =
    match maybe_time with
    | Some x -> x
    | None -> Time.now ()
  in Time.to_sec_string time ^ " -- " ^ message
*)

type point2d = {
  x : float;
  y : float;
}

let magnitude { x = x_pos; y = y_pos } =
  sqrt (x_pos ** 2. +. y_pos ** 2.)

let distance1 v1 v2 =
  magnitude { x = v1.x -. v2.x; y = v1.y -. v2.y }

type circle_desc = {
  centre : point2d;
  radius : float;
}

type rect_desc = {
  lower_left : point2d;
  width : float;
  height:  float;
}

type segment_desc = {
  endpoint1 : point2d;
  endpoint2 : point2d;
}

type scene_element =
  | Circle of circle_desc
  | Rect of rect_desc
  | Segment of segment_desc

let is_inside_scene_element point = function
  | Circle { centre; radius } ->
      (distance1 centre point) < radius
  | Rect { lower_left; width; height } ->
      point.x > lower_left.x
      && point.x < lower_left.x +. width
      && point.y > lower_left.y
      && point.y < lower_left.y +. height
  | Segment { endpoint1; endpoint2 } -> false

let is_inside_scene point =
  List.exists (fun el -> is_inside_scene_element point el)

type running_sum = {
  mutable sum : float;
  mutable sum_sq : float; (* sum of squares *)
  mutable samples : int;
}

let mean rsum = rsum.sum /. float rsum.samples

let stdev rsum =
  sqrt
    ((rsum.sum_sq /. float rsum.samples)
    -. ((rsum.sum /. float rsum.samples) ** 2.))

let create () = {
  sum = 0.;
  sum_sq = 0.;
  samples = 0;
}

let update rsum x =
  rsum.samples <- rsum.samples + 1;
  rsum.sum <- rsum.sum +. x;
  rsum.sum_sq <- rsum.sum_sq +. (x *. x)

let sum1 lst =
  let sum = ref 0 in
  List.iter (fun x -> sum := !sum + x) lst;
  !sum

let permute ary =
  let length = Array.length ary in
  for i = 0 to length - 2 do
    (* pick a j to swap with *)
    let j = i + Random.int (length - i) in
    (* swap i and j *)
    let tmp = ary.(i) in
    ary.(i) <- ary.(j);
    ary.(j) <- tmp
  done

let find_first_negative_entry ary =
  let len = Array.length ary in
  let pos = ref 0 in
  while !pos < len && ary.(!pos) >= 0 do
    pos := !pos + 1
  done;
  if !pos = len then
    None
  else
    Some !pos
