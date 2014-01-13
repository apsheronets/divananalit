
# OCaml part

packages = extlib
files = $(shell ls *.ml)
name = grapher

camlc   = ocamlfind ocamlc   $(lib)
camlopt = ocamlfind ocamlopt $(lib)
camldep = ocamlfind ocamldep
lib = -package $(packages)

objs    = $(files:.ml=.cmo)
optobjs = $(files:.ml=.cmx)

all: $(name)

$(name): $(optobjs)
	$(camlopt) `ocamldep-sorter $^ < .depend` -linkpkg -o $@

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(camlc) -c $<
.mli.cmi:
	$(camlc) -c $<
.ml.cmx:
	$(camlopt) -c $<



clean:
	-rm -f *.cm[ioxa] *.cmx[as] *.o *.a *~ $(name)
	-rm -f .depend

.depend: $(files)
	$(camldep) $(lib) $(files:.ml=.mli) $(files) > .depend

FORCE:

-include .depend
