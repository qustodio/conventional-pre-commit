#!/usr/bin/env bash

this_dir="$PWD"
test_dir=""
result=0

setup () {
    test_dir=$(mktemp -d)

    cd "$test_dir"

    git init
    echo "$(touch README.md && git add . && git commit -m 'Initial Commit')" > /dev/null

    cp "$this_dir/.pre-commit-config.yaml" "$test_dir/"
    cp "$this_dir/conventional-pre-commit.sh" "$test_dir/"

    git branch -m main
    git config user.email "conventional-pre-commit@compiler.la"
    git config user.name "conventional-pre-commit"

    pre-commit install --hook-type commit-msg
    git add .
}

teardown () {
    cd "$this_dir"
    rm -rf "$test_dir"
}

# test a failure

setup

fail="$(git commit -m 'bad: conventional-pre-commit' 2>&1 > /dev/null)"

teardown

echo "$fail" | grep -Eq "Your commit message does not follow Conventional Commits formatting"
(( result += "$?" ))

# test a success

setup

pass="$(git commit -m 'test: conventional-pre-commit')"

teardown

echo "$pass" | grep -Pq "\[main ([a-z|\d]{7})\] test: conventional-pre-commit"
(( result += "$?" ))

! echo "$pass" | grep -Eq "Your commit message does not follow Conventional Commits formatting"
(( result += "$?" ))


# test a merge commit

setup

merge="$(git commit -m 'Merged in bug/something (pull request #something)')"

teardown

echo "$merge" | grep -Pq "\[main ([a-z|\d]{7})\] Merged in bug\/something \(pull request #something\)"
(( result += "$?" ))

! echo "$merge" | grep -Eq "Your commit message does not follow Conventional Commits formatting"
(( result += "$?" ))


# test a revert commit

setup

revert="$(git commit -m 'This reverts commit something.')"

teardown

echo "$revert" | grep -Pq "\[main ([a-z|\d]{7})\] This reverts commit something."
(( result += "$?" ))

! echo "$revert" | grep -Eq "Your commit message does not follow Conventional Commits formatting"
(( result += "$?" ))

exit "$result"
