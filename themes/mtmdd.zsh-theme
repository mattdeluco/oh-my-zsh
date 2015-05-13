# Adapted from the funky theme

add-zsh-hook precmd mtmdd_precmd
add-zsh-hook preexec mtmdd_preexec

local at_sym="%{$fg_bold[black]%}@%{$reset_color%}"
local colon_sym="%{$fg_bold[black]%}:%{$reset_color%}"
local fslash_sym="%{$fg_bold[black]%}/%{$reset_color%}"
local blue_op="%{$fg[blue]%}[%{$reset_color%}"
local blue_cp="%{$fg[blue]%}]%{$reset_color%}"
local red_lt="%{$fg[red]%}<%{$reset_color%}"
local red_gt="%{$fg[red]%}>%{$reset_color%}"
local upper_tri="%(?,%{$fg[green]%},%{$fg[red]%})◸%{$reset_color%}"
local lower_tri="%(?,%{$fg[green]%},%{$fg[red]%})◺%{$reset_color%}"
local user_host="%(#,%{$fg[red]%},%{$fg_bold[blue]%})%n%{$reset_color%}${at_sym}%{$FG[027]%}%m%{$reset_color%}"
local time="%T"
local hist_no="${blue_op}%h${at_sym}${time}${blue_cp}"
local cur_cmd="${blue_op}%_${blue_cp}"

# Version Control Systems
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "%{$fg[yellow]%}"
zstyle ':vcs_info:*' stagedstr "%{$fg[red]%}"
local git_branch="%{$fg[green]%}%u%c%b%{$reset_color%}"
zstyle ':vcs_info:*' formats "${blue_op}%s${at_sym}%{$FG[027]%}%r%{$reset_color%}${fslash_sym}${git_branch}${colon_sym}%{$fg_bold[blue]%}%S%{$reset_color%}${blue_cp}"
zstyle ':vcs_info:*' actionformats "${blue_op}%s${at_sym}%r${colon_sym}%{$fg_bold[blue]%}%u%c%b%{$reset_color%}${red_lt}%{$fg_bold[blue]%}%a%{$reset_color%}${red_gt}${blue_cp}"

mtmdd_precmd() {
    vcs_info
}

mtmdd_preexec() {
}

right_prompt() {
    local python_virtualenv=${VIRTUAL_ENV##*/}
    local venv_prompt="{%{$fg[green]%}${python_virtualenv}%{$reset_color%}}"
    printf '%s' "${python_virtualenv:+$venv_prompt}"
}

left_prompt() {

    local path_colour="%{$fg_bold[blue]%}"
    [[ -n ${${PWD%${HOME}*}} ]] && path_colour="%{$fg[red]%}"
    local path_p="${path_colour}%~%{$reset_color%}"

    local priv_colour="%{$fg_bold[blue]%}"
    [[ -n ${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/} ]] && priv_colour="%{$fg[red]%}"
    local priv_p="${priv_colour}%#%{$reset_color%}"

    local top_p="${blue_op}${user_host}${colon_sym}${path_p}${blue_cp}"
    local bottom_p="${hist_no}${priv_p} "

    printf '%s\n%s' "${upper_tri}${vcs_info_msg_0_:-$top_p}" "${lower_tri}${bottom_p}"

}

PROMPT='$(left_prompt)'
PROMPT2="${cur_cmd}> "
RPROMPT='$(right_prompt)'
