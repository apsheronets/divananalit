(* File: parse_args.mli *)
(* 	$Id: parse_args.mli,v 1.2 2004-07-30 22:48:33 chris_77 Exp $	 *)

(** Parse command line arguments and build accordingly the following
  values. *)

val device : int -> Gnuplot.device
  (** [device i] returns a device for the plot number [i]. *)

val offline : int -> string option
  (** [offline i] returns [Some <file>] if the user desires to save
    the commands into a file (the name of which will be constructed
    from the program name and [i]) and [None] otherwise. *)
