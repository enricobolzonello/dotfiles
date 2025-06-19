#!/bin/bash

source=~/.config/hypr/colors.conf

TMP_FOLDER=~/.config/hypr/tmp/

if [ $# -eq 0 ]; then
	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
	exit 1
fi

# Function to get metadata using playerctl
get_metadata() {
	key=$1
	playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# Check for arguments

# Function to determine the source and return an icon and text
get_source_info() {
	trackid=$(get_metadata "mpris:trackid")
	if [[ "$trackid" == *"firefox"* ]]; then
		echo -e "<span> Firefox 󰈹 </span>"
	elif [[ "$trackid" == *"spotify"* ]]; then
		echo -e "<span> Spotify  </span>"
	elif [[ "$trackid" == *"chromium"* ]]; then
		echo -e "<span> Chrome  </span>"
	else
		echo -e "<span>Source  </span>"
	fi
}

# Parse the argument
case "$1" in
--title)
	title=$(get_metadata "xesam:title")
	if [ -z "$title" ]; then
		echo "Nothing playing"
	else
		len=${#title}
		end=""
		if [[ "$len" > 25 ]]; then
    			title="${title:0:25}"
    			end="..."
		fi
		echo "${title}${end}"
	fi
	;;
--arturl)
	url=$(get_metadata "mpris:artUrl")
	if [ -z "$url" ]; then
		rm -f "${TMP_FOLDER}spotify-album.png"
		echo ""
	else
		if [[ "$url" == http*://* ]]; then
			curl -so "${TMP_FOLDER}spotify-album.jpg" "$url"
			magik "${TMP_FOLDER}spotify-album.jpg" "${TMP_FOLDER}spotify-album.png"
			rm -rf "${TMP_FOLDER}spotify-album.jpg"
			echo "${TMP_FOLDER}spotify-album.png"
		else
			if [[ "$url" == file://* ]]; then
				url=${url#file://}
			fi
			echo "$url"
		fi
	fi
	;;
--artist)
	artist=$(get_metadata "xesam:artist")
	if [ -z "$artist" ]; then
		echo ""
	else
		echo "${artist:0:26}" # Limit the output to 50 characters
	fi
	;;
--length)
	length=$(get_metadata "mpris:length")
	if [ -z "$length" ]; then
		echo "0.0 m"
	else
		# Convert length from microseconds to a more readable format (seconds)
		echo "$(awk "BEGIN { printf \"%.2f\", $length/1000000/60}") m"
	fi
	;;
--status)
	status=$(playerctl status 2>/dev/null)
	if [[ $status == "Playing" ]]; then
		echo "<span> 󰎆 </span>"
	elif [[ $status == "Paused" ]]; then
		echo "<span> 󱑽 </span>"
	else
		echo "<span>  </span>"
	fi
	;;
--album)
	album=$(playerctl metadata --format "{{ xesam:album }}" 2>/dev/null)
	if [[ -n $album ]]; then
		echo "$album"
	else
		status=$(playerctl status 2>/dev/null)
		if [[ -n $status ]]; then
			echo "Not album"
		else
			echo ""
		fi
	fi
	;;
--source)
	get_source_info
	;;
*)
	echo "Invalid option: $1"
	echo "Usage: $0 --title | --url | --artist | --length | --album | --source"
	exit 1
	;;
esac
