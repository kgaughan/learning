open Core

type host_info = {
  hostname: string;
  os_name: string;
  cpu_arch: string;
  os_release: string;
  timestamp: Time.t;
}

type 'a timestamped = {
  item: 'a;
  time: Time.t;
}

let first_timestamped lst =
  List.reduce lst ~f:(fun a b -> if a.time < b.time then a else b)

(*
let host_info_to_string { hostname = h; os_name = os; cpu_arch = c; timestamp = ts; _ } =
  sprintf "%s (%s / %s, on %s)" h os c (Time.to_sec_string ts)
*)

let create_host_info ~hostname ~os_name ~cpu_arch ~os_release = {
  os_name;
  cpu_arch;
  os_release;
  hostname = String.lowercase hostname;
  timestamp = Time.now ();
}

module Log_entry = struct
  type t = {
    session_id: string;
    time: Time.t;
    important: bool;
    message: string;
  }
end

module Heartbeat = struct
  type t = {
    session_id: string;
    time: Time.t;
    status_message: string;
  }
end

module Logon = struct
  type t = {
    session_id: string;
    time: Time.t;
    user: string;
    credentials: string;
  }
  [@@deriving fields]
end

let create_log_entry ~session_id ~important message = {
  Log_entry.time = Time.now ();
  session_id;
  important;
  message;
}

let message_to_string { Log_entry.important; message; _ } =
  if important then
    String.uppercase message
  else
    message

let is_important t =
  t.Log_entry.important

type client_info = {
  addr: Unix.Inet_addr.t;
  port: int;
  user: string;
  credentials: string;
  last_heartbeat_time: Time.t;
  last_heartbeat_status: string;
}

let register_heartbeat t hb = {
  addr = t.addr;
  port = t.port;
  user = t.user;
  credentials = t.credentials;
  last_heartbeat_time = hb.Heartbeat.time;
  last_heartbeat_status = hb.Heartbeat.status_message;
}

let register_heartbeat1 t hb = {
  t with last_heartbeat_time = hb.Heartbeat.time;
         last_heartbeat_status = hb.Heartbeat.status_message;
}

type client_info_mut = {
  addr: Unix.Inet_addr.t;
  port: int;
  user: string;
  credentials: string;
  mutable last_heartbeat_time: Time.t;
  mutable last_heartbeat_status: string;
}

let register_heartbeat_mut t hb =
  t.last_heartbeat_time <- hb.Heartbeat.time;
  t.last_heartbeat_status <- hb.Heartbeat.status_message

let get_users logins =
  List.dedup_and_sort (List.map logins ~f:Logon.user)

let show_field field to_string record =
  let name = Field.name field in
  let field_string = to_string (Field.get field record) in
  name ^ ": " ^  field_string

let print_logon logon =
  let print to_string field =
    printf "%s\n" (show_field field to_string logon)
  in
  Logon.Fields.iter
    ~session_id:(print Fn.id)
    ~time:(print Time.to_string)
    ~user:(print Fn.id)
    ~credentials:(print Fn.id)
