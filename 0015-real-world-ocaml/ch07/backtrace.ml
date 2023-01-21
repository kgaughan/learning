open Core
open Core_bench

let simple_computation () =
  List.range 0 10
  |> List.fold ~init:0 ~f:(fun sum x -> sum + x * x)
  |> ignore

let simple_with_handler () =
  try
    simple_computation ()
  with Exit -> ()

let end_with_exc () =
  try
    simple_computation ();
    raise Exit
  with Exit -> ()

let () =
  [
    Bench.Test.create ~name:"simple computation" simple_computation;
    Bench.Test.create ~name:"simple computation w/ handler" simple_with_handler;
    Bench.Test.create ~name:"end with exn" end_with_exc
  ]
  |> Bench.make_command
  |> Command_unix.run
