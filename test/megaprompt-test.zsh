#!/usr/bin/env zsh

# Tests for zsh-megaprompt.
# Run with: zsh test/megaprompt-test.zsh
# Exits nonzero if any test fails.

emulate -L zsh
zmodload zsh/datetime

typeset -g TEST_DIR="${0:A:h}"
typeset -g PLUGIN="${TEST_DIR:h}/zsh-megaprompt.plugin.zsh"

typeset -g TESTS_RUN=0
typeset -g TESTS_FAILED=0
typeset -g CURRENT_TEST=""
typeset -g OLDPWD_SAVE=""

fail() {
    print -u2 "FAIL: $CURRENT_TEST: $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

assert-equal() {
    # assert-equal EXPECTED ACTUAL [MESSAGE]
    if [[ "$1" != "$2" ]]; then
        fail "${3:-values differ}: expected [$1], got [$2]"
    fi
}

assert-contains() {
    # assert-contains HAYSTACK NEEDLE [MESSAGE]
    if [[ "$1" != *"$2"* ]]; then
        fail "${3:-missing substring}: [$2] not found in [$1]"
    fi
}

assert-not-contains() {
    # assert-not-contains HAYSTACK NEEDLE [MESSAGE]
    if [[ "$1" == *"$2"* ]]; then
        fail "${3:-unexpected substring}: [$2] found in [$1]"
    fi
}

run-test() {
    CURRENT_TEST="$1"
    TESTS_RUN=$((TESTS_RUN + 1))
    local before_failed=$TESTS_FAILED
    # Reload the plugin from scratch for each test so that config changes
    # don't leak, including anything detected at load time.
    unset MEGAPROMPT_STYLES MEGAPROMPT_GIT_STYLES MEGAPROMPT_KEYMAP_IND \
          MEGAPROMPT_DISPLAY_P MEGAPROMPT_MISC MEGAPROMPT_TIMEOUTS
    source "$PLUGIN" 2>/dev/null
    test-setup
    "$1"
    test-teardown
    if [[ $TESTS_FAILED -eq $before_failed ]]; then
        print "ok: $1"
    fi
}

typeset -g SANDBOX=""
typeset -g REPO=""

suite-setup() {
    SANDBOX="$(mktemp -d)"

    # A repo that is dirty, has an untracked file, and has no upstream branch,
    # so that every git status mark except the submodule one is triggered.
    REPO="$SANDBOX/repo"
    mkdir -p "$REPO"
    (
        cd "$REPO"
        export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
        export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
        export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
        git init -q -b testbranch .
        print tracked > tracked-file
        git add tracked-file
        git commit -q -m 'initial'
        print modified > tracked-file
        print untracked > untracked-file
    )
}

# Keep the user's git configuration out of the repos the tests build and inspect.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
# Submodules are cloned from local paths, which git refuses by default.
export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=protocol.file.allow GIT_CONFIG_VALUE_0=always

# make-repo DIR: a repo at DIR with one commit.
make-repo() {
    git init -q -b main "$1"
    git -C "$1" commit -q --allow-empty -m 'initial'
}

# make-repo-with-submodule DIR: a repo at DIR whose submodule "sub" is a clone
# of DIR-upstream, with everything pushed.
make-repo-with-submodule() {
    make-repo "$1-upstream"
    make-repo "$1"
    git -C "$1" submodule -q add "$1-upstream" sub
    git -C "$1" commit -q -m 'add submodule'
}

suite-teardown() {
    [[ -n "$SANDBOX" ]] && rm -rf "$SANDBOX"
}

test-setup() {
    # Use plain ASCII markers so that assertions are readable.
    MEGAPROMPT_STYLES[git_dirty_mark]="<DIRTY>"
    MEGAPROMPT_STYLES[git_submodule_dirty_mark]="<SUBDIRTY>"
    MEGAPROMPT_STYLES[git_submodule_unpushed_mark]="<SUBUNPUSHED>"
    MEGAPROMPT_STYLES[git_submodule_unpushed_mark_end]="</SUBUNPUSHED>"
    MEGAPROMPT_STYLES[git_worktrees_mark]="<WORKTREES>"
    MEGAPROMPT_STYLES[git_untracked_mark]="<UNTRACKED>"
    MEGAPROMPT_STYLES[git_no_remote_tracking_mark]="<NOREMOTE>"
    MEGAPROMPT_STYLES[git_timeout_mark]="<TIMEOUT>"
    MEGAPROMPT_STYLES[git_branch_unknown]="<UNKNOWN>"
    MEGAPROMPT_STYLES[extras_off_mark]="<EXTRASOFF>"
    MEGAPROMPT_STYLES[dir_mount_point]="<MOUNT>"
    MEGAPROMPT_STYLES[dir_not_mount_point]="<NOMOUNT>"
    MEGAPROMPT_STYLES[dir_git_root]="<GITROOT>"
    MEGAPROMPT_STYLES[dir_vcs_unspecial]="<UNSPECIAL>"
    MEGAPROMPT_STYLES[dir_owner]="<OWNER>"
    MEGAPROMPT_STYLES[dir_group]="<GROUP>"
    MEGAPROMPT_STYLES[dir_write]="<WRITE>"
    MEGAPROMPT_STYLES[dir_nowrite]="<NOWRITE>"
    MEGAPROMPT_STYLES[git_branch_brackets]=""
    MEGAPROMPT_STYLES[git_default_branch_color]=""
    OLDPWD_SAVE="$PWD"
}

test-teardown() {
    cd "$OLDPWD_SAVE"
}

################################################################################
# -mp-timeout-command
################################################################################

test-timeouts-disabled-run-the-command-directly() {
    local out
    MEGAPROMPT_MISC[timeout_method]=none
    MEGAPROMPT_TIMEOUTS[git_dirty]=0.001
    out="$(-mp-timeout-command git_dirty sh -c 'sleep 0.2; echo hi')"
    assert-equal "hi" "$out" "output should pass through untimed"
    -mp-timeout-command git_dirty sh -c 'exit 3'
    assert-equal 3 $? "exit status should pass through untimed"
}

test-timeout-method-defaults-to-native() {
    assert-equal "native" "${MEGAPROMPT_MISC[timeout_method]}" \
        "a zsh with the needed modules should time commands itself"
}

test-timeout-passes-through-output-and-status() {
    local out
    MEGAPROMPT_TIMEOUTS[git_dirty]=10
    out="$(-mp-timeout-command git_dirty sh -c 'echo one; echo two; exit 7')"
    assert-equal "one
two" "$out" "all output should pass through"
    -mp-timeout-command git_dirty sh -c 'exit 7'
    assert-equal 7 $? "exit status should pass through"
}

# Output larger than a pipe buffer has to be read as it is produced, or the
# command blocks writing while the prompt waits for it to finish.
test-timeout-handles-large-output() {
    local out
    MEGAPROMPT_TIMEOUTS[git_dirty]=20
    out="$(-mp-timeout-command git_dirty seq 1 100000)"
    assert-equal "$(seq 1 100000)" "$out" "large output should come through intact"
}

test-timeout-gives-up-on-slow-command() {
    MEGAPROMPT_TIMEOUTS[git_dirty]=0.2
    local start=$EPOCHREALTIME
    -mp-timeout-command git_dirty sleep 10
    local status_=$?
    if ! -mp-timed-out-p $status_; then
        fail "slow command should have timed out, got status $status_"
    fi
    if (( EPOCHREALTIME - start > 5 )); then
        fail "slow command was not interrupted"
    fi
}

# A command that is given up on has to actually stop.  Otherwise a directory
# that hangs would leave a growing pile of stuck git processes behind, one per
# prompt.
test-timeout-stops-the-command() {
    local marker="$SANDBOX/still-running"
    rm -f "$marker"
    MEGAPROMPT_TIMEOUTS[git_dirty]=0.2
    -mp-timeout-command git_dirty sh -c "sleep 1; touch '$marker'"
    sleep 1.5
    if [[ -e "$marker" ]]; then
        fail "the command kept running after it was given up on"
    fi
}

# The whole point is to keep the prompt quick, so the wrapper itself must not
# cost anything noticeable when the command is fast.
test-timeout-is-cheap-for-fast-commands() {
    local start elapsed
    MEGAPROMPT_TIMEOUTS[git_dirty]=10
    start=$EPOCHREALTIME
    repeat 20; do
        -mp-timeout-command git_dirty true
    done
    elapsed=$(( EPOCHREALTIME - start ))
    if (( elapsed > 1 )); then
        fail "20 trivial commands took ${elapsed}s, which is too much overhead"
    fi
}

test-timeout-falls-back-to-default-duration() {
    unset "MEGAPROMPT_TIMEOUTS[git_dirty]"
    MEGAPROMPT_TIMEOUTS[default]=0.2
    -mp-timeout-command git_dirty sleep 10
    if ! -mp-timed-out-p $?; then
        fail "an unconfigured key should use the default duration"
    fi
}

test-timeout-zero-waits-as-long-as-it-takes() {
    local out
    MEGAPROMPT_TIMEOUTS[git_dirty]=0
    out="$(-mp-timeout-command git_dirty sh -c 'sleep 0.3; echo hi')"
    assert-equal "hi" "$out" "a zero duration should not impose a timeout"
}

test-timed-out-p-recognizes-the-timeout-status() {
    -mp-timed-out-p 124 || fail "124 should count as a timeout"
    if -mp-timed-out-p 0; then fail "0 should not count as a timeout"; fi
    if -mp-timed-out-p 1; then fail "1 should not count as a timeout"; fi
}

################################################################################
# git status with timeouts
################################################################################

test-git-status-shows-marks-without-timeouts() {
    local out
    cd "$REPO"
    MEGAPROMPT_TIMEOUTS[default]=20
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<DIRTY>" "modified tracked file should be reported"
    assert-contains "$out" "<UNTRACKED>" "untracked file should be reported"
    assert-contains "$out" "<NOREMOTE>" "missing upstream should be reported"
    assert-not-contains "$out" "<TIMEOUT>" "nothing timed out"
}

test-git-status-reports-timeout-instead-of-guessing() {
    local out
    cd "$REPO"
    # A duration nothing can finish within makes every git command time out.
    MEGAPROMPT_TIMEOUTS[default]=0.000001
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<TIMEOUT>" "a timeout should be reported"
    assert-not-contains "$out" "<DIRTY>" "dirtiness is unknown after a timeout"
    assert-not-contains "$out" "<UNTRACKED>" "untracked state is unknown after a timeout"
    assert-not-contains "$out" "<NOREMOTE>" "upstream state is unknown after a timeout"
}

test-git-branch-timeout-shows-unknown-branch() {
    local out
    cd "$REPO"
    # A duration nothing can finish within makes every git command time out.
    MEGAPROMPT_TIMEOUTS[default]=0.000001
    out="$(-mp-getGitBranch)"
    assert-contains "$out" "<UNKNOWN>" "an unknown branch should be indicated"
    assert-not-contains "$out" "testbranch" "the branch name is unknown after a timeout"
}

test-git-branch-shown-without-timeouts() {
    local out
    cd "$REPO"
    MEGAPROMPT_TIMEOUTS[default]=20
    out="$(-mp-getGitBranch)"
    assert-contains "$out" "testbranch" "the branch name should be shown"
    assert-not-contains "$out" "<UNKNOWN>" "the branch is known"
}

################################################################################
# worktrees
################################################################################

# The usual single worktree is not worth any space in the prompt.
test-worktree-count-shown-only-when-not-one() {
    local out
    local repo="$SANDBOX/worktrees"
    make-repo "$repo"
    cd "$repo"
    MEGAPROMPT_TIMEOUTS[default]=20
    out="$(-mp-gitStatus)"
    assert-not-contains "$out" "<WORKTREES>" "a lone worktree should not be shown"
    git worktree add -q "$SANDBOX/worktrees-other"
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<WORKTREES>2" "both worktrees should be counted"
}

################################################################################
# submodules with commits that are not on any remote
################################################################################

# The danger is pushing an outer repo that pins a submodule commit nobody else
# can fetch.  A submodule that has merely moved ahead locally is just being
# worked on, until its new commit is staged or committed in the outer repo.
test-submodule-unpushed-pin-is-reported() {
    local out
    local repo="$SANDBOX/unpushed"
    make-repo-with-submodule "$repo"
    cd "$repo"
    MEGAPROMPT_TIMEOUTS[default]=20
    out="$(-mp-gitStatus)"
    assert-not-contains "$out" "<SUBUNPUSHED>" "everything is pushed"

    git -C sub commit -q --allow-empty -m 'local only'
    out="$(-mp-gitStatus)"
    assert-not-contains "$out" "<SUBUNPUSHED>" "the outer repo does not pin the new commit yet"

    git add sub
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<SUBUNPUSHED>1</SUBUNPUSHED>" "a staged pin should be reported"

    git commit -q -m 'pin local-only commit'
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<SUBUNPUSHED>1</SUBUNPUSHED>" "a committed pin should be reported"

    git -C sub push -q origin HEAD:refs/heads/pushed
    out="$(-mp-gitStatus)"
    assert-not-contains "$out" "<SUBUNPUSHED>" "the pinned commit is on the remote now"
}

# With no remote at all, nobody else can get the pinned commit.
test-submodule-without-remote-is-reported() {
    local out
    local repo="$SANDBOX/noremote"
    make-repo-with-submodule "$repo"
    cd "$repo"
    git -C sub remote remove origin
    MEGAPROMPT_TIMEOUTS[default]=20
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<SUBUNPUSHED>1</SUBUNPUSHED>" "a pin with no remote should be reported"
}

test-nested-submodule-unpushed-pins-are-counted() {
    local out
    local repo="$SANDBOX/nested"
    make-repo-with-submodule "$repo"
    # Give the submodule a submodule of its own, then pin unpushed commits at
    # both levels.
    make-repo "$repo-inner-upstream"
    git -C "$repo/sub" submodule -q add "$repo-inner-upstream" inner
    git -C "$repo/sub/inner" commit -q --allow-empty -m 'local only'
    git -C "$repo/sub" add inner
    git -C "$repo/sub" commit -q -m 'pin local-only inner commit'
    git -C "$repo" add sub
    cd "$repo"
    MEGAPROMPT_TIMEOUTS[default]=20
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<SUBUNPUSHED>2</SUBUNPUSHED>" "both levels should be counted"
}

test-submodule-unpushed-timeout-is-not-reported-as-clean() {
    local out
    local repo="$SANDBOX/unpushed-timeout"
    make-repo-with-submodule "$repo"
    git -C "$repo/sub" remote remove origin
    cd "$repo"
    MEGAPROMPT_TIMEOUTS[default]=20
    MEGAPROMPT_TIMEOUTS[git_submodule_unpushed]=0.000001
    out="$(-mp-gitStatus)"
    assert-contains "$out" "<TIMEOUT>" "the timeout should be reported"
    assert-not-contains "$out" "<SUBUNPUSHED>" "the answer is unknown after a timeout"
}

################################################################################
# extra_analysis toggle
################################################################################

test-extras-off-skips-git-branch() {
    local out
    cd "$REPO"
    MEGAPROMPT_DISPLAY_P[extra_analysis]=false
    out="$(-mp-getGitBranch)"
    assert-equal "" "$out" "git branch display should be skipped entirely"
}

test-extras-off-skips-hg-branch() {
    local out
    MEGAPROMPT_DISPLAY_P[mercurial]=true
    MEGAPROMPT_DISPLAY_P[extra_analysis]=false
    out="$(-mp-getHgBranch)"
    assert-equal "" "$out" "hg branch display should be skipped entirely"
}

test-extras-off-skips-directory-inspection() {
    local out
    cd "$REPO"
    MEGAPROMPT_DISPLAY_P[extra_analysis]=false
    out="$(-mp-getPwd)"
    assert-contains "$out" "repo/" "the path itself should still be shown"
    for marker in "<MOUNT>" "<NOMOUNT>" "<GITROOT>" "<UNSPECIAL>" \
                  "<OWNER>" "<GROUP>" "<WRITE>" "<NOWRITE>"; do
        assert-not-contains "$out" "$marker" "no directory should be inspected"
    done
}

test-extras-on-inspects-directories() {
    local out
    cd "$REPO"
    MEGAPROMPT_DISPLAY_P[extra_analysis]=true
    out="$(-mp-getPwd)"
    assert-contains "$out" "<GITROOT>" "the repo root should be styled as such"
}

# Without an indicator, a prompt with the extras off looks exactly like a
# prompt in a directory that has nothing extra to report.
test-extras-off-is-indicated-in-the-prompt() {
    local out
    MEGAPROMPT_DISPLAY_P[extra_analysis]=false
    out="$(-mp-getExtrasIndicator)"
    assert-contains "$out" "<EXTRASOFF>" "the extras being off should be visible"
    MEGAPROMPT_DISPLAY_P[extra_analysis]=true
    out="$(-mp-getExtrasIndicator)"
    assert-equal "" "$out" "nothing should be shown while the extras are on"
}

test-mp-extras-sets-and-toggles-state() {
    MEGAPROMPT_DISPLAY_P[extra_analysis]=true
    mp-extras off >/dev/null
    assert-equal "false" "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" "off should disable extras"
    mp-extras on >/dev/null
    assert-equal "true" "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" "on should enable extras"
    mp-extras >/dev/null
    assert-equal "false" "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" "no argument should toggle"
    mp-extras toggle >/dev/null
    assert-equal "true" "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" "toggle should toggle"
}

test-mp-extras-reports-state() {
    local out
    local outfile="$SANDBOX/extras-output"
    MEGAPROMPT_DISPLAY_P[extra_analysis]=true
    # Redirect rather than capture, so that the state changes are not lost in
    # a subshell.
    mp-extras status > "$outfile"
    out="$(< "$outfile")"
    assert-contains "$out" "on" "status should report that extras are on"
    mp-extras off > "$outfile"
    out="$(< "$outfile")"
    assert-contains "$out" "off" "setting the state should report the new state"
    mp-extras status > "$outfile"
    out="$(< "$outfile")"
    assert-contains "$out" "off" "status should report that extras are off"
}

################################################################################

main() {
    suite-setup
    run-test test-timeouts-disabled-run-the-command-directly
    run-test test-timeout-method-defaults-to-native
    run-test test-timeout-passes-through-output-and-status
    run-test test-timeout-handles-large-output
    run-test test-timeout-gives-up-on-slow-command
    run-test test-timeout-stops-the-command
    run-test test-timeout-is-cheap-for-fast-commands
    run-test test-timeout-falls-back-to-default-duration
    run-test test-timeout-zero-waits-as-long-as-it-takes
    run-test test-timed-out-p-recognizes-the-timeout-status
    run-test test-git-status-shows-marks-without-timeouts
    run-test test-git-status-reports-timeout-instead-of-guessing
    run-test test-git-branch-timeout-shows-unknown-branch
    run-test test-git-branch-shown-without-timeouts
    run-test test-worktree-count-shown-only-when-not-one
    run-test test-submodule-unpushed-pin-is-reported
    run-test test-submodule-without-remote-is-reported
    run-test test-nested-submodule-unpushed-pins-are-counted
    run-test test-submodule-unpushed-timeout-is-not-reported-as-clean
    run-test test-extras-off-skips-git-branch
    run-test test-extras-off-skips-hg-branch
    run-test test-extras-off-skips-directory-inspection
    run-test test-extras-on-inspects-directories
    run-test test-extras-off-is-indicated-in-the-prompt
    run-test test-mp-extras-sets-and-toggles-state
    run-test test-mp-extras-reports-state
    suite-teardown

    print "\n$TESTS_RUN tests, $TESTS_FAILED failed"
    [[ $TESTS_FAILED -eq 0 ]]
}

main "$@"
