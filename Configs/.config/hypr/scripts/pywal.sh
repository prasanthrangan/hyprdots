#!/bin/sh
#set -x

HOME=$(echo $HOME)
zshrc_path="$HOME/.zshrc"
wallpaper=$(cat ~/.config/swww/wall.ctl | awk -F '|' '$1 == "1" { print $3}' ) 
#execute pywall
wallpaper=$(echo $wallpaper | sed 's/~//')
#echo $HOME$wallpaper
#wallpaper_name=$(echo $wallpaper | awk -F '/' '{print $5}')
#notify-send -ae "pywal"  "Wallpaper" "$wallpaper_name" 
#============================

term=$(cat ~/.zshrc | grep "term=" | awk -F "=" '{print $2}' )
term1=$(cat ~/.zshrc | grep "term1=" | awk -F "=" '{print $2}' )
term2=$(cat ~/.zshrc | grep "term2=" | awk -F "=" '{print $2}' )
term3=$(cat ~/.zshrc | grep "term3=" | awk -F "=" '{print $2}' )
term4=$(cat ~/.zshrc | grep "term4=" | awk -F "=" '{print $2}' )
term5=$(cat ~/.zshrc | grep "term5=" | awk -F "=" '{print $2}' )

	
		if [[ $1 == --on ]] ; then
		wal -qi $HOME$wallpaper
		#	sed -i "s|term=$term|term=$2|" $zshrc_path
			sed -i "s|term1=$term1|term1=|" $zshrc_path
			sed -i "s|term2=$term2|term2=|" $zshrc_path
			sed -i "s|term3=$term3|term3=|" $zshrc_path
		#	sed -i "s|term4=$term4|term4=$6|" $zshrc_path
		#	sed -i "s|term5=$term5|term5=$7|" $zshrc_path
			sed -i "s|term=$term|term=\$TERM|" $zshrc_path
			echo "Loaded on Zsh"
		elif [[ $1 == --load ]] ; then
		wal -qi $HOME$wallpaper
			sed -i "s|term=$term|term=|" $zshrc_path
			sed -i "s|term1=$term1|term1=$2|" $zshrc_path
			sed -i "s|term2=$term2|term2=$3|" $zshrc_path
			sed -i "s|term3=$term3|term3=$4|" $zshrc_path
		#	sed -i "s|term4=$term4|term4=$5|" $zshrc_path
		#	sed -i "s|term5=$term5|term5=$6|" $zshrc_path
			echo "loaded: $2 $3 $4 " #$5 $6 $7"

		elif [[ $1 == --remove ]]  ; then

			sed -i "s|term=$term|term=|" $zshrc_path
			sed -i "s|term1=$term1|term1=|" $zshrc_path
			sed -i "s|term2=$term2|term2=|" $zshrc_path
#			sed -i "s|term3=$term3|term3=|" $zshrc_path
#			sed -i "s|term4=$term4|term4=|" $zshrc_path
#			sed -i "s|term5=$term5|term5=|" $zshrc_path
#			echo "Unloaded: $term $term1 $term2 " # $term3 $term4 $term5"
			unLoad=$(echo "$term $term1 $term2")
			if [[ "$unLoad" =~ ^[[:space:]]*$ ]]; then
					echo "Pywal is not Loaded!"
			else
			echo "Unloaded: $unLoad"
			fi

					
					
					exit 0 

			
		elif [[ $1 == *""* ]]; then
echo ' 
Hello this is a switch for pywal

--help						Help message (this message)
--on 						Loads Pywal on .zshrc
--load 'term1' 'term2'				This part lookslike --load 'terminal1' 'terminal2' ...
--remove					Removes pywall on .zshrc

Khing! 
	'
		fi


