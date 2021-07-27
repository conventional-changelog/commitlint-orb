#!/bin/bash
if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi

$SUDO npm install -g @commitlint/cli "$CL_PARAM_CONFIGS"
# shellcheck disable=SC2005
git cherry -v "$CL_PARAM_TARGET_BRANCH" "$CIRCLE_BRANCH" | while read -r line; do echo "$line" | cut -d ' ' -f3- | commitlint -V -g "$CL_PARAM_CONFIG_PATH"; done