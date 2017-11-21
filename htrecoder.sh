#!/bin/bash

source ./color.sh

FILE=$1
SPEED=8

codeblock=false
app=false

while IFS= read -r line
do
  if [[ $line =~ ^#\ .* ]]; then
    if [[ $codeblock == true ]]; then
      echo "${gray}$line${normal}" | pv -qL $SPEED
    else
      echo "${bold}${underline}$line${normal}" | pv -qL $SPEED
    fi
  elif [[ $line =~ ^##\ .* ]]; then
    echo "${bold}$line${normal}" | pv -qL $SPEED
  elif [[ $line =~ ^\`\`\`$ ]]; then
    codeblock=false
  elif [[ $line =~ ^\`\`\`.* ]]; then
    codeblock=true
    app=$(echo $line | sed 's/```//g')
  elif [[ $codeblock == true ]]; then
    echo "${lightblue}$line${normal}" | pv -qL $SPEED
    $app -c "$line"
    sleep 0.5
  elif [[ $line == '' ]]; then
    echo $line
  else
    echo "$line" | pv -qL $SPEED
  fi
done < $FILE
