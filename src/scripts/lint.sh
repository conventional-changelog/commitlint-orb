#!/bin/bash

#!/bin/bash
if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi
$SUDO npm install -g @commitlint/cli "$CL_PARAM_CONFIGS"

current_branch="$(git rev-parse --abbrev-ref HEAD)"
target_branch="$CL_PARAM_TARGET_BRANCH"
git_log="$(git log --reverse --max-count=1000 --format="format:%H")"

if [ -z "$git_log" ]; then
  echo "[WARNING] There are no commits in the log to lint."
  exit 0
fi

# If there is only one commit, set target_head to that commit
if [ "$(echo "$git_log" | wc -l | xargs)" == "1" ]; then
  echo "Setting target to HEAD^"
  target_head=""
  echo "Target Head = $target_head"
elif [ "$current_branch" != "$target_branch" ]; then
  echo "Setting target to $target_branch"
  target_head="$(git cherry "$target_branch~1" | head -1 | cut -d " " -f2-)"
  echo "Target Head = $target_head"
else
  echo "Setting target to HEAD -1"
  commit="$(echo "$git_log" | head -1)"
  target_head="$(git log "$commit^" -1 pretty=%H)"
fi
set +x
commitlint -v
commitlint --verbose --config "$CL_PARAM_CONFIG_PATH" --from="$target_head"
echo $?
echo "Ended"
