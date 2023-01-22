open Core
open Base.Poly

type 'a element = {
  value : 'a;
  mutable next : 'a element option;
  mutable prev : 'a element option;
}

type 'a t = 'a element option ref

let create () =
  ref None

let is_empty t =
  !t = None

let first t =
  !t

let next elt =
  elt.next

let prev elt =
  elt.prev

let value elt =
  elt.value

let iter t ~f =
  let rec loop = function
    | None -> ()
    | Some el ->
        f (value el);
        loop (next el)
  in
  loop !t

let find_el t ~f =
  let rec loop = function
    | None -> None
    | Some elt ->
        if f (value elt) then
          Some elt
        else
          loop (next elt)
  in
  loop !t

let insert_first t value =
  let new_elt = {
    prev = None;
    next = !t;
    value;
  } in
  begin
    match !t with
    | Some old_first ->
        old_first.prev <- Some new_elt
    | None -> ()
  end;
  t := Some new_elt;
  new_elt

let insert_after elt value =
  let new_elt = {
    next = elt.next;
    prev = Some elt;
    value;
  } in
  begin
    match elt.next with
    | Some old_next ->
        old_next.prev <- Some new_elt
    | None -> ()
  end;
  elt.next <- Some new_elt;
  new_elt

let remove t elt =
  let { prev; next; _ } = elt in
  begin
    match prev with
    | Some prev ->
        prev.next <- next
    | None ->
        t := next
  end;
  begin
    match next with 
    | Some next ->
        next.prev <- prev
    | None -> ()
  end;
  elt.prev <- None;
  elt.next <- None
