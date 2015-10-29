#!/bin/bash
set -ex
groupadd --gid "${USER_GID}" "${USER_GROUP}"
useradd -m --uid "${USER_UID}" \
	--gid "${USER_GID}" "${USER_NAME}"
su -c "kicad '${KICAD_PROJECT}'" -l "${USER_NAME}"
