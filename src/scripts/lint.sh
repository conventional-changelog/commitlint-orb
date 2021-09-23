#!/bin/bash
if ! command -v commitlint &> /dev/null
then
  if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi
  $SUDO npm install -g @commitlint/cli "$CL_PARAM_CONFIGS"
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"
target_branch="$CL_PARAM_TARGET_BRANCH"
git_log="$(git log --max-count="$CL_PARAM_MAX_COUNT" --reverse --format="format:%H")"

if [ -z "$git_log" ]; then
  echo "[WARNING] There are no commits in the log to lint."
  exit 0
fi

# If there is only one commit, set target_head to that commit
if [ "$(echo "$git_log" | wc -l | xargs)" == "1" ]; then
  target_head=""
  echo "DEBUG: Single Commit"
# If the current branch is not the target branch
elif [ "$current_branch" != "$target_branch" ]; then
  # Using the ^ at the end git logs lower bound is not inclusive
  target_head="$(git cherry "$target_branch" | head -1 | cut -d " " -f2-)^"
  echo "DEBUG: Different Branch"
# If on the same branch as the target. (merge)
else
  # The goal here should be to lint the commit history as far back as
  # set via CL_PARAM_MAX_COUNT
  # We must ensure the first (root) commit message is included in this range.
  target_head="$(echo "$git_log" | head -1)"
fi

echo "Linting from commit: $target_head"

# "From"'s lower bound is not inclusive. The SHA1 specified here will not be linted.'
commitlint --verbose --config "$CL_PARAM_CONFIG_PATH" --from="$target_head"
