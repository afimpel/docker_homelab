#!/bin/bash

# Function to check and perform a git pull if there are new remote commits
check_and_pull_updates() {
    CUSTOM_RIGHT $NC 'GIT' $LIGHT_CYAN "check update" $WHITE "☐" " " "☐" 0

    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        rightH1 $WHITE "Error: You are not in a Git repository. Please navigate to the root of your repository." $LIGHT_RED '✘' " "
        return 1
    fi
    if ! git fetch; then
        rightH1 $WHITE "Error: Could not fetch remote updates." $LIGHT_RED '✘' " "
        rightH1 $WHITE "Make sure you have an internet connection and permissions for the repository." $LIGHT_RED '✘' " "
        return 1
    fi
    local upstream_branch
    upstream_branch=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)

    if [ -z "$upstream_branch" ]; then
        rightH1 $WHITE "Warning: Your current branch does not have a remote tracking branch configured." $LIGHT_RED '✘' " "
        rightH1 $WHITE "Cannot automatically check for new remote commits."  $LIGHT_RED '✘' " "
        rightH1 $WHITE "You can set it with 'git branch --set-upstream-to=origin/your_remote_branch'."  $LIGHT_RED '✘' " "
        return 0 # Not a fatal error, just cannot check
    fi
    local new_commits_count
    new_commits_count=$(git rev-list --count HEAD..@{u})

    if [ "$new_commits_count" -gt 0 ]; then
        rightH1 $WHITE "----------------------------------------------------"  $WHITE '☐' " "
        rightH1 $WHITE "Attention! There are $new_commits_count new commits in the remote branch '$upstream_branch'." $WHITE '☐' " "
        rightH1 $WHITE "----------------------------------------------------" $WHITE '☐' " "
        read -p "Do you want to perform a 'git pull' to get and merge them? [y/N]: " confirm_pull
        confirm_pull=${confirm_pull,,} # Convert response to lowercase for flexible comparison

        if [[ "$confirm_pull" == "y" || "$confirm_pull" == "yes" ]]; then
            rightH1 $WHITE "Performing 'git pull'..." $WHITE '☐' " "
            if git pull; then
                rightH1 $WHITE "'git pull' completed successfully! Your local branch is now up to date." $LIGHT_GREEN '✔' " "
            else
                rightH1 $WHITE "Error: 'git pull' failed." $LIGHT_RED '✘' " "
                rightH1 $WHITE "You may need to resolve merge conflicts manually or check the status of your repository." $LIGHT_RED '✘' " "
                return 1
            fi
        else
            rightH1 $WHITE "'git pull' operation cancelled. Your local branch has not been updated." $LIGHT_RED '✘' " "
        fi
    else
        rightH1 $WHITE "Your local branch is up to date with the remote branch '$upstream_branch'. No new commits." $LIGHT_GREEN '✔' " "
    fi
    echo " "
}