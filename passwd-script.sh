#!/bin/bash

# This script generates a random password.
# The user can set the password length with -l and add a special character with -s.
# Verbose mode can be enabled with -v. 

usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo '  -l LENGTH  Specify the passwrod length.'
  echo '  -s         Append a special character to the password.'
  echo '  -v         Increase verbosity.'
  exit 1
}

# Im using "log" here for this function as an example, I suggest renaming. 
log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi 
}

# Set a default passwoird length
LENGTH=32

while getopts vl:s OPTION
do
  case ${OPTION} in
    v)
      VERBOSE='ture'
      log 'Verbose mode on.'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    S)
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
   esac
done

log 'Generating a password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
   log 'Selecting a random special character.'
   SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w2 | shuf | head -c2)
   PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done'
log 'Here is the password:'

# Display the password.
echo "${PASSWORD}"

exit 0
