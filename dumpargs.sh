#!/usr/bin/env bash

dumpargs=$(mktemp)
chmod +x ${dumpargs}

cat > ${dumpargs} <<'EOF' 
#!/usr/bin/env bash
EOF
echo INTERPETER_NAME=$(basename ${dumpargs}) >> ${dumpargs}
cat >> ${dumpargs} <<'EOF'

echo --------------------------------------------------------------------------
echo Arguments received by dumpargs \(${INTERPETER_NAME}\):
echo ---
for i in `seq 0 $#`; do
  echo "$i": ${@:$i:1}
done

# Possibly called as a script interpreter
if [[ -x "$1" && ! -z "$(sed '1q;d' "$1" | grep ${INTERPETER_NAME})" ]]; then
  SCRIPT_ARGINDEX=1
elif [[ -x "$2" && ! -z "$(sed '1q;d' "$2" | grep ${INTERPETER_NAME})" ]]; then
  SCRIPT_ARGINDEX=2
fi
if [[ ${SCRIPT_ARGINDEX} ]]; then
  SCRIPT=${@:${SCRIPT_ARGINDEX}:1}
  REAL_INTERP="$(sed '2q;d' ${SCRIPT} | sed -E 's/^#![ ]*//')"
  set -x
  exec ${REAL_INTERP} "${SCRIPT}" ${@:(( SCRIPT_ARGINDEX+1 ))}
fi
EOF

function interp() {
  echo --------------------------------------------------------------------------
  echo Using dumpargs as interpreter
  echo ---
  tmpscript=$(mktemp)
  chmod +x $tmpscript

  echo "#!${dumpargs}" > ${tmpscript}
  cat >> ${tmpscript} <<'EOF'
#!/usr/bin/env bash
echo This script received: $@
EOF
  ${tmpscript} arg1 arg2
  echo --------------------------------------------------------------------------
}

function interp_arg() {
  echo --------------------------------------------------------------------------
  echo Using dumpargs as interpreter and pass an argument
  echo ---
  tmpscript=$(mktemp)
  chmod +x $tmpscript

  echo "#!${dumpargs} arg" > ${tmpscript}
  cat >> ${tmpscript} <<'EOF'
#!/bin/sh -xe
echo This script received: $@
EOF
  ${tmpscript} arg1 arg2
}

function interp_env() {
  echo --------------------------------------------------------------------------
  echo Using dumpargs as interpreter via env
  echo ---
  tmpscript=$(mktemp)
  chmod +x $tmpscript

  echo "#!/usr/bin/env $(basename ${dumpargs})" > ${tmpscript}
  cat >> ${tmpscript} <<'EOF'
#!/usr/bin/env bash
echo This script received: $@
EOF
  PATH=$(dirname ${tmpscript}):$PATH ${tmpscript} arg1 arg2
}

function interp_env_python() {
  echo --------------------------------------------------------------------------
  echo Using dumpargs as interpreter via env
  echo ---
  tmpscript=$(mktemp)
  chmod +x $tmpscript

  echo "#!/usr/bin/env $(basename ${dumpargs})" > ${tmpscript}
  cat >> ${tmpscript} <<'EOF'
#!/usr/bin/env python
import sys
print(sys.argv)
EOF
  PATH=$(dirname ${tmpscript}):$PATH ${tmpscript} arg1 arg2
}

function relpath() {
  echo --------------------------------------------------------------------------
  echo Calling dumpargs with relative path
  echo ---
  pushd $(dirname ${dumpargs})
  ./$(basename ${dumpargs}) arg1 arg2
}

for f in $(compgen -A function); do
  $f
done
