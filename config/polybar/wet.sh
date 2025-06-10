#!/bin/sh

KEY="e434b5435a979de6e155570590bee89b"
CITY="710791"
UNITS="metric"
LANG="ru"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"



TOMORROW=$(date -u -d "tomorrow" +%Y-%m-%d)

RESPONSE=$(curl -s "https://api.openweathermap.org/data/2.5/forecast?id=${CITY}&appid=${KEY}&units=${UNITS}")

# Извлекаем каждую переменную отдельно
temp=$(echo "$RESPONSE" | jq -r --arg date "$TOMORROW" '
  [ .list[] | select(.dt_txt | startswith($date)) ] | map(.main.temp) | add / length | floor
')

temp_max=$(echo "$RESPONSE" | jq -r --arg date "$TOMORROW" '
  [ .list[] | select(.dt_txt | startswith($date)) ] | map(.main.temp_max) | max | round
')

desc=$(echo "$RESPONSE" | jq -r --arg date "$TOMORROW" '
  [ .list[] | select(.dt_txt | startswith($date)) ] |
  map(.weather[0].description) | group_by(.) | sort_by(length) | reverse | .[0][0]
')

icon=$(echo "$RESPONSE" | jq -r --arg date "$TOMORROW" '
  [ .list[] | select(.dt_txt | startswith($date)) ] |
  map(.weather[0].icon) | group_by(.) | sort_by(length) | reverse | .[0][0]
')

# Вывод
#echo "Температура: $temp°C"
#echo "Описание: $desc"
#echo "Иконка: $icon"

if [ -n "$icon" ]; then

	case $icon in
        01d) icon="󰖨" ;;
        01n) icon="" ;;
        02d|02n) icon="" ;;
        03d|03n) icon="" ;;
        04d|04n) icon="" ;;
        09d|09n) icon="" ;;
        10d|10n) icon="" ;;
        11d|11n) icon="" ;;
        13d|13n) icon="" ;;
        50d|50n) icon="󰖑" ;;
        *) icon="❓" ;;
    esac

    echo  "$icon $temp_max$SYMBOL"
fi

