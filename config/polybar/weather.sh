#!/bin/sh

KEY="e434b5435a979de6e155570590bee89b"
CITY="710791"
UNITS="metric"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
#	echo $weather

else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        weather=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
    fi
fi

if [ -n "$weather" ]; then
    weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
    ICON=$(echo "$weather" | jq -r ".weather[0].icon")
	#echo $ICON
	case $ICON in
        01d) ICON="󰖨 " ;;
        01n) ICON="" ;;
        02d|02n) ICON="" ;;
        03d|03n) ICON="" ;;
        04d|04n) ICON="" ;;
        09d|09n) ICON="" ;;
        10d|10n) ICON="" ;;
        11d|11n) ICON="" ;;
        13d|13n) ICON="" ;;
        50d|50n) ICON="󰖑" ;;
        *) ICON="❓" ;;
    esac

    echo  "$ICON $weather_temp$SYMBOL"
fi
