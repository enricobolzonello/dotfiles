CITY=Montebelluna
COUNTRY=IT

if [[ -n "$CITY" && -n "$COUNTRY" ]]; then
	weather_info=$(curl -s "wttr.in/$CITY?format=%c+%C+%t" 2>/dev/null)

	if [[ -n "$weather_info" ]]; then
		echo "$COUNTRY, $CITY: $weather_info"
	else
		echo "Weather info unavailable for $COUNTRY, $CITY"
	fi
else
	echo "Unable to determine your location"
fi
