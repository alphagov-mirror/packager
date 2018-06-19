#!/bin/bash

set -e

supported_distros=(trusty xenial)

usage() {
  echo "Usage: $0 -d DISTRO -r RECIPE [-x]"
  echo
  echo "  Option    Or env. variable   "
  echo "      -d    DISTRO             One of (${supported_distros[*]})"
  echo "      -r    RECIPE             Recipe to build"
  echo "      -x                       Bash \`set -x\` (trace)"
  echo "      -s                       Debugging shell"
  exit 0
}

while getopts "d:r:xihs" opt
do
  case "$opt" in
    d) DISTRO="$OPTARG" ;;
    r) RECIPE="$OPTARG" ;;
    i) in_container=1 ;;
    x) set -x ;;
    s) debug_shell=1 ;;
    h) usage ;;
    *) usage ;;
  esac
done

: "${DISTRO?"Not specified (pass -d option or set environment variable)"}"
: "${RECIPE?"Not specified (pass -r option or set environment variable)"}"

if ! [[ "${supported_distros[*]}" =~ $DISTRO ]]
then
  echo "Supported distros: ${supported_distros[*]}"
  exit 1
fi

if [[ "$in_container" == 1 ]]
then
  cd "/build/${RECIPE}"
  rm -rf cache tmp-build tmp-dest
  fpm-cook
else
  dockerfile="Dockerfile.$DISTRO"
  docker build -f "$dockerfile" --tag "alphagov-packager:${DISTRO}" .
  export DISTRO
  export RECIPE

  if [[ "$debug_shell" == 1 ]]
  then
    docker run -it \
      --mount type=bind,source="$(pwd)/recipes",target=/build \
      --env RECIPE --env DISTRO --entrypoint=/bin/bash \
      "alphagov-packager:${DISTRO}"
  else
    docker run -it \
      --mount type=bind,source="$(pwd)/recipes",target=/build \
      --env RECIPE --env DISTRO \
      "alphagov-packager:${DISTRO}"
  fi
fi

