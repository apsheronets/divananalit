(* Parsing the command line arguments for all examples *)
(* 	$Id: parse_args.ml,v 1.3 2004-11-22 19:54:26 chris_77 Exp $	 *)


let ext = ref ""
let want_offline = ref false

let () =
  let args = [
    ("-dev", Arg.Set_string ext,
     "extension of the file in which to save the drawing.\n     " ^
     "  If no file is provided, the drawing will be done on the screen.");
    ("-o", Arg.Set want_offline,
     "  To write the commands to a file instead of sending them to gnuplot.");
  ] in
  let anon _ = raise (Arg.Bad "No anonymous argument") in
  Arg.parse args anon "Usage:"


let base = (*Filename.chop_extension*) Sys.argv.(0)
let pgmname = Filename.basename base

let device i =
  try
    let fname = Printf.sprintf "%s-%i.%s" base i !ext in
    let g =  Gnuplot.device_of_filename fname in
    Printf.printf "%-4s: Device %2i --> file %S\n" pgmname i fname;
    g
  with Failure _ -> Gnuplot.Wxt

let offline i =
  if !want_offline then Some(Printf.sprintf "%s-%i.plt" base i)
  else None
