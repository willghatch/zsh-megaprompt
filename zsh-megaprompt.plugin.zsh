
setopt prompt_subst

typeset -Ag MEGAPROMPT_STYLES
MEGAPROMPT_STYLES[hrule_char]="┅"
MEGAPROMPT_STYLES[hrule_style]="%b%F{blue}"
MEGAPROMPT_STYLES[time]="%b%F{cyan}"
MEGAPROMPT_STYLES[timestr]="%H:%M"
MEGAPROMPT_STYLES[host]="%B%F{yellow}"
MEGAPROMPT_STYLES[userhost_brackets]="%b%F{white}"
MEGAPROMPT_STYLES[username]="%B%F{green}"
MEGAPROMPT_STYLES[username_root]="%B%F{red}"
MEGAPROMPT_STYLES[tty]="%b%F{blue}"
MEGAPROMPT_STYLES[at]="%b%F{white}"
MEGAPROMPT_STYLES[dir_mount_point]="%S"
MEGAPROMPT_STYLES[dir_not_mount_point]="%s"
MEGAPROMPT_STYLES[dir_git_root]="%B"
MEGAPROMPT_STYLES[dir_vcs_unspecial]="%b"
MEGAPROMPT_STYLES[post_pwd_reset]="%b%u%s"
MEGAPROMPT_STYLES[dir_owner]="%F{blue}"
MEGAPROMPT_STYLES[dir_group]="%F{green}"
MEGAPROMPT_STYLES[dir_nowrite]="%F{red}"
MEGAPROMPT_STYLES[dir_write]="%F{yellow}"
MEGAPROMPT_STYLES[histnum]="%b%F{blue}"
MEGAPROMPT_STYLES[prompt]="%b%F{default}"
MEGAPROMPT_STYLES[prompt_char]="λ"
MEGAPROMPT_STYLES[git_branch_brackets]="%b%F{grey}"
MEGAPROMPT_STYLES[git_branch_brackets_left]="["
MEGAPROMPT_STYLES[git_branch_brackets_right]="]"
MEGAPROMPT_STYLES[git_default_branch_color]="%b%F{blue}"
MEGAPROMPT_STYLES[hg_branch_brackets]="%b%F{grey}"
MEGAPROMPT_STYLES[jobs_number]="%B%F{magenta}"
MEGAPROMPT_STYLES[jobs_letter]="%B%F{magenta}"
MEGAPROMPT_STYLES[jobs_brackets]="%b%F{red}"
MEGAPROMPT_STYLES[git_ahead_mark]="%b%F{white}▲%F{cyan}"
MEGAPROMPT_STYLES[git_behind_mark]="%b%F{white}▼%F{cyan}"
MEGAPROMPT_STYLES[git_dirty_mark]=" %b%F{red}D"
MEGAPROMPT_STYLES[git_submodule_dirty_mark]=" %b%F{red}S"
MEGAPROMPT_STYLES[git_untracked_mark]=" %b%F{red}U"
MEGAPROMPT_STYLES[git_no_remote_tracking_mark]=" %b%F{white}N"
MEGAPROMPT_STYLES[git_timeout_mark]=" %b%F{red}T"
MEGAPROMPT_STYLES[git_branch_unknown]="%b%F{red}?"
MEGAPROMPT_STYLES[extras_off_mark]="%b%F{red}(no extras) "
typeset -Ag MEGAPROMPT_GIT_STYLES
MEGAPROMPT_GIT_STYLES[master]="%b%F{white}"
MEGAPROMPT_GIT_STYLES[main]="%b%F{white}"
MEGAPROMPT_GIT_STYLES[dev]="%b%F{green}"
MEGAPROMPT_GIT_STYLES[develop]="%b%F{green}"
MEGAPROMPT_GIT_STYLES[release.*]="%b%F{red}"
typeset -Ag MEGAPROMPT_KEYMAP_IND
MEGAPROMPT_KEYMAP_IND[main]="%b%K{magenta}%F{black}I%k"
MEGAPROMPT_KEYMAP_IND[viins]="%b%K{magenta}%F{black}I%k"
MEGAPROMPT_KEYMAP_IND[emacs]="%b%K{magenta}%F{black}I%k"
MEGAPROMPT_KEYMAP_IND[vicmd]="%b%K{blue}%F{black}N%k"
MEGAPROMPT_KEYMAP_IND[opp]="%b%K{yellow}%F{black}O%k"
MEGAPROMPT_KEYMAP_IND[vivis]="%b%K{green}%F{black}V%k"
MEGAPROMPT_KEYMAP_IND[vivli]="%b%K{green}%F{black}V%k"
MEGAPROMPT_KEYMAP_IND[keymap_unlisted]="%b%K{white}%F{black}?%k"
typeset -Ag MEGAPROMPT_DISPLAY_P
# Master switch for everything that inspects the filesystem or a VCS.  Turn it
# off (see mp-extras) when the current directory makes those checks slow.
MEGAPROMPT_DISPLAY_P[extra_analysis]=true
MEGAPROMPT_DISPLAY_P[pwd_mount]=true
MEGAPROMPT_DISPLAY_P[hrule]=true
# an hrule forces truncation, but if you want it in any case, here it is
MEGAPROMPT_DISPLAY_P[truncate]=false
MEGAPROMPT_DISPLAY_P[time]=true
MEGAPROMPT_DISPLAY_P[histnum]=true
MEGAPROMPT_DISPLAY_P[username]=true
MEGAPROMPT_DISPLAY_P[host]=true
# this one just determines whether to show the fully qualified domain name
MEGAPROMPT_DISPLAY_P[longhost]=false
MEGAPROMPT_DISPLAY_P[tty]=false
MEGAPROMPT_DISPLAY_P[mercurial]=false
MEGAPROMPT_DISPLAY_P[git_dirty]=true
MEGAPROMPT_DISPLAY_P[git_submodule_dirty]=true
MEGAPROMPT_DISPLAY_P[git_ahead_behind]=true
MEGAPROMPT_DISPLAY_P[git_untracked]=true
MEGAPROMPT_DISPLAY_P[git_no_remote_tracking]=true
MEGAPROMPT_DISPLAY_P[branch_style_regex]=true
#MEGAPROMPT_DISPLAY_P[directory]=true
#MEGAPROMPT_DISPLAY_P[newline]=true
#MEGAPROMPT_DISPLAY_P[keymap]=true
typeset -Ag MEGAPROMPT_MISC
# Durations in seconds, which may be fractional, for each command that can be
# slow.  The [default] entry is used for any key that is not set.
# A duration of 0 (or an empty one) means "wait as long as it takes".
typeset -Ag MEGAPROMPT_TIMEOUTS
MEGAPROMPT_TIMEOUTS[default]=1
#MEGAPROMPT_TIMEOUTS[git_branch]=1
#MEGAPROMPT_TIMEOUTS[git_bare_check]=1
#MEGAPROMPT_TIMEOUTS[git_ahead_behind]=1
#MEGAPROMPT_TIMEOUTS[git_no_remote_tracking]=1
#MEGAPROMPT_TIMEOUTS[git_dirty]=1
#MEGAPROMPT_TIMEOUTS[git_submodule_dirty]=1
#MEGAPROMPT_TIMEOUTS[git_untracked]=1
#MEGAPROMPT_TIMEOUTS[hg_branch]=1
#MEGAPROMPT_TIMEOUTS[pwd_mount]=1

