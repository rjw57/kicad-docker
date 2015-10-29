#!/bin/bash
set -ex
groupadd --gid "${USER_GID}" "${USER_GROUP}"
useradd -m --uid "${USER_UID}" \
	--gid "${USER_GID}" "${USER_NAME}"
mkdir -p "/home/${USER_NAME}/.config/"
ln -s "/kicad/config" "/home/${USER_NAME}/.config/kicad"
su -c "bash" -l "${USER_NAME}"
#su -c "kicad '${KICAD_PROJECT}'" -l "${USER_NAME}"
