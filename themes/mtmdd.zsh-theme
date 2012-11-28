# Adapted from the funky theme

add-zsh-hook precmd mtmdd_precmd
add-zsh-hook preexec mtmdd_preexec

local at_sym="%{$fg_bold[black]%}@%{$reset_color%}"
local colon_sym="%{$fg_bold[black]%}:%{$reset_color%}"
local blue_op="%{$fg[blue]%}[%{$reset_color%}"
local blue_cp="%{$fg[blue]%}]%{$reset_color%}"
local red_lt="%{fg[red]%}<%{$reset_color%}"
local red_gt="%{fg[red]%}>%{$reset_color%}"
local upper_tri="%(?,%{$fg[green]%},%{$fg[red]%})◸%{$reset_color%}"
local lower_tri="%(?,%{$fg[green]%},%{$fg[red]%})◺%{$reset_color%}"
local user_host="%(#,%{$fg[red]%},%{$fg[white]%})%n%{$reset_color%}${at_sym}%{$fg[white]%}%m%{$reset_color%}"
local time="%T"
local hist_no="${blue_op}%h${at_sym}${time}${blue_cp}"
local cur_cmd="${blue_op}%_${blue_cp}"

# Table flip
typeset -A table;
table=(
    flip "%{$fg[yellow]%}%? %{$fg[red]%}（╯°□°）╯︵ ┻━┻"
    upright "%{$fg[yellow]%}┳━┳ ~ ◞(◦_◦◞)"
    caine "%{$fg[green]%}(⌐•_•)"
    )

# Version Control Systems
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr "%{$fg[yellow]%}"
zstyle ':vcs_info:git*' stagedstr "%{$fg[red]%}"
zstyle ':vcs_info:git*' formats "%{$FG[024]%}-%{$reset_color%}${blue_op}%s${at_sym}%r${colon_sym}%{$fg[white]%}%u%c%b%{$reset_color%}${blue_cp}"
zstyle ':vcs_info:git*' actionformats "%{$FG[024]%}-%{$reset_color%}${blue_op}%s${at_sym}%r${colon_sym}%{$fg[white]%}%u%c%b%{%reset_color%}${red_lt}%a${red_gt}${blue_cp}"

mtmdd_precmd() {
    vcs_info

    if [[ $? -ne 0 ]]; then
        export table_status="flip"
    fi
}

mtmdd_preexec() {
    if [[ $table_status = "flip" ]]; then
        export table_status="upright"
    elif [[ $table_status = "upright" ]]; then
        export table_status="caine"
    fi
}

right_prompt() {
    echo "${table[${table_status:-caine}]}%{$reset_color%}"
}

left_prompt() {

    local path_colour="%{$fg[white]%}"
    [[ ! "${${PWD%${HOME}*}}" = "" ]] && path_colour="%{$fg[red]%}"
    local path_p="${path_colour}%~%{$reset_color%}"

    local priv_colour="%{$fg[white]%}"
    [[ ! ${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/} = "" ]] && priv_colour="%{$fg[red]%}"
    local priv_p="${priv_colour}%#%{$reset_color%}"

    local top_p="${upper_tri}${blue_op}${user_host}${colon_sym}${path_p}${blue_cp}${vcs_info_msg_0_}"
    local bottom_p="${lower_tri}${hist_no}${priv_p} "

    echo "${top_p}\n${bottom_p}"

}

PROMPT='$(left_prompt)'
PROMPT2="${cur_cmd}> "
RPROMPT='$(right_prompt)'
