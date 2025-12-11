#!/usr/bin/env bash
set -euo pipefail

# Usage: AddCurrentDate.sh <input-xml-file>

# the default date format is YYYY-MM-DD, set in the dateformat variable as a strfstime format string
# it should be portable
# you can also specify a desired date format in the file name in Cubase like this
# "%YYYY-MM-DD HH-mm% mixdown filename"
# everything between the % will be converted to the correct format string for date. 
# only the following values are allowed:
# YYYY = year, 4 digits
# MM =month, 2 digits
# DD = day, 2 digits
# HH = hours, 2 digits
# mm = minutes, 2 digits
# if it results in a wrong format string for date, this script will fail.


inputfile="${1:-}"
# Default date format (strftime)
dateformat="%Y-%m-%d"
# Separator between date and original filename
separator=" "
# Log file (override with LOGFILE env var)
# Use macOS-friendly per-user Logs directory when on Darwin, otherwise /tmp
if [ "$(uname)" = "Darwin" ]; then
  logFile="${LOGFILE:-$HOME/Library/Logs/CubasePostExport.log}"
else
  logFile="${LOGFILE:-/tmp/CubasePostExport.log}"
fi

# Convert common .NET date format tokens to strftime tokens
dotnet_to_strftime() {
  # Accept only these exact tokens (case-sensitive): YYYY, MM (month), DD, HH, mm (minute)
  # Map to padded strftime tokens. Other text is left unchanged.
  local s="$1"
  s="${s//YYYY/%Y}"
  s="${s//DD/%d}"
  s="${s//HH/%H}"
  s="${s//mm/%M}"
  s="${s//MM/%m}"
  echo "$s"
}

# format_date FORMAT
# Uses macOS-compatible `date -j` when running on Darwin, otherwise plain `date`.
format_date() {
  local fmt="$1"
  if [ "$(uname)" = "Darwin" ]; then
    date -j +"$fmt"
  else
    date +"$fmt"
  fi
}

if [ -z "$inputfile" ]; then
  echo "Usage: $0 <input-xml-file>" >&2
  exit 2
fi

# Ensure log file exists
mkdir -p "$(dirname "$logFile")" 2>/dev/null || true
: >"$logFile" 2>/dev/null || true
printf "Starting 'AddCurrentDate' at %s\n" "$(date)" >>"$logFile"


paths=()
# trying to isolate  Path elements from the XML, not guaranteed to work.
IFS=$'\n'

# Process each path
for path in $(sed 's/<Path>/\n<Path>/g;s/<\/Path>/\n/g' "$inputfile" | awk '/<Path>/{sub("<Path>", ""); print}') ; do 
  # Trim possible windows CR
  path="${path%\r}"

  dir=$(dirname -- "$path")
  filename=$(basename -- "$path")

  if [[ "$filename" =~ %([^%]+)% ]]; then
    fmt="${BASH_REMATCH[1]}"
    # If format looks like .NET style (contains y or d letters), try to convert
    fmt=$(dotnet_to_strftime "$fmt")
    dateval=$(format_date "$fmt")
    newfilename="${filename//%${BASH_REMATCH[1]}%/$dateval}"
  else
    dateval=$(format_date "$dateformat")
    newfilename="$dateval$separator$filename"
  fi

  target="$dir/$newfilename"
  printf "rename '%s' to '%s'\n" "$path" "$target" >>"$logFile"

  # Attempt to move file. This assumes POSIX paths. On native Windows paths (C:\...) this may fail under pure bash.
  if mv -f -- "$path" "$target" 2>>"$logFile"; then
    :
  else
    printf "Error moving '%s' -> '%s'\n" "$path" "$target" >>"$logFile"
  fi
done

printf "Finished 'AddCurrentDate' at %s\n" "$(date)" >>"$logFile"
