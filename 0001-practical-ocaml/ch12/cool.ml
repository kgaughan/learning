class cooltag = object(self)
  inherit Odoc_html.html

  (** this is where we define the member function to handle the cool tag.
      @cool Cool, eh?
   *)
  method html_of_cool t =
    Printf.sprintf "<blink>Blink</blink>\n"

  initializer
    tag_functions <- ("cool", self#html_of_cool) :: tag_functions
end

let cooltag = new cooltag

let _ = Odoc_args.set_doc_generator (Some (cooltag :> Odoc_args.doc_generator))
