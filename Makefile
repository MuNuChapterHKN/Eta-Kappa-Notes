EKN_ROOT_DIR ?= /workdir

.PHONY: guide notes

guide:
	cd guide/latex && latexmk -r "$(EKN_ROOT_DIR)/lib/latex/latexmkrc-build" -cd -f guide.tex

notes: compile reduce

clean:
	git clean -dfX

compile:
	-cd notes/$(word 2,$(MAKECMDGOALS)) && latexmk -cd -r "$(EKN_ROOT_DIR)/lib/latex/latexmkrc-build" -f main.tex
	mkdir -p build
	mv notes/$(word 2,$(MAKECMDGOALS))/build/main.pdf build/$(word 2,$(MAKECMDGOALS)).pdf

reduce:
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=./build/$(word 2,$(MAKECMDGOALS))-compressed.pdf ./build/$(word 2,$(MAKECMDGOALS)).pdf

d-image:
	docker build -t texlive-ekn .

d-notes:
	docker run --rm -it -v ${PWD}:$(EKN_ROOT_DIR) texlive-ekn make notes $(word 2,$(MAKECMDGOALS))

d-compile:
	docker run --rm -it -v ${PWD}:$(EKN_ROOT_DIR) texlive-ekn make compile $(word 2,$(MAKECMDGOALS))

d-reduce:
	docker run --rm -it -v ${PWD}:$(EKN_ROOT_DIR) texlive-ekn make reduce $(word 2,$(MAKECMDGOALS))

%:
	@:
