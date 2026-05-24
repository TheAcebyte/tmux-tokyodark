#!/bin/bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
    local option="$1"
    local default="$2"
    local value
    value="$(tmux show-option -gqv "$option")"

    echo "${value:-$default}"
}

set_tmux_option() {
    tmux_commands+=(set-option -gq "$1" "$2" ";")
}

set_window_option() {
    tmux_commands+=(set-window-option -gq "$1" "$2" ";")
}

main() {
    local tmux_commands=()
    source /dev/stdin <<<"$(sed -e "/^[^#].*=/s/^/local /" "${PLUGIN_DIR}/tokyodark.tmuxtheme")"

    set_tmux_option "status" "on"
    set_tmux_option "status-bg" "${thm_bg}"
    set_tmux_option "status-justify" "left"
    set_tmux_option "status-left-length" "100"
    set_tmux_option "status-right-length" "100"

    set_tmux_option "message-style" "fg=${thm_cyan},bg=${thm_gray},align=centre"
    set_tmux_option "message-command-style" "fg=${thm_cyan},bg=${thm_gray},align=centre"

    set_tmux_option "pane-border-style" "fg=${thm_gray}"
    set_tmux_option "pane-active-border-style" "fg=${thm_blue}"

    set_window_option "window-status-activity-style" "fg=${thm_fg},bg=${thm_bg},none"
    set_window_option "window-status-separator" ""
    set_window_option "window-status-style" "fg=${thm_fg},bg=${thm_bg},none"

    local right_sep="$(get_tmux_option "@catppuccin_right_separator" "")"
    local show_time="#[fg=$thm_yellow,bg=$thm_bg,nobold,nounderscore,noitalics]$right_sep#[fg=$thm_bg,bg=$thm_yellow,nobold,nounderscore,noitalics]󰥔 #[fg=$thm_fg,bg=$thm_gray] %H:%M #{?client_prefix,#[fg=$thm_red]"
    local show_session="#[fg=$thm_green]}#[bg=$thm_gray]$right_sep#{?client_prefix,#[bg=$thm_red],#[bg=$thm_green]}#[fg=$thm_bg] #[fg=$thm_fg,bg=$thm_gray] #S "

    local show_window_status="#[fg=$thm_bg,bg=$thm_fg] #I #[fg=$thm_fg,bg=$thm_gray] #W "
    local show_window_status_current="#[fg=colour232,bg=$thm_blue] #I #[fg=colour254,bg=colour237] #W "

    set_tmux_option "status-left" ""
    set_tmux_option "status-right" "${show_time},${show_session}"
    set_window_option "window-status-format" "${show_window_status}"
    set_window_option "window-status-current-format" "${show_window_status_current}"

    set_window_option "clock-mode-colour" "${thm_blue}"
    set_window_option "mode-style" "fg=${thm_pink} bg=${thm_black4} bold"

    tmux "${tmux_commands[@]}"
}

main "$@"