# Whether timeouts can be imposed at all: "native" or "none".  zsh does the
# timing itself, which runs nothing besides the command being timed.  timeout(1)
# would be another process for every check, and some implementations of it
# (uutils) cost about 100ms per call however quick the command is, which is
# worse than the slowness being avoided.
-mp-detect-timeout-method(){
    if zmodload zsh/system 2>/dev/null && zmodload zsh/datetime 2>/dev/null; then
        MEGAPROMPT_MISC[timeout_method]=native
    else
        MEGAPROMPT_MISC[timeout_method]=none
    fi
}
if [[ -z "${MEGAPROMPT_MISC[timeout_method]+set}" ]]; then
    -mp-detect-timeout-method
fi

# Run a command, giving up on it after the duration configured for the given
# key.  Output and exit status are those of the command; a command that is
# given up on has a status for which -mp-timed-out-p is true.
-mp-timeout-command(){
    local key
    local duration
    key="$1"
    shift
    duration="${MEGAPROMPT_TIMEOUTS[$key]:-${MEGAPROMPT_TIMEOUTS[default]}}"
    if [[ -z "$duration" || "$duration" = 0 || \
          "${MEGAPROMPT_MISC[timeout_method]}" != native ]]; then
        "$@"
        return
    fi
    -mp-run-with-deadline "$duration" "$@"
}

# The command becomes a coprocess, which is where both its output and its exit
# status come from, and sysread's own timeout is what bounds the wait.
-mp-run-with-deadline(){
    setopt localoptions no_monitor no_notify
    local duration
    local deadline
    local remaining
    local buf
    local out
    local pid
    local fd
    local finished
    duration="$1"
    shift
    coproc { "$@" < /dev/null }
    pid=$!
    exec {fd}<&p
    out=""
    finished=false
    deadline=$(( EPOCHREALTIME + duration ))
    while true; do
        remaining=$(( deadline - EPOCHREALTIME ))
        if (( remaining <= 0 )); then
            break
        fi
        buf=""
        sysread -t $remaining -i $fd buf
        case $? in
            0)
                # Output has to be read as it comes, or a command with more
                # output than fits in the pipe would block until read from.
                out+="$buf"
                ;;
            4)
                # sysread timed out.
                break
                ;;
            *)
                # End of file, or an error we cannot read past.
                finished=true
                break
                ;;
        esac
    done
    exec {fd}<&-
    if [[ "$finished" != true ]]; then
        # Don't wait for it to die.  A command that ignores the signal must not
        # be able to hold up the prompt any longer than it already has.
        kill -TERM "$pid" 2>/dev/null
        return 124
    fi
    printf '%s' "$out"
    wait "$pid"
}

-mp-timed-out-p(){
    # 124 is what timeout(1) reports when it gives up, kept for familiarity.
    [[ "$1" -eq 124 ]]
}

# While the extras are off the prompt looks the same as it would in a directory
# with nothing extra to report, so say which it is.
-mp-getExtrasIndicator(){
    if [[ "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" != "true" ]]; then
        echo -n "${MEGAPROMPT_STYLES[extras_off_mark]}"
    fi
}

# Turn the extra (potentially slow) data gathering on or off.
# Usage: mp-extras [on|off|toggle|status]
mp-extras(){
    case "${1:-toggle}" in
        on|true)
            MEGAPROMPT_DISPLAY_P[extra_analysis]=true
            ;;
        off|false)
            MEGAPROMPT_DISPLAY_P[extra_analysis]=false
            ;;
        toggle)
            if [[ "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" = true ]]; then
                MEGAPROMPT_DISPLAY_P[extra_analysis]=false
            else
                MEGAPROMPT_DISPLAY_P[extra_analysis]=true
            fi
            ;;
        status)
            ;;
        *)
            print -u2 "mp-extras: expected one of: on, off, toggle, status"
            return 1
            ;;
    esac
    if [[ "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" = true ]]; then
        print "megaprompt extra analysis: on"
    else
        print "megaprompt extra analysis: off"
    fi
    mp-updatePrompt
}

# TODO - is there a way to get the last USER command exit status in a function?
# It's nearly the last thing that I'm not sure how to turn into a function so I can
# calculate line length and add a horizontal rule option that can plan for eg.
# compressing the file path.  (Along with current history number)

# TODO - coloring options
#        I might have the trailing slash on a dir give info (eg. is it a symlink, etc)
#        I might have the root slash be a different color if it's in a chroot or something

PS1_cmd_stat='%(?,, %b%F{cyan}<%F{red}%?%F{cyan}>)'

