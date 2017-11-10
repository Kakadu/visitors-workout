include $(shell ocamlfind c -where)/Makefile.config
PPX := `ocamlfind query ppx_deriving`/ppx_deriving_show.cma
include $(shell ocamlfind query visitors)/Makefile.preprocess

.SUFFIXES: .preprocessed.ml
OB=ocamlfind c -package visitors.runtime,visitors.ppx -linkpkg
all:
	$(OB) main.ml -o main.byte
	$(OB) unregular.ml -o unregular.byte
	$(OB) expr_mono.ml -o expr_mono.byte
	$(OB) expr_poly.ml -o expr_poly.byte
	$(OB) -rectypes glist.ml -o glist.byte


clean:
	rm -f *.processed.ml *.byte *.cm[ioxa]

demo01deriving.processed.ml: demo01deriving.ml
	ocamlfind ppx_tools/rewriter -ppx '`ocamlfind query ppx_deriving`/ppx_deriving `ocamlfind query ppx_deriving`/ppx_deriving_show.cma' $^ | cat | sed -e 's/,/, /g' | sed -e 's/\([a-zA-Z_)]\)=/\1 =/g' | sed -e 's/  / /g' | sed -e 's/ \([,)]\)/\1/g' | sed -e 's/ in / in\n/g' | sed -e 's/^\( *|.* ->\) /\1\n/g' | sed -e 's/\(method[^=]*=\) /\1\n/g' | perl -0777 -pe 's/=\n *object/= object/gs' | perl -0777 -pe "s/fun ([a-zA-Z0-9_' ]+) ->\n *fun /fun \1 /gs" | perl -0777 -pe "s/fun ([a-zA-Z0-9_' ]+) ->\n *fun /fun \1 /gs"  | ocp-indent --config=JaneStreet,match_clause=4 > $@
