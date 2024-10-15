(** returns a probability of spam from a given in_channel *)
val spam_prob_of_channel: in_channel -> float

(** returns a probability of spam from a given string *)
val spam_prob_of_string: string -> float

(** return a probability of spam from a given file *)
val spam_prob_of_file: string -> float

(** trains the database on a given ham *)
val train_ham: in_channel -> unit

(** trains the database on a given spam *)
val train_spam: in_channel -> unit
