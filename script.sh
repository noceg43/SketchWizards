#!/bin/bash

# Check if the application path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <application_path>"
    exit 1
fi

# Get the current screen resolution
resolution=$(xrandr | grep '*' | awk '{print $1}')
echo "Current screen resolution: $resolution"

# Desired resolution
desired_resolution="1920x1080"
echo "Desired resolution: $desired_resolution"

# Path to the application
application_path="$1"
echo "Application path: $application_path"

# Run the application
"$application_path" &
app_pid=$!
echo "Application PID: $app_pid"

# Wait for the application to start
sleep 2

# Get the window ID of the application
window_id=$(wmctrl -lp | grep $app_pid | awk '{print $1}')
echo "Window ID: $window_id"

if [ "$resolution" == "$desired_resolution" ]; then
    # Set the application to fullscreen
    echo "Setting application to fullscreen"
    wmctrl -ir $window_id -b add,fullscreen
else
    # Set the application window size to 1920x1080
    echo "Setting application window size to 1920x1080"
    wmctrl -ir $window_id -e 0,0,0,1920,1080
fi