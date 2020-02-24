open Acct

type account = {
  id: string;
  username: string;
  contact_email: string;
}

module type STORE =
  sig
    val init: unit -> unit
    val get: string -> account
    val add: account -> unit
    val remove: string -> unit
    val exists: string -> bool
  end

module Datastore: STORE =
  struct
    let init () = ()

    let store = ref []

    let get x =
      List.assoc x store.contents

    let add x =
      store.contents <- store.contents @ [(x.username, x)]

    let remove x =
      store.contents <- List.remove_assoc x store.contents

    let exists x =
      List.mem_assoc x store.contents
  end

module type ACCOUNT = functor(S: STORE) ->
  sig
    val get_account_id: string -> string
    val get_contact_email: string -> string
  end

module type ACCOUNT_priv = functor(A: ACCT_NUM) -> functor(S: STORE) ->
  sig
    exception Account_error of string
    val create: string -> string -> unit
    val delete: string -> unit
  end

module Account_unp: ACCOUNT = functor(S: STORE) ->
  struct
    let get_account_id unme =
      let acc = S.get unme in
      acc.id

    let get_contact_email unme =
      let acc = S.get unme in
      acc.contact_email
  end

module Account_p: ACCOUNT_priv = functor(A: ACCT_NUM) -> functor(S: STORE) ->
  struct
    exception Account_error of string

    let create x y =
      let exists = S.exists x in
      if exists then
        raise (Account_error "Username already exists")
      else
        S.add {
          id = (A.next ());
          username = x;
          contact_email = y;
        }

    let delete x = S.remove x
  end

module Account_information = Account_unp(Datastore)

module Account_management = Account_p(Uacc_num)(Datastore)
