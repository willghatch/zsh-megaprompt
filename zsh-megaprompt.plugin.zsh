
setopt prompt_subst

typeset -Ag MEGAPROMPT_STYLES
MEGAPROMPT_STYLES[time]="%b%F{cyan}"
MEGAPROMPT_STYLES[timestr]="%H:%M"
MEGAPROMPT_STYLES[host]="%B%F{yellow}"
MEGAPROMPT_STYLES[userhost_brackets]="%b%F{green}"
MEGAPROMPT_STYLES[username]="%B%F{green}"
MEGAPROMPT_STYLES[username_root]="%B%F{red}"
MEGAPROMPT_STYLES[tty]="%b%F{blue}"
MEGAPROMPT_STYLES[at]="%b%F{green}"
MEGAPROMPT_STYLES[dir_owner]="%B%F{blue}"
MEGAPROMPT_STYLES[dir_group]="%B%F{green}"
MEGAPROMPT_STYLES[dir_nowrite]="%B%F{red}"
MEGAPROMPT_STYLES[dir_write]="%B%F{yellow}"
MEGAPROMPT_STYLES[histnum]="%b%F{blue}"
MEGAPROMPT_STYLES[prompt]="%b%F{default}"
MEGAPROMPT_STYLES[prompt_char]="λ"
MEGAPROMPT_STYLES[git_master]="%b%F{white}"
MEGAPROMPT_STYLES[git_other]="%b%F{red}"
MEGAPROMPT_STYLES[git_branch_brackets]="%b%F{grey}"
MEGAPROMPT_STYLES[hg_branch_brackets]="%b%F{grey}"
MEGAPROMPT_STYLES[jobs]="%B%F{magenta}"
MEGAPROMPT_STYLES[jobs_brackets]="%b%F{red}"
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
MEGAPROMPT_DISPLAY_P[time]=true
MEGAPROMPT_DISPLAY_P[histnum]=true
MEGAPROMPT_DISPLAY_P[username]=true
MEGAPROMPT_DISPLAY_P[host]=true
MEGAPROMPT_DISPLAY_P[tty]=false
#MEGAPROMPT_DISPLAY_P[directory]=true
#MEGAPROMPT_DISPLAY_P[newline]=true
#MEGAPROMPT_DISPLAY_P[keymap]=true
#MEGAPROMPT_DISPLAY_P[git_status]=false
#MEGAPROMPT_DISPLAY_P[git_branch]=true

# TODO - is there a way to get the last USER command exit status in a function?
# It's nearly the last thing that I'm not sure how to turn into a function so I can
# calculate line length and add a horizontal rule option.  (Along with current
# history number)
# Note -- if I DO add an hrule option, I don't think it will work with %{color} color strings...
PS1_cmd_stat='%(?,, %b%F{cyan}<%F{red}%?%F{cyan}>)'

-mp-getJobs(){
    local njobs
    njobs="$(jobs | wc -l)"
    if [[ ! "$njobs" -eq 0 ]]; then
        echo " ${MEGAPROMPT_STYLES[jobs_brackets]}[${MEGAPROMPT_STYLES[jobs]}%jj${MEGAPROMPT_STYLES[jobs_brackets]}]"
    fi
}

-mp-getHistory(){
    if [[ "${MEGAPROMPT_DISPLAY_P[histnum]}" = "true" ]]; then
        echo "${MEGAPROMPT_STYLES[histnum]}%h "
    fi
}

mp-getHgBranch() {
    local branch
    branch=$(hg branch 2>/dev/null)
    if [[ -z "$branch" ]]; then
        return
    fi
    echo -n "${MEGAPROMPT_STYLES[hg_branch_brackets]}<"
    mp-styleBranch "$branch" hg
    echo -n "${MEGAPROMPT_STYLES[hg_branch_brackets]}> "
}

mp-getGitBranch() {
    local branch
    branch=$(git branch 2>/dev/null | fgrep '*')
    if [[ -z "$branch" ]]; then
        return
    fi
    branch=${branch:2}
    echo -n "${MEGAPROMPT_STYLES[git_branch_brackets]}["
    mp-styleBranch "$branch" git
    echo -n "${MEGAPROMPT_STYLES[git_branch_brackets]}] "
}

mp-styleBranch() {
    local branch
    local cvs
    branch=$1
    cvs="$2"
    if [ "$branch" = "master" ]
    then
        branch="${MEGAPROMPT_STYLES[git_master]}$branch"
    elif [ -n "$branch" ]
    then
        branch="${MEGAPROMPT_STYLES[git_other]}$branch"
    fi
    echo -n $branch
}

-mp-getPwd() {
    local out
    local dir
    dir="$PWD"
    out=""
    while true; do
        if [[ "$dir" = "$HOME" ]]; then
            echo "$(-mp-getDirColor $dir)~/${out}"
            return
        elif [[ "$dir" = "/" ]]; then
            echo "$(-mp-getDirColor $dir)/${out}"
            return
        else
            out="$(-mp-getDirColor $dir)$(basename $dir)/${out}"
            dir="$(dirname $dir)"
        fi
    done
}

-mp-getDirColor() {
    # I want to know if I'm the owner, and if it's writeable
    local dir
    dir="$1"
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
    echo "${MEGAPROMPT_STYLES[host]}$HOST"
}

mp-getTty(){
    echo "${MEGAPROMPT_STYLES[tty]}${TTY:5}"
}

-mp-user-host-tty(){
    local -A p
    set -A p ${(kv)MEGAPROMPT_DISPLAY_P}
    local -A s
    set -A s ${(kv)MEGAPROMPT_STYLES}
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

mp-updatePrompt() {
    local -A s
    set -A s ${(kv)MEGAPROMPT_STYLES}
    local k=$MEGAPROMPT_KEYMAP_IND[$ZSH_CUR_KEYMAP]
    if [[ -z "$k" ]]; then
        k=$MEGAPROMPT_KEYMAP_IND[keymap_unlisted]
    fi

    PS1="\$(-mp-getTime)\$(-mp-user-host-tty)\$(mp-getGitBranch)\$(mp-getHgBranch)\$(-mp-getPwd)\$(-mp-getJobs)${PS1_cmd_stat}
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