-mp-getJobs(){
    # TODO - if there is only one job running, there sohuld be an option to show its name
    local running
    local stopped
    running="$(jobs -r | command grep -F [ | wc -l | tr -d " ")"
    stopped="$(jobs -s | command grep -F [ | wc -l | tr -d " ")"
    if [[ ! "$(jobs | command wc -l)" -eq 0 ]]; then
        echo -n " ${MEGAPROMPT_STYLES[jobs_brackets]}["
        if [[ ! "$running" -eq 0 ]]; then
            echo -n "${MEGAPROMPT_STYLES[jobs_number]}$running${MEGAPROMPT_STYLES[jobs_letter]}r"
        fi
        if [[ ! "$stopped" -eq 0 ]]; then
            echo -n "${MEGAPROMPT_STYLES[jobs_number]}$stopped${MEGAPROMPT_STYLES[jobs_letter]}s"
        fi
        echo -n "${MEGAPROMPT_STYLES[jobs_brackets]}]"
    fi
}

-mp-getHistory(){
    if [[ "${MEGAPROMPT_DISPLAY_P[histnum]}" = "true" ]]; then
        echo "${MEGAPROMPT_STYLES[histnum]}%h "
    fi
}

-mp-getHgBranch() {
    local branch
    if [[ "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" != "true" ]]; then
        return
    fi
    if [[ "${MEGAPROMPT_DISPLAY_P[mercurial]}" = "true" ]]; then
        # Don't try if hg is not available
        if which hg >/dev/null 2>&1; then
        else
            return
        fi
        branch=$(-mp-timeout-command hg_branch hg branch 2>/dev/null)
        if [[ -z "$branch" ]]; then
            return
        fi
        echo -n "${MEGAPROMPT_STYLES[hg_branch_brackets]}<"
        -mp-styleBranch "$branch" hg
        echo -n "${MEGAPROMPT_STYLES[hg_branch_brackets]}> "
    fi
}

-mp-isGitRoot() {
    if [[ -e "$1/.git" ]]; then
        return 0;
    else
        return 1;
    fi
}

-mp-getGitRoot() {
    if [[ -e "$1/.git" ]]; then
        echo "$1"
    elif [[ "$1" = "/" ]]; then
        echo ""
    elif [[ -z "$1" ]]; then
        echo ""
    else
        echo "$(-mp-getGitRoot $(dirname $1))"
    fi
}

-mp-getGitBranch() {
    local branch
    local groot
    local curdir
    if [[ "${MEGAPROMPT_DISPLAY_P[extra_analysis]}" != "true" ]]; then
        return
    fi
    branch=$(-mp-timeout-command git_branch git branch 2>/dev/null)
    if -mp-timed-out-p $?; then
        # Whether this is a repo at all is now unknown, but a git command that
        # is too slow to finish is itself worth showing.
        echo -n "${MEGAPROMPT_STYLES[git_branch_brackets]}${MEGAPROMPT_STYLES[git_branch_brackets_left]}"
        echo -n "${MEGAPROMPT_STYLES[git_branch_unknown]}"
        echo -n "${MEGAPROMPT_STYLES[git_branch_brackets]}${MEGAPROMPT_STYLES[git_branch_brackets_right]} "
        return
    fi
    branch=$(echo "$branch" | command grep -F '*')
    if [[ -z "$branch" ]]; then
        return
    fi
    branch=${branch:2}
    echo -n "${MEGAPROMPT_STYLES[git_branch_brackets]}${MEGAPROMPT_STYLES[git_branch_brackets_left]}"
    -mp-styleBranch "$branch" git
    curdir="$(pwd)"
    groot="$(-mp-getGitRoot $curdir)"
    builtin cd "$groot"
    -mp-gitStatus
    builtin cd "$curdir"
    echo -n "${MEGAPROMPT_STYLES[git_branch_brackets]}${MEGAPROMPT_STYLES[git_branch_brackets_right]} "
}

