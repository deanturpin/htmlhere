#!/bin/bash

readonly in=readme.md

cat<<!
<!DOCTYPE html>
<html>
<head>
	<style>
		body {
			background-color: powderblue;
			font-family: sans-serif;
			margin-top: 5%;
			margin-left: 25%;
			margin-right: 25%;
		}
		img {
			width: 100%;
		}
		pre {
			background-color: black;
			color: white;
			font-family: monospace;
			border-radius: 10px;
			padding: 10px;
		}
	</style>
</head>
<body>
!

openpre=0

while read line; do

	# Look for pre tags
	if [[ $line =~ ^\`\`\` ]]; then

		if [[ $openpre == 0 ]]; then
			openpre=1
			echo "<pre>"
		else
			openpre=0
			echo "</pre>"
		fi

	# If not a pre tag then process other markdown
	elif [[ $openpre == 0 ]]; then

		# Headings
		if [[ $line =~ ^\#\ *([^\#]+) ]]; then
			echo "<h1>${BASH_REMATCH[1]}</h1>"
		elif [[ $line =~ ^\#\#\ *([^\#]+) ]]; then
			echo "<h2>${BASH_REMATCH[1]}</h2>"
		elif [[ $line =~ ^\#\#\#\ *([^\#]+) ]]; then
			echo "<h3>${BASH_REMATCH[1]}</h3>"
		elif [[ $line =~ ^\#\#\#\#\ *([^\#]+) ]]; then
			echo "<h4>${BASH_REMATCH[1]}</h4>"

		# Embedded image
		elif [[ $line =~ ^\!\[.*\]\((.*)\) ]]; then
			echo "<img src=\"${BASH_REMATCH[1]}\" />"

		# Link to other doc
		elif [[ $line =~ ^(.*)\[(.*)\]\((.*)\)(.*) ]]; then
			echo "${BASH_REMATCH[1]}<a href='${BASH_REMATCH[3]}'>${BASH_REMATCH[2]}</a>${BASH_REMATCH[4]}"
		fi

	# Otherwise just print the line
	else
		echo $line
	fi
done < $in

cat<<!
</body>
</html>
<!-- $(date) -->
!
