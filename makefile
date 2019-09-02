all: index.html

index.html:
	./htmlhere.sh

install:
	sudo cp htmlhere.sh /usr/bin
