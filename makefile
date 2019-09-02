all: index.html

index.html: readme.md
	./htmlhere.sh

install:
	sudo cp htmlhere.sh /usr/bin
