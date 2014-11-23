
setopt prompt_subst

typeset -Ag MEGAPROMPT_STYLES
MEGAPROMPT_STYLES[time]="%b%F{cyan}"
MEGAPROMPT_STYLES[host]="%B%F{yellow}"
MEGAPROMPT_STYLES[userhost_brackets]="%b%F{green}"
MEGAPROMPT_STYLES[username]="%B%F{green}"
MEGAPROMPT_STYLES[at]="%b%F{green}"
MEGAPROMPT_STYLES[dir_owner]="%B%F{blue}"
MEGAPROMPT_STYLES[dir_group]="%B%F{green}"
MEGAPROMPT_STYLES[dir_nowrite]="%B%F{red}"
MEGAPROMPT_STYLES[dir_write]="%B%F{yellow}"
MEGAPROMPT_STYLES[histnum]="%b%F{blue}"
MEGAPROMPT_STYLES[dollar]="%b%F{default}"
MEGAPROMPT_STYLES[git_master]="%b%F{white}"
MEGAPROMPT_STYLES[git_other]="%b%F{red}"
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
PS1_cmd_stat='%(?,, %b%F{cyan}<%F{red}%?%F{cyan}>)'
PS1_jobs='%(1j, ${MEGAPROMPT_STYLES[jobs_brackets]}[${MEGAPROMPT_STYLES[jobs]}%jj${MEGAPROMPT_STYLES[jobs_brackets]}],)'

--getHgBranchForPrompt() {
    local branch
    branch=$(hg branch 2>/dev/null)
    if [[ "$branch" = "default" ]]; then
        echo "%F{grey}<${MEGAPROMPT_STYLES[git_master]}${branch}%F{grey}> "
    elif [[ -n "$branch" ]]; then
        echo "%F{grey}<${MEGAPROMPT_STYLES[git_other]}${branch}%F{grey}> "
    fi
}

--getGitBranchForPrompt() {
    local branch
    branch=$(git branch 2>/dev/null | fgrep '*')
    if [ "$branch" = "* master" ]
    then
        branch="%F{grey}[${MEGAPROMPT_STYLES[git_master]}${branch:2}%F{grey}] "
    elif [ -n "$branch" ]
    then
        branch="%F{grey}[${MEGAPROMPT_STYLES[git_other]}${branch:2}%F{grey}] "
    fi
    echo $branch
}

--getPwdForPrompt() {
    local out
    local dir
    dir="$PWD"
    out=""
    while true; do
        if [[ "$dir" = "$HOME" ]]; then
            echo "$(--getDirColor $dir)~/${out}"
            return
        elif [[ "$dir" = "/" ]]; then
            echo "$(--getDirColor $dir)/${out}"
            return
        else
            out="$(--getDirColor $dir)$(basename $dir)/${out}"
            dir="$(dirname $dir)"
        fi
    done
}

--getDirColor() {
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

update-prompt() {
    local -A s
    set -A s ${(kv)MEGAPROMPT_STYLES}
    local k=$MEGAPROMPT_KEYMAP_IND[$ZSH_CUR_KEYMAP]
    if [[ -z "$k" ]]; then
        k=$MEGAPROMPT_KEYMAP_IND[keymap_unlisted]
    fi

    PS1="$s[time]%T ${s[userhost_brackets]}[${s[username]}%n${s[at]}@${s[host]}%m${s[userhost_brackets]}] \$(--getGitBranchForPrompt)\$(--getHgBranchForPrompt)\$(--getPwdForPrompt)${PS1_jobs}${PS1_cmd_stat}
${k} ${s[histnum]}%h ${s[dollar]}%# "
    if zle; then
        zle reset-prompt
    fi
}

if type -f hooks-add-hook 1>/dev/null 2>&1; then
    hooks-add-hook zle_keymap_select_hook update-prompt
    add-zsh-hook precmd update-prompt
else
    echo "zsh-hooks not loaded!  Please load willghatch/zsh-hooks before zsh-megaprompt." 1>&2
fi
