#!/usr/bin/env bash

bash --version
reldir=$(dirname "$0")

echo "Rel dir: ${reldir}"
echo "PWD: $(pwd)"


bash "${reldir}/install.sh"

echo RUN