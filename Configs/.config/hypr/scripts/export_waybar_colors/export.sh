run_in_fish() {
	fish $HOME/.config/hypr/scripts/export_waybar_colors/fish
}

run_in_bash() {
	bash $HOME/.config/hypr/scripts/export_waybar_colors/sh
}

run_in_zsh() {
	zsh $HOME/.config/hypr/scripts/export_waybar_colors/zsh
}

CURRENT_SHELL=$(basename $SHELL)

case $CURRENT_SHELL in
"bash")
	echo "Using bash"
	run_in_bash
	;;
"fish")
	echo "Using fish"
	run_in_fish
	;;
"zsh")
	echo "Using zsh"
	run_in_zsh
	;;
*)
	echo "Shell detection failed"
	;;
esac
