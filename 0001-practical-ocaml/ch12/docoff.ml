(** This is a complete example for Ocamldoc
    @author Joshua Smith
    @version 1.9
 *)

(** Here we have some unassocated documentation.

    {ul
      {- With a list}
      {- that doesn't}
      {- really add any value}}
 *)

(***************************************************************)
(*** These will be ignored. More than one * gets you ignored ***)
(***************************************************************)

(** Our module type, Docoff, show the turning on and off of documentation processing *)
module type Docoff =
sig
  (** document foo
      @author Joshua Smith
   *)
  val foo: int -> int -> float

  (** document bar
      @deprecated This had to be deprecated in favour of baz
   *)
  val bar: int -> unit

  (**/**)
  (** This will not show up *)
  (**/**)

  (** baz will show up in the docs *)
  (* this comment is in the source but not the docs *)
  val baz: float -> string -> char
end

(** {1 This is a section header}
    {b Here is some bold text} with examples of
    {i italics} and {e emphasised} text, too.
    {C We can centre}
    {L left-align} {R and right-align too}
  
    We can reference code with links like this: {!Docoff.Docoff.bar}.
    Notice that it has to be fully qualified.
  
    Source code can be inlined like this:
    [val source_code_style: string -> int]
  
    Or preformatted like this:
    {[ let source_code_string x = String.length x ]}
  
    {v Verbatim text can be added, though you
may still have to escape certain text in verbatim blocks. v}
    {{:http://www.slashdot.org} this text can be a link}
  
    We can also make L{_a}T{^e}X look (almost) correct.
 *)