-mp-gitStatus(){
    local gitlr
    local gitl
    local gitr
    local gitbare
    local st
    local timedout
    local summary
    local -A ms
    set -A ms "${(kv)MEGAPROMPT_STYLES[@]}"
    # Each check that is given up on leaves its piece of the status unknown.
    # An unknown answer must not be reported as a known one, so it contributes
    # the timeout mark instead of its own mark.
    timedout=false
    gitbare="$(-mp-timeout-command git_bare_check git rev-parse --is-bare-repository)"
    if -mp-timed-out-p $?; then
        echo -n "${ms[git_timeout_mark]}"
        return
    fi
    if [[ "${MEGAPROMPT_DISPLAY_P[git_ahead_behind]}" = true ]]; then
        gitlr=$(-mp-timeout-command git_ahead_behind git rev-list --left-right @{u}...HEAD 2>/dev/null)
        if -mp-timed-out-p $?; then
            timedout=true
        else
            if [[ -n "$gitlr" ]]; then
                echo -n " "
            fi
            # tr is used to remove wc's leading white space for our BSD friends
            gitl=$(echo "$gitlr" | command grep -E '^<' | wc -l | tr -d " ")
            gitr=$(echo "$gitlr" | command grep -E '^>' | wc -l | tr -d " ")
            if [[ 0 -ne "$gitl" ]]; then
                echo -n "${ms[git_behind_mark]}$gitl"
            fi
            if [[ 0 -ne "$gitr" ]]; then
                echo -n "${ms[git_ahead_mark]}$gitr"
            fi
        fi
    fi
    if [[ "${MEGAPROMPT_DISPLAY_P[git_no_remote_tracking]}" = true ]]; then
        -mp-timeout-command git_no_remote_tracking git rev-parse --abbrev-ref @{upstream} 1>/dev/null 2>&1
        st=$?
        if -mp-timed-out-p $st; then
            timedout=true
        elif [[ 0 -ne "$st" ]]; then
            echo -n "${ms[git_no_remote_tracking_mark]}"
        fi
    fi
    if [[ "$gitbare" = false ]]; then
        if [[ "${MEGAPROMPT_DISPLAY_P[git_dirty]}" = true ]]; then
            -mp-timeout-command git_dirty git diff --quiet --ignore-submodules HEAD 1>/dev/null 2>&1
            st=$?
            if -mp-timed-out-p $st; then
                timedout=true
            elif [[ 0 -ne "$st" ]]; then
                echo -n "${ms[git_dirty_mark]}"
            fi
        fi
        if [[ "${MEGAPROMPT_DISPLAY_P[git_submodule_dirty]}" = true ]]; then
            summary="$(-mp-timeout-command git_submodule_dirty git submodule summary -n 1 2>/dev/null)"
            if -mp-timed-out-p $?; then
                timedout=true
            elif [[ -n "$summary" ]]; then
                echo -n "${ms[git_submodule_dirty_mark]}"
            fi
        fi
        if [[ "${MEGAPROMPT_DISPLAY_P[git_untracked]}" = true ]]; then
            # piping to "sed q1" may be faster (I don't actually know),
            # but it breaks on BSD (or mac).
            summary="$(-mp-timeout-command git_untracked git ls-files --other --directory --exclude-standard)"
            if -mp-timed-out-p $?; then
                timedout=true
            elif [[ -n "$summary" ]]; then
                echo -n "${ms[git_untracked_mark]}"
            fi
        fi
    fi
    if [[ "$timedout" = true ]]; then
        echo -n "${ms[git_timeout_mark]}"
    fi
}

-mp-styleBranch() {
    local branch
    local -A mgs
    local pcre_on_p
    set -A mgs "${(kv)MEGAPROMPT_GIT_STYLES[@]}"
    branch=$1
    pcre_on_p="$options[rematchpcre]"

    if [[ -n "${mgs[$branch]}" ]]; then
        echo -n "${mgs[$branch]}$branch"
        return
    fi

    if [[ "$MEGAPROMPT_DISPLAY_P[branch_style_regex]" != true ]]; then
        echo -n "$branch"
        return
    fi

    setopt rematchpcre
    for k in "${(@k)mgs}"; do
        if [[ "$branch" =~ "$k" ]]; then
            echo -n "${mgs[$k]}$branch"
            -mp-reset-pcre-option "$prce_on_p"
            return
        fi
    done
    echo -n "${MEGAPROMPT_STYLES[git_default_branch_color]}$branch"
    -mp-reset-pcre-option "$prce_on_p"
}

