
setopt prompt_subst

typeset -Ag MEGAPROMPT_STYLES
MEGAPROMPT_STYLES[time]="%b%F{cyan}"
MEGAPROMPT_STYLES[host]="%B%F{yellow}"
MEGAPROMPT_STYLES[userhost_brackets]="%b%F{green}"
MEGAPROMPT_STYLES[username]="%B%F{green}"
MEGAPROMPT_STYLES[username_root]="%B%F{red}"
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
PS1_cmd_stat='%(?,, %b%F{cyan}<%F{red}%?%F{cyan}>)'
PS1_jobs='%(1j, ${MEGAPROMPT_STYLES[jobs_brackets]}[${MEGAPROMPT_STYLES[jobs]}%jj${MEGAPROMPT_STYLES[jobs_brackets]}],)'

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

mp-updatePrompt() {
    local -A s
    set -A s ${(kv)MEGAPROMPT_STYLES}
    local k=$MEGAPROMPT_KEYMAP_IND[$ZSH_CUR_KEYMAP]
    if [[ -z "$k" ]]; then
        k=$MEGAPROMPT_KEYMAP_IND[keymap_unlisted]
    fi

    PS1="$s[time]%T ${s[userhost_brackets]}[\$(mp-getUser)${s[at]}@${s[host]}%m${s[userhost_brackets]}] \$(mp-getGitBranch)\$(mp-getHgBranch)\$(-mp-getPwd)${PS1_jobs}${PS1_cmd_stat}
${k} ${s[histnum]}%h ${s[prompt]}${s[prompt_char]} "
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
