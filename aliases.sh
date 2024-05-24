#! /bin/bash

#Navigation
alias cddev='cd ${DEV_DIR}'

# AWS
alias ssologin="aws sso login"

aws-all() {
    setopt local_options no_nomatch

    profiles=("${(@f)$(aws configure list-profiles)}")

    command=("$@")

    echo "Running command: ${command[*]}"

    for profile in "${profiles[@]}"; do
        if [[ "$profile" == "default" ]]; then
            continue
        fi

        echo "---- Running command on profile: $profile ----"
        eval "aws ${command[*]} --profile $profile"
        echo
        echo
    done

    unsetopt nomatch
}

# Git
get_default_branch() {
    if git show-ref --quiet refs/heads/main; then
        default_branch="main"
        # Check if "master" exists as a branch (fallback)
    elif git show-ref --quiet refs/heads/master; then
        default_branch="master"
    else
        echo "Unable to determine the default Git branch (neither main nor master exist)."
        exit 1
    fi

    echo $default_branch
}

gfc() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    modified_string="${current_branch//_/ }"
    modified_string="${modified_string/\//: }"
    modified_string="${modified_string/%-/-}"

    git add -A

    git commit -am "${modified_string}"
}

alias git_branchname="git rev-parse --abbrev-ref HEAD"

alias gcopm='gco $(get_default_branch) && git pull'

# Node

alias npkill="npx npkill"

# Autocomplete all aliases
# Define a custom completion function to complete aliases and functions
_custom_alias_function_completions() {
    local -a aliases_and_functions
    # Populate the array with aliases and functions from your .aliases file
    # shellcheck disable=SC2034
    aliases_and_functions=( "$(cat ~/.aliases)" )
    # Use compadd to add them as completion options
    compadd -a aliases_and_functions
}

# Associate the custom completion function with all commands
compdef _custom_alias_function_completions '*'
