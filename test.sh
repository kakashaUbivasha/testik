#!/bin/sh
# Exit code for git bisect run: 0 = good commit, 1 = bad commit.
cd "$(dirname "$0")" || exit 125
result=$(sh calc.sh add 2 3)
if [ "$result" = "5" ]; then
  echo "OK:   2 + 3 = $result"
  exit 0
fi
echo "FAIL: 2 + 3 = $result (expected 5)"
exit 1
