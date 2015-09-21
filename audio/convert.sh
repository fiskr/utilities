#!/bin/bash

if [ $# -gt "0" ]; then
  if [[ $1 =~ help ]]; then
    echo "Usage: $0 [directory] [from extension, e.g. flac] [to extension, e.g. wav]"
    exit 1
  fi
  directory="$1"
else
  read -p "Which directory are the files in which you would like converted? > " directory
fi

if [ $# -gt "1" ]; then
  fromType="$2"
 else
   read -p "What format would you like to convert from? (e.g. flac) > " fromType
fi

if [ $# -gt "2" ]; then
  toType="$3"
else
  read -p "What format would you like to convert to? (e.g. wav) > " toType
fi

if [[ "$directory" == *" "* ]]; then
  rename 's/ /_/g' "$directory"
  directory="$(echo "$directory" | sed 's/ /_/g')"
fi

echo "Converting from $fromType to $toType"

cd "$directory"
echo "Changed directory to $directory"

if [[ $(find . -name "* *" -type f | wc -l) -gt 0 ]]; then
  find . -name "* *" -type f | rename 's/ /_/g'
fi

mkdir -p $toType
echo "Made new folder, $toType"

for file in ./*.$fromType; do
  filename=$(basename "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"
  echo $filename
  #ffmpeg -i "$filename.$fromType" -f $toType "$toType/$filename.$toType"
  if [[ $fromType == "flac" ]]; then
    if which flac; then
      echo "flac -d $filename.flac"
      flac -d "$filename.$fromType"
    else
      >&2 echo "You need to install flac to convert flac files: "
      >&2 echo "sudo apt-get install flac"
      exit 1
    fi
  elif [[ $toType == "wav" ]]; then
    if which mpg123; then
      mpg123 -w $filename.$toType $filename.$fromType
    else
      >&2 echo "You need to install mpg123 to convert to $toType: "
      >&2 echo "sudo apt-get install mpg123"
      exit 1
    fi
  fi
done

mv *.$toType $toType
