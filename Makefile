PACKAGES = extlib
FILES = common.ml grapher.ml

NAME = grapher
CAMLC   = ocamlfind ocamlc   $(LIB)
CAMLOPT = ocamlfind ocamlopt $(LIB)
CAMLDOC = ocamlfind ocamldoc $(LIB)
CAMLDEP = ocamlfind ocamldep
LIB = -package $(PACKAGES)
PP =

OBJS    = $(FILES:.ml=.cmo)
OPTOBJS = $(FILES:.ml=.cmx)

all: $(NAME)

$(NAME): $(OPTOBJS)
	$(CAMLOPT) $^ -linkpkg -o $@

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
	-rm -f *.cm[ioxa] *.cmx[as] *.o *.a *~ $(NAME)
	-rm -f .depend

depend: .depend

.depend: $(FILES)
	$(CAMLDEP) $(PP) $(LIB) $(FILES:.ml=.mli) $(FILES) > .depend

FORCE:

-include .depend
