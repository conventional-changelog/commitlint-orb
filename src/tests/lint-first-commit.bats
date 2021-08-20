setup() {
  cd "$BATS_SUITE_TMPDIR" || exit
  yarn add @commitlint/config-conventional -s

  export git_dir="${BATS_TEST_TMPDIR}/git_dir"
  mkdir -p "$git_dir" && cd "$git_dir" || exit

  git init
  echo "module.exports = {extends: ['@commitlint/config-conventional']}" > "commitlint.config.js"
  export CL_PARAM_CONFIG_PATH="commitlint.config.js"
}

main() {
  bash "$BATS_TEST_DIRNAME/../../src/scripts/lint.sh"
}

test_commit() {
  local message="$1"

  echo -e "${message}\n" >> file.txt
  git add file.txt && git commit -m "$message"
}

@test 'Test linting the fist bad commit' {
  test_commit "bad: commit"
  echo "Commit Created"
  export current_branch="$(git rev-parse --abbrev-ref HEAD)"
  echo "Current branch: $current_branch"
  export CIRCLE_BRANCH="$current_branch"
  export CL_PARAM_TARGET_BRANCH="$current_branch"
  run main
  [[ "$output" == *"found 1 problems, 0 warnings"* ]]
  [[ "$output" == *"[type-enum]"* ]]
}

@test 'Test linting the fist good commit' {
  test_commit "chore: setup"

  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  export CIRCLE_BRANCH="$current_branch"
  export CL_PARAM_TARGET_BRANCH="$current_branch"

  run main
  [[ "$output" == *"found 0 problems, 0 warnings"* ]]
}

@test 'Test linting with no commits' {
  export CIRCLE_BRANCH="main"
  export CL_PARAM_TARGET_BRANCH="main"

  run main
  [[ "$output" == *"[WARNING] There are no commits in the log to lint."* ]]
}

@test 'Test linting the history on the same branch' {
  test_commit "bad: commit"

  for i in {1..5}; do
    test_commit "chore: add $i"
  done

  export current_branch="$(git rev-parse --abbrev-ref HEAD)"
  export CIRCLE_BRANCH="$current_branch"
  export CL_PARAM_TARGET_BRANCH="$current_branch"

  run main
  echo "$output"
  [[ "$output" == *"found 1 problems, 0 warnings"* ]]
  [[ "$output" == *"[type-enum]"* ]]
}

