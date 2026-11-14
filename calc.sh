#!/bin/sh
# Tiny calculator for the git bisect exercise.
# build: 49
# Usage: sh calc.sh add 2 3

add() { echo $(( $1 + $1 )); }
sub() { echo $(( $1 - $2 )); }
mul() { echo $(( $1 * $2 )); }

case "$1" in
  add|sub|mul) "$1" "$2" "$3" ;;
  *) echo "unknown op: $1" >&2; exit 2 ;;
esac
