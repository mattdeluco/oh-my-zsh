# Adapted from the funky theme

add-zsh-hook precmd mtmdd

local at_sym="%{$fg_bold[black]%}@%{$reset_color%}"
local colon_sym="%{$fg_bold[black]%}:%{$reset_color%}"
local blue_op="%{$fg[blue]%}[%{$reset_color%}"
local blue_cp="%{$fg[blue]%}]%{$reset_color%}"
local upper_tri="%(?,%{$fg[green]%},%{$fg[red]%})◸%{$reset_color%}"
local lower_tri="%(?,%{$fg[green]%},%{$fg[red]%})◺%{$reset_color%}"

typeset -A table;
table=(
    flip "%{$fg[yellow]%}%? %{$fg[red]%}（╯°□°）╯︵ ┻━┻"
    upright "%{$fg[yellow]%}┳━┳ ~ ◞(◦_◦◞)"
    caine "%{$fg[green]%}(⌐■_■)"
    )

local user_host="%(#,%{$fg[red]%},%{$fg[white]%})%n%{$reset_color%}${at_sym}%{$fg[white]%}%m%{$reset_color%}"
local time="%T"
local hist_no="${blue_op}%h${at_sym}${time}${blue_cp}"

local cur_cmd="${blue_op}%_${blue_cp}"
PROMPT2="${cur_cmd}> "

mtmdd() {
    if [[ $table_status = "flip" && $? -eq 0 ]]; then
        export table_status="upright"
    elif [[ $table_status = "upright" ]]; then
        export table_status="caine"
    fi
}

TRAPZERR() {
    export table_status="flip"
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

    echo "${upper_tri}${blue_op}${user_host}${colon_sym}${path_p}${blue_cp}\n${lower_tri}${hist_no}${priv_p} "

    export foobarbaz=1234

}

PROMPT='$(left_prompt)'
RPROMPT='$(right_prompt)'

