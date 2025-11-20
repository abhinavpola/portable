# Define a helper to stack a PR on top of the current branch using gh + git-town
def gt-get [pr_ref: string] {
    if ($pr_ref | is-empty) {
        print "Usage: gt-get <pr-number-or-ref>"
        return
    }

    # Save current branch as parent
    let parent_branch = (git rev-parse --abbrev-ref HEAD | str trim)

    # Checkout PR via gh
    ^gh pr checkout $pr_ref

    # Set the PR branch's Git Town parent to the previous branch
    ^git town set-parent $parent_branch

    # Show Git Town branch structure
    ^git town branch
}

alias cat = bat
alias gt = git-town