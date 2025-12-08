#!/bin/sh
# Shows full calendar/date notification
CALENDAR=$(cal)
notify-send "Calendar" "$CALENDAR" -i appointment-new
