#!/bin/bash

# recursively creates a list of all files within a directory
function Delve
{
	#stores list of every file in the directory
	files=($(ls --format=single-column --literal))
	for file in ${files[@]}; do
	workingDirectory=$(pwd)

		# checks if the file is a directory and if so recurses
		if [ -d $file ]; then
			cd $workingDirectory/$file
			Delve
			cd ../
		else
		 echo "$workingDirectory/$file" >> /tmp/images.txt
		fi
	done
}


#if a directory is given as an argument, switch to it.
#if [ -n $1 ]; then
#	cd $1
#fi
[[ $1 ]] && cd $1

listOfDirectory=($(ls --literal --format=single-column))

#clears images.txt 
if [ -a /tmp/images.txt ];then
	echo "">/tmp/images.txt
fi

for directory in ${listOfDirectory[@]}; do
	workingDirectory=$(pwd)
	if [ -d $directory ];then
		cd $workingDirectory/$directory
		Delve
		cd ../
	fi
done

#removes markdown and other extraneous files
grep --ignore-case --extended-regexp "\.(png|gif|mp4|jpg|pdf)$" /tmp/images.txt >/tmp/media.txt

# updates the masterMedia.txt file if it has already been created otherwise it creates it
if [ -a $HOME/Documents/masterMedia.txt ];then
	diff /tmp/media.txt $HOME/Documents/masterMedia.txt | grep "<" | tr --delete "<" > $HOME/Documents/masterMedia.txt
	echo "masterMedia.txt is now up to date."
else
	echo "$(</tmp/media.txt)" > $HOME/Documents/masterMedia.txt
	echo "masterMedia.txt has been created in your Documents folder."
fi