-mp-reset-pcre-option(){
    if [[ "$1" = "off" ]]; then
        unsetopt rematchpcre
    fi
}

-mp-getPwd() {
    local out
    local dir
    local color
    local extras
    dir="$PWD"
    out="${MEGAPROMPT_STYLES[post_pwd_reset]}"
    extras="${MEGAPROMPT_DISPLAY_P[extra_analysis]}"
    local mountPoints
    if [[ "$extras" = true && "${MEGAPROMPT_DISPLAY_P[pwd_mount]}" = true ]]; then
        mountPoints="$(-mp-timeout-command pwd_mount mount -l | awk '{print $3}')"
    fi
    while true; do
        color=""
        if [[ "$extras" = true ]]; then
            color="$(-mp-getDirColor $dir $mountPoints)"
        fi
        if [[ "$dir" = "$HOME" ]]; then
            echo "${color}~/${out}"
            return
        elif [[ "$dir" = "/" ]]; then
            echo "${color}/${out}"
            return
        else
            out="${color}$(basename $dir)/${out}"
            dir="$(dirname $dir)"
        fi
    done
}

-mp-getDirColor() {
    # I want to know if I'm the owner, and if it's writeable
    # Also, highlight based on whether the directory is a git repo root
    local dir
    dir="$1"
    local mountPoints
    mountPoints="$2"
    if [[ "${MEGAPROMPT_DISPLAY_P[pwd_mount]}" = true ]]; then
        if grep -F -x -q -f <(echo "$mountPoints") <(echo "$dir") >/dev/null 2>&1; then
            echo -n "${MEGAPROMPT_STYLES[dir_mount_point]}"
        else
            echo -n "${MEGAPROMPT_STYLES[dir_not_mount_point]}"
        fi
    fi
    if -mp-isGitRoot "$dir"; then
        echo -n "${MEGAPROMPT_STYLES[dir_git_root]}"
    else
        echo -n "${MEGAPROMPT_STYLES[dir_vcs_unspecial]}"
    fi
    if [[ -w "$dir" ]]; then
        if [[ -O "$dir" ]]; then
            echo "${MEGAPROMPT_STYLES[dir_owner]}"
        else
            local dirGrp
            dirGrp=$(stat -c %g "$dir")
            for id in $(id -G); do
                if [[ "$id" -eq "$dirGrp" ]]; then
                    echo "${MEGAPROMPT_STYLES[dir_group]}"
                    return
                fi
            done
            echo "${MEGAPROMPT_STYLES[dir_write]}"
        fi
    else
        echo "${MEGAPROMPT_STYLES[dir_nowrite]}"
    fi
}

mp-getUser(){
    if [[ "$USER" = "root" ]]; then
        echo "${MEGAPROMPT_STYLES[username_root]}$USER"
    else
        echo "${MEGAPROMPT_STYLES[username]}$USER"
    fi
}

mp-getHost(){
    if [[ -n "$MEGAPROMPT_OVERRIDE_HOSTNAME" ]]; then
        echo "${MEGAPROMPT_STYLES[host]}$MEGAPROMPT_OVERRIDE_HOSTNAME"
    elif [[ "$MEGAPROMPT_DISPLAY_P[longhost]" = "true" ]]; then
        echo "${MEGAPROMPT_STYLES[host]}$HOST"
    else
        # $(hostname -s) was giving weird errors on my laptop, so use this instead.
        echo "${MEGAPROMPT_STYLES[host]}${HOST/\.*/}"
    fi
}

mp-getTty(){
    echo "${MEGAPROMPT_STYLES[tty]}${TTY:5}"
}

