#!/bin/sh

here="$(dirname "$(realpath "$0")")"

find $here \( -name \*.o -o -name \*.hi \) -delete
