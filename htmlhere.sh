#!/bin/bash

while read line; do

	openpre=0

	# Let's sub some HTML
	if [[ $line =~ ^\#\ *([^\#]+) ]]; then
		echo "<h1>${BASH_REMATCH[1]}</h1>"
	elif [[ $line =~ ^\#\#\ *([^\#]+) ]]; then
		echo "<h2>${BASH_REMATCH[1]}</h2>"
	elif [[ $line =~ '```' ]]; then
		if [[ $openpre == 0 ]]; then
			openpre=1
			echo "<pre>"
		else
			openpre=0
			echo "</pre>"
		fi
	else
		echo $line
	fi
done
