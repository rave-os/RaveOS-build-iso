#!/bin/bash
# RaveOS terminal greeting
# Guard: prevent double execution (login shell profile.d + .bashrc)
[[ -n "$_RAVEOS_GREETING_DONE" ]] && return 2>/dev/null
_RAVEOS_GREETING_DONE=1

if command -v fastfetch &>/dev/null; then
    if [[ "$TERM" == "xterm-kitty" ]]; then
        _rows=$(tput lines 2>/dev/null || echo 40)
        _logo_h=$(( _rows * 40 / 100 ))
        (( _logo_h < 8 )) && _logo_h=8
        (( _logo_h > 24 )) && _logo_h=24
        fastfetch --config ~/.config/fastfetch/config-kitty.jsonc --logo-height "$_logo_h"
        unset _rows _logo_h
    else
        fastfetch
    fi
fi
