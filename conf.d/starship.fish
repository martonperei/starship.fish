if not status --is-interactive
    exit
end

set -g VIRTUAL_ENV_DISABLE_PROMPT 1

set -g STARSHIP_SHELL fish
set -gx STARSHIP_SESSION_KEY (random 10000000000000 9999999999999999)
set -g __starship_transient 0

function __starship_maybe_execute
    commandline --is-valid
    if test $status -eq 2
        or commandline --paging-full
        commandline --function accept-autosuggestion
        return 0
    end
    set -g __starship_transient 1
    commandline -f expand-abbr suppress-autosuggestion repaint execute
end

function __starship_cancel_commandline
    set -g __starship_transient 1
    if test "$(commandline --current-buffer)" = ""
        commandline -f repaint execute
        return 0
    end
    commandline -f repaint cancel-commandline kill-inner-line repaint-mode repaint
end

function __starship_prompt_event --on-event fish_prompt
    set -g __starship_transient 0
end

function __starship_cancel_repaint_event --on-event fish_cancel
    set -g __starship_transient 0
    commandline -f repaint
end

function fish_prompt
    switch "$fish_key_bindings"
        case fish_hybrid_key_bindings fish_vi_key_bindings
            set STARSHIP_KEYMAP "$fish_bind_mode"
        case '*'
            set STARSHIP_KEYMAP insert
    end

    set -g STARSHIP_CMD_PIPESTATUS $pipestatus
    set -g STARSHIP_CMD_STATUS $status
    set -g STARSHIP_DURATION "$CMD_DURATION"
    set -g STARSHIP_JOBS (count (jobs -p))

    if test $__starship_transient -eq 1
        printf '\e[0J'
        starship prompt --profile transient \
            --terminal-width="$COLUMNS" --status=$STARSHIP_CMD_STATUS \
            --pipestatus="$STARSHIP_CMD_PIPESTATUS" --keymap=$STARSHIP_KEYMAP \
            --cmd-duration=$STARSHIP_DURATION --jobs=$STARSHIP_JOBS
    else
        starship prompt --terminal-width="$COLUMNS" --status=$STARSHIP_CMD_STATUS \
            --pipestatus="$STARSHIP_CMD_PIPESTATUS" --keymap=$STARSHIP_KEYMAP \
            --cmd-duration=$STARSHIP_DURATION --jobs=$STARSHIP_JOBS
    end
end

builtin functions -e fish_mode_prompt

bind --user \r __starship_maybe_execute
bind --user \cc __starship_cancel_commandline
bind --user \cj __starship_maybe_execute
