open Base
open Stdio

(** Find how often each line of `chan` occurs *)
let build_counts chan =
  In_channel.fold_lines chan ~init:Counter.empty ~f:Counter.touch

let () =
  build_counts In_channel.stdin
  |> Counter.to_list
  (* Sort the line frequencies in descending order *)
  |> List.sort ~compare:(fun (_, x) (_, y) -> Int.descending x y)
  (* Take the first ten lines *)
  |> (fun l -> List.take l 10)
  (* Print them all out *)
  |> List.iter ~f:(fun (line, count) -> printf "%3d: %s\n" count line)