-mp-user-host-tty(){
    local -A p
    set -A p "${(kv)MEGAPROMPT_DISPLAY_P[@]}"
    local -A s
    set -A s "${(kv)MEGAPROMPT_STYLES[@]}"
    if [ ! "true" = "${p[username]}" -a \
         ! "true" = "${p[host]}" -a \
         ! "true" = "${p[tty]}" ]; then
        return
    fi
    local uht="${s[userhost_brackets]}["
    if [ "true" = "${p[username]}" ]; then
        uht="${uht}$(mp-getUser)"
    fi
    if [ "true" = "${p[host]}" ]; then
        uht="${uht}${s[at]}@$(mp-getHost)"
    fi
    if [ "true" = "${p[tty]}" ]; then
        uht="${uht}${s[at]}:$(mp-getTty)"
    fi
    uht="${uht}${s[userhost_brackets]}]"
    echo "$uht "
}
-mp-getTime(){
    if [ "true" = "${MEGAPROMPT_DISPLAY_P[time]}" ]; then
        echo "${MEGAPROMPT_STYLES[time]}$(date +${MEGAPROMPT_STYLES[timestr]}) "
    fi
}

-mp-get-hrule-string(){
    if [[ "true" = "${MEGAPROMPT_DISPLAY_P[hrule]}" ]]; then
        echo -n "${MEGAPROMPT_STYLES[hrule_style]}"
        for i in {1..$COLUMNS}; do
            echo -n "${MEGAPROMPT_STYLES[hrule_char]}"
        done
    fi
}

-mp-get-truncate-start(){
    if [ "true" = "${MEGAPROMPT_DISPLAY_P[truncate]}" -o \
        "true" = "${MEGAPROMPT_DISPLAY_P[hrule]}" ]; then
        echo "%$(( $COLUMNS - 1 ))>>"
    fi
}
-mp-get-truncate-end(){
    if [ "true" = "${MEGAPROMPT_DISPLAY_P[truncate]}" -o \
        "true" = "${MEGAPROMPT_DISPLAY_P[hrule]}" ]; then
        echo "%<<"
    fi
}

-mp-get-custom-pre(){
    if [[ -n "${MEGAPROMPT_PRE_FUNCTION}" ]]; then
        "${MEGAPROMPT_PRE_FUNCTION}"
    fi
}

-mp-get-custom-pre-lines(){
    if [[ -n "${MEGAPROMPT_PRE_LINES_FUNCTION}" ]]; then
        "${MEGAPROMPT_PRE_LINES_FUNCTION}"
    fi
}

mp-updatePrompt() {
    local -A s
    set -A s "${(kv)MEGAPROMPT_STYLES[@]}"
    local k=$MEGAPROMPT_KEYMAP_IND[$ZSH_CUR_KEYMAP]
    if [[ -z "$k" ]]; then
        k=$MEGAPROMPT_KEYMAP_IND[keymap_unlisted]
    fi

    # you can set the ending character of the hrule by putting it between the >> that set truncation.
    PS1="\$(-mp-get-custom-pre-lines)\$(-mp-get-truncate-start)\$(-mp-get-custom-pre)\$(-mp-getTime)\$(-mp-user-host-tty)\$(-mp-getExtrasIndicator)\$(-mp-getGitBranch)\$(-mp-getHgBranch)\$(-mp-getPwd)\$(-mp-getJobs)${PS1_cmd_stat} ${s[hrule]}$(-mp-get-hrule-string)\$(-mp-get-truncate-end)
${k} $(-mp-getHistory)${s[prompt]}${s[prompt_char]} "
    if zle; then
        zle reset-prompt
    fi
}

if type -f hooks-add-hook 1>/dev/null 2>&1; then
    hooks-add-hook zle_keymap_select_hook mp-updatePrompt
    hooks-add-hook zle_line_init_hook mp-updatePrompt
    add-zsh-hook precmd mp-updatePrompt
else
    echo "zsh-hooks not loaded!  Please load willghatch/zsh-hooks before zsh-megaprompt." 1>&2
fi
