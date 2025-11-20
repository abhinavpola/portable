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

def gtma [] {
    git add -A
    git commit --amend --no-edit
}

def gtpr [] {
    # Try to open existing PR for current branch
    ^gh pr view --web

    # Otherwise create one
    if $env.LAST_EXIT_CODE != 0 {
        print "No PR found for this branch, creating one..."
        ^gh pr create --web
    }
}

alias cat = bat
alias gt = git-town
alias gts = git push --force-with-lease
alias ghme = gh pr list --author @me --state open

def gtms [] {
    gtma
    gts
}

def mem [top_n: int = 25] {
    ps | sort-by mem | reverse | first $top_n | select pid name mem
}

$env.config.show_banner = false

# Starship config at the end
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
starship preset no-runtime-versions -o ~/.config/starship.toml
