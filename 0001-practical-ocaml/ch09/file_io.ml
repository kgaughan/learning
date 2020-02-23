open Unix;;

let catfile filename =
  let rec print_all_lines in_chan =
    output_string stdout ((input_line in_chan) ^ "\n");
    print_all_lines in_chan
  in
  let in_file = open_in filename in
  try
    print_all_lines in_file
  with End_of_file -> close_in in_file;;

let random_catfile filename =
  let in_file = open_in filename in
  let length = (Unix.stat filename).Unix.st_size in
  let starting_point = Random.int length in
  let segment = Random.int (length - starting_point) in
  let str_buf = String.create segment in
  let actually_input =
    seek_in in_file starting_point;
    input in_file str_buf 0 segment in
  close_in in_file;
  output_string stdout str_buf;;

let is_dir x =
  (Unix.stat x).Unix.st_kind = Unix.S_DIR;;

let ls x =
  match is_dir x in
  | false -> [x]
  | true ->
    let udir = Unix.opendir x in
    let rec buildlist d acc =
      try
        buildlist d (acc @ [(Unix.readdir d)])
      with End_of_file -> acc
    in buildlist udir [];;

let addr_string x =
  Unix.string_of_inet_addr (Array.get (Unix.gethostbyname x).Unix.h_addr_list 0);;
