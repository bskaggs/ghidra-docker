#!/bin/bash
GHIDRA_CLASSPATH="$(sed 's/.*\(${ghidra_home}\)/\1/g' "${ghidra_home}/Ghidra/Features/GhidraServer/data/classpath.frag" | sed ':a;N;$!ba;s/\n/:/g'| envsubst )"
: ${GHIDRA_REPOSITORIES_PATH:=/srv/repositories}
#create the users on startup, if users file doesn't exist
if [ ! -e "${GHIDRA_REPOSITORIES_PATH}/users" ] && [ ! -z "${GHIDRA_DEFAULT_USERS}" ]; then
  mkdir -p "${GHIDRA_REPOSITORIES_PATH}/~admin"
  for GHIDRA_DEFAULT_USER in ${GHIDRA_DEFAULT_USERS//,/ }; do
    echo "Creating user ${GHIDRA_DEFAULT_USER} with default password 'changeme'"
    echo "-add ${GHIDRA_DEFAULT_USER}" >> "${GHIDRA_REPOSITORIES_PATH}/~admin/adm.cmd"
  done
fi
exec java \
  -classpath "${GHIDRA_CLASSPATH}" \
  -Djava.net.preferIPv4Stack=true \
  -DApplicationRollingFileAppender.maxBackupIndex=10 \
  -Dclasspath_frag="${ghidra_home}/Ghidra/Features/GhidraServer/data/classpath.frag" \
  -Ddb.buffers.DataBuffer.compressedOutput=true \
  -Djava.library.path="${ghidra_home}/Ghidra/Features/GhidraServer/os/linux64" \
  -XX:InitialRAMPercentage=10 \
  -XX:MinRAMPercentage=10 \
  -XX:MaxRAMPercentage=80 \
  -Djava=/usr/bin/java \
  -Dos_dir="${ghidra_home}/Ghidra/Features/GhidraServer/os/linux64" \
  -Dghidra_home="${ghidra_home}" \
  -Djna_tmpdir=/tmp \
  ghidra.server.remote.GhidraServer \
  -a0 \
  ${GHIDRA_FLAGS:+"$GHIDRA_FLAGS"} \
  "${GHIDRA_REPOSITORIES_PATH}"
