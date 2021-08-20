setup() {
  cd "$BATS_SUITE_TMPDIR" || exit
  yarn add @commitlint/config-conventional

  export git_dir="${BATS_TEST_TMPDIR}/git_dir"
  mkdir -p "$git_dir" && cd "$git_dir" || exit

  git init

  for i in {1..5}; do
    test_commit "chore: add $i"
  done

  target_branch="$(git rev-parse --abbrev-ref HEAD)"
  git checkout -b "$BATS_TEST_NAME"
  current_branch="$(git rev-parse --abbrev-ref HEAD)"

  export CIRCLE_BRANCH="$current_branch"
  export CL_PARAM_TARGET_BRANCH="$target_branch"
  export CL_PARAM_CONFIG_PATH="commitlint.config.js"

  echo "module.exports = {extends: ['@commitlint/config-conventional']}" > "commitlint.config.js"
}

main() {
  bash "$BATS_TEST_DIRNAME/../../src/scripts/lint.sh"
}

test_commit() {
  local message="$1"

  echo -e "${message}\n" >> file.txt
  git add file.txt && git commit -m "$message"
}

@test 'Test linting on one bad commit' {
  test_commit "bad: commit"

  run main
  [[ "$output" == *"found 1 problems, 0 warnings"* ]]
  [[ "$output" == *"[type-enum]"* ]]
}

@test 'Test linting on one good commit' {
  test_commit "chore: commit"

  run main
  [[ "$output" == *"found 0 problems, 0 warnings"* ]]
}

@test 'Test linting the body of a commit' {
  test_commit "chore: this is a commit with a long body

Long line in the body should fail Lorem Ipsum is simply dummy text of the printing and typesetting industry Long line in the body should fail Lorem Ipsum is simply dummy text of the printing and typesetting industry.
"
  run main
  [[ "$output" == *"found 1 problems, 0 warnings"* ]]
  [[ "$output" == *"[body-max-line-length]"* ]]
}

@test 'Test linting multiple commits with only one bad one' {
  test_commit "bad: commit"

  for i in {1..5}; do
    test_commit "chore: this is a commit"
  done

  run main
  [[ "$output" == *"found 1 problems, 0 warnings"* ]]
  [[ "$output" == *"[type-enum]"* ]]
}

@test 'Test linting multiple commits that are all good' {
  for i in {1..10}; do
    test_commit "chore: this is a commit"
  done

  run main
  [[ "$output" == *"found 0 problems, 0 warnings"* ]]
}

@test 'Test rely bad' {
  for i in {1..5}; do
    test_commit "chore: this is a commit"
  done

  for i in {1..5}; do
    test_commit "this is a commit commit $1"
  done

  for i in {1..10}; do
    test_commit "chore: this is a commit"
  done

  run main
  error_count="$(echo "${output#0}" | grep -c "found 2 problems, 0 warnings")"
  [[ $error_count -eq 5 ]]
}

@test 'Test linting on the same branch' {
  test_commit "bad: commit"

  for i in {1..5}; do
    test_commit "chore: this is a commit"
  done

  export CL_PARAM_TARGET_BRANCH="$CIRCLE_BRANCH"

  run main
  [[ "$output" == *"found 1 problems, 0 warnings"* ]]
  [[ "$output" == *"[type-enum]"* ]]
}
