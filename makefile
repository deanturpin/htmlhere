all: index.html

index.html: readme.md
	./markdown2html.sh < $< > $@
