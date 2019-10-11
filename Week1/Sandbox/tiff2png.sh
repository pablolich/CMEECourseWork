#!/bin/bash

echo "Converting $1";
convert "$1" "$(basename "$1" .tiff).jpg" | mv $0 ../Sandbox/
