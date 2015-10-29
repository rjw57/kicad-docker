#!/bin/bash
set -e

DOCKER_IMAGE_NAME="rjw57/kicad"

function show_help() {
	cat <<__END__
usage: $PROGNAME [-i <image name>] <project>
__END__
}

PROGNAME=$(basename "$0")
OPTIND=1
while getopts "hi:" opt; do
	case "$opt" in
	h)
		show_help
		exit 0
		;;
	i)
		DOCKER_IMAGE_NAME="${OPTARG}"
		;;
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

if [ "$#" -ne 1 ]; then
	show_help
	exit 0
fi

PROJECT_PATH=$(readlink -f "$1")
PROJECT_DIRECTORY=$(dirname "${PROJECT_PATH}")
PROJECT_FILENAME=$(basename "${PROJECT_PATH}")

DOCKER=$(which docker)
if [ -z "${DOCKER}" ]; then
	echo "Docker not found on PATH"
	exit 1
fi

if [ -z "${DISPLAY}" ]; then
	echo "DISPLAY not set"
	exit 1
fi

X11_SOCK_DIR=/tmp/.X11-unix
if [ ! -d "${X11_SOCK_DIR}" ]; then
	echo "Cannot find X11 socket directory at ${X11_SOCK_DIR}."
fi

XAUTH=$(mktemp --tmpdir docker.xauth.XXXXXX)
touch "${XAUTH}"
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -

CONTAINER_PROJECT="/project"
export USER_UID=$(id -u)
export USER_GID=$(id -g)
export USER_GROUP=$(id -gn)
export USER_NAME=$(id -un)
export KICAD_PROJECT="${CONTAINER_PROJECT}/${PROJECT_FILENAME}"
docker run -it \
	-e DISPLAY -e USER_NAME -e USER_GROUP -e USER_UID -e USER_GID \
	-e KICAD_PROJECT\
	-v "${X11_SOCK_DIR}:${X11_SOCK_DIR}:rw" \
	-v "${XAUTH}:${XAUTH}:rw" -e "XAUTHORITY=${XAUTH}" \
	-v "${PROJECT_DIRECTORY}:${CONTAINER_PROJECT}:rw" \
	"${DOCKER_IMAGE_NAME}"
