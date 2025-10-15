.PHONY: guide notes

guide:
	cd guide/latex && latexmk -r "/workdir/lib/latex/latexmkrc-build" -cd guide.tex

notes:
	cd notes/$(word 2,$(MAKECMDGOALS)) && latexmk -r "/workdir/lib/latex/latexmkrc-build" -cd main.tex

clean:
	git clean -dfX

%:
	@:
