let rev_inplace ar =
  let i = ref 0 in
  let j = ref (Array.length ar - 1) in
  while !i < !j do
    (* swap the two elements *)
    let tmp = ar.(!i) in
    ar.(!i) <- ar.(!j);
    ar.(!j) <- tmp;
    (* bump the indices *)
    incr i;
    decr j
  done
