#!/usr/bin/env sh

#Starting... 
monnum=$(hyprctl monitors | grep -i monitor | awk '{ print $4}'| awk -F ")" '{print $1}')

#monitor list
m0=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==1') #Main MOnitor
m1=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==2')
m2=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==3')
m3=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==4')
m4=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==5')
m5=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==6')
m6=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==7')
m7=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==8')
m8=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==9')
m9=$(hyprctl monitors | grep -i  description: | awk '{$1= ""; print $0}' | awk 'NR==10')


echo $monnum | {
read d0 d1 d2 d3 d4 d5 d6 d7 d8 d9
 
 #Main monitor 
 if [ $d0 = "0" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m0" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi

 if [ $d1 = "1" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m1" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d2 = "2" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m2" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d3 = "3" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m3" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d4 = "4" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m4" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d5 = "5" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m5" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d6 = "6" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m6" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d7 = "7" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m7" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d8 = "8" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m8" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi
 if [ $d9 = "9" ]; then
    sleep 2 &&
    dunstify -a "Monitor Connected" "$m9" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 3000
 fi

}
