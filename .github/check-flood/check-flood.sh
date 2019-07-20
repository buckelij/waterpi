#!/bin/bash
# check if there may be water on the floor
FLOOD=0
today=`date +%Y-%m-%dT`
FLOOD=$(grep "$today" `date +%Y`-temp.csv | # grep for today in this year's data
  awk -F',' '{print $4}' |                  # fourth field is water sensor
  grep -oE '[0-9]+' |                       # extract the number 
  grep -v '^[0-9]$' |                       # exclude single digit values
  grep -v '^[0-9][0-9]$' |                  # exclude single digit values
  grep . -c                                 # count them
)

if [ $FLOOD -gt 0 ]; then
  echo WATER DETECTED ON FLOOR

  current_issues=$(curl -s -H "Authorization: bearer $GITHUB_TOKEN" 'https://api.github.com/repos/buckelij/waterpi/issues?state=all' | jq .[].title)
  if echo "$current_issues" | grep -q "Water detected $today"; then
    echo ISSUE ALREADY OPEN
    exit 0
  fi

  echo CREATING ISSUE
  curl -H "Authorization: bearer $GITHUB_TOKEN" -XPOST https://api.github.com/repos/buckelij/waterpi/issues -d '{
          "title":"Water detected '$today'"
        }'
  exit $?
fi

exit 0
