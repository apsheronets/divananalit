PACKAGES = gnuplot,extlib
FILES = parse_args.ml common.ml
ALL_FILES = $(FILES) bitcoin_self_cost.ml litecoin_self_cost.ml ex1.ml

NAME = divananalit
CAMLC   = ocamlfind ocamlc   $(LIB)
CAMLOPT = ocamlfind ocamlopt $(LIB)
CAMLDOC = ocamlfind ocamldoc $(LIB)
CAMLDEP = ocamlfind ocamldep
LIB = -package $(PACKAGES)
PP =

OBJS    = $(FILES:.ml=.cmo)
OPTOBJS = $(FILES:.ml=.cmx)

all: divananalit bitcoin_self_cost litecoin_self_cost

divananalit: $(OPTOBJS) ex1.ml
	$(CAMLOPT) $(OPTOBJS) ex1.ml -linkpkg -o $(NAME)

bitcoin_self_cost: $(OPTOBJS) bitcoin_self_cost.ml
	$(CAMLOPT) $(OPTOBJS) bitcoin_self_cost.ml -linkpkg -o $@

litecoin_self_cost: $(OPTOBJS) litecoin_self_cost.ml
	$(CAMLOPT) $(OPTOBJS) litecoin_self_cost.ml -linkpkg -o $@

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.PHONY: doc

.ml.cmo:
	$(CAMLC) $(PP) -c $<
.mli.cmi:
	$(CAMLC) -c $<
.ml.cmx:
	$(CAMLOPT) $(PP) -c $<

clean:
	-rm -f *.cm[ioxa] *.cmx[as] *.o *.a *~ $(NAME) bitcoin_self_cost litecoin_self_cost
	-rm -f .depend

depend: .depend

.depend: $(FILES)
	$(CAMLDEP) $(PP) $(LIB) $(ALL_FILES:.ml=.mli) $(ALL_FILES) > .depend

FORCE:

-include .depend
