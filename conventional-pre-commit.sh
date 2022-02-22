#!/usr/bin/env bash

# list of Conventional Commits types
cc_types=("feat" "fix")
default_types=("build" "chore" "ci" "docs" "${cc_types[@]}" "perf" "refactor" "revert" "style" "test")
types=( "${cc_types[@]}" )

if [ $# -eq 1 ]; then
    types=( "${default_types[@]}" )
else
    # assume all args but the last are types
    while [ $# -gt 1 ]; do
        types+=( "$1" )
        shift
    done
fi

# the commit message file is the last remaining arg
msg_file="$1"

# join types with | to form regex ORs
r_types="($(IFS='|'; echo "${types[*]}"))"
# optional (scope)
r_scope="(\([[:alnum:] \/-]+\))?"
# optional breaking change indicator and colon delimiter
r_delim='!?:'
# subject line, body, footer
r_subject=" [[:alnum:]].+"
# the full regex pattern
pattern="^$r_types$r_scope$r_delim$r_subject$"

# Check if commit is conventional commit
if grep -Eq "$pattern" "$msg_file"; then
    exit 0
fi

printf "\e[48;5;226m---[WARNING] This is not a Conventional Commit---\e[0m\n"
printf "\e[48;5;226m[Commit message] $( cat "$msg_file" )\e[0m\n"
printf "
\e[48;5;226mYour commit message does not follow Conventional Commits formatting\e[0m
\e[48;5;226mhttps://www.conventionalcommits.org/\e[0m

Conventional Commits start with one of the below types, followed by a colon,
followed by the commit message:

    $(IFS=' '; echo "${types[*]}")

Example commit message adding a feature:

    feat: implement new API

Example commit message fixing an issue:

    fix: remove infinite loop

Optionally, include a scope in parentheses after the type for more context:

    fix(account): remove infinite loop

\e[48;5;226mThis WARNING will be soon an\e[0m \e[48;5;196m ERROR \e[0m
"
exit 1
