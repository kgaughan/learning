open Base
open Stdio

(** Find how often each line of `chan` occurs *)
let build_counts chan =
  let add_line counts line =
    let count =
      match List.Assoc.find ~equal:String.equal counts line with
      | None -> 0
      | Some x -> x
    in List.Assoc.add ~equal:String.equal counts line (count + 1)
  in In_channel.fold_lines chan ~init:[] ~f:add_line

let () =
  build_counts In_channel.stdin
  (* Sort the line frequencies in descending order *)
  |> List.sort ~compare:(fun (_, x) (_, y) -> Int.descending x y)
  (* Take the first ten lines *)
  |> (fun l -> List.take l 10)
  (* Print them all out *)
  |> List.iter ~f:(fun (line, count) -> printf "%3d: %s\n" count line)
