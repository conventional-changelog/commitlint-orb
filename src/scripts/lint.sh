#!/bin/bash
ORB_TEST_ENV="bats-core"
#if [ "${0#*$ORB_TEST_ENV}" != "$0" ]; then
    #if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi
    # $SUDO npm install -g @commitlint/cli "$CL_PARAM_CONFIGS"
#fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"
target_branch="$CL_PARAM_TARGET_BRANCH"
git_log="$(git log --reverse --max-count=1000 --format="format:%H")"

if [ -z "$git_log" ]; then
  echo "[WARNING] There are no commits in the log to lint."
  exit 0
fi

if [ $((echo "$git_log" | wc -l)) -eq 1 ]; then
  target_head="HEAD"
elif [ "$current_branch" != "$target_branch" ]; then
  target_head="$(git cherry "$target_branch~1" | head -1 | cut -d " " -f2-)"
else
  target_head="$(echo "$git_log" | head -1)"
fi

commitlint --verbose --config "$CL_PARAM_CONFIG_PATH" --from "$target_head"
