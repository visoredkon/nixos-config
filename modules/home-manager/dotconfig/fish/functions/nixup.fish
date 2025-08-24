function nixup
    if status is-interactive
        set -l color_header (set_color yellow)
        set -l color_success (set_color green)
        set -l color_error (set_color red)
        set -l color_info (set_color blue)
        set -l color_cmd (set_color cyan)
        set -l color_normal (set_color normal)
    else
        set -l color_header ""
        set -l color_success ""
        set -l color_error ""
        set -l color_info ""
        set -l color_cmd ""
        set -l color_normal ""
    end

    set -l config_dir ~/.config/nixos-config
    if set -q nixup_config_dir_override; and test -n "$nixup_config_dir_override"
        set config_dir $nixup_config_dir_override
    end

    function _nixup_help
        function _print_help_entry
            printf "  "
            set_color cyan
            printf "%-18s" $argv[1]
            set_color normal
            printf " %s\n" $argv[2]
        end
        echo "Usage: nixup [command] [--commit | \"message\"]"
        echo
        echo "Manages NixOS configuration with Git integration."
        echo
        echo "Commands:"
        _print_help_entry "apply [--commit]" "Stage & apply. With --commit, commits on success."
        _print_help_entry "boot [--commit]" "Stage & build boot. With --commit, commits on success."
        _print_help_entry "test [--commit]" "Stage & test. With --commit, commits on success."
        _print_help_entry "update [--commit]" "Update flakes & build. With --commit, commits on success."
        _print_help_entry "sync [message]" "Stage, commit with an optional message, and push."
        _print_help_entry log "Show git log of the NixOS configuration"
        _print_help_entry gc "Run garbage collection for user and system"
        _print_help_entry lazygit "Run lazygit in the NixOS config directory"
        _print_help_entry cd "Change directory to the NixOS config path"
        _print_help_entry config "Open the NixOS configuration directory in \$EDITOR"
        _print_help_entry "-h, --help" "Display this help message"
    end

    function _nixup_ensure_git_repo
        set -l target_dir $argv[1]
        set -l original_dir (pwd)
        cd "$target_dir"
        if test $status -ne 0
            echo (set_color red)"Fatal: Could not cd to '$target_dir'."(set_color normal)
            cd "$original_dir"
            return 1
        end

        if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo (set_color yellow)"Git repository not found. Initializing a new one..."(set_color normal)
            git init; and git add .; and git commit -m "I use NixOS btw"
            if test $status -ne 0
                echo (set_color red)"Failed to initialize Git repository."(set_color normal)
                cd "$original_dir"
                return 1
            end
            echo (set_color green)"Git repository initialized successfully."(set_color normal)
        end
        cd "$original_dir"
        return 0
    end

    function _nixup_git_sync
        set -l commit_message $argv[1]
        set -l target_dir $argv[2]
        set -l original_dir (pwd)
        cd "$target_dir"
        if test $status -ne 0
            echo (set_color red)"Fatal: Could not cd to '$target_dir'."(set_color normal)
            cd "$original_dir"
            return 1
        end

        if git diff --quiet --cached
            echo "No staged changes to commit."
            cd "$original_dir"
            return 0
        end

        echo ""
        echo (set_color yellow)"Committing and pushing changes..."(set_color normal)
        echo "  Commit message: '"(set_color blue)"$commit_message"(set_color normal)"'"

        git commit -m "$commit_message"; and echo ""; and git push
        set -l git_status $status

        if test $git_status -ne 0
            echo (set_color red)"Git operation failed. Aborting."(set_color normal)
        else
            echo (set_color green)"Git operations successful!"(set_color normal)
        end

        cd "$original_dir"
        return $git_status
    end

    if not test -d "$config_dir"
        echo (set_color red)"FATAL: NixOS config directory not found at '$config_dir'."(set_color normal)
        return 1
    end
    if not set -q argv[1]
        _nixup_help
        return 1
    end

    set -l command $argv[1]
    set -l should_commit false
    if contains -- --commit $argv
        set should_commit true
    end

    switch $command
        case -h --help
            _nixup_help
            return 0
        case config
            if not set -q EDITOR; or test -z "$EDITOR"
                echo (set_color red)"Error: \$EDITOR environment variable is not set."(set_color normal)
                return 1
            end
            echo (set_color yellow)"Opening configuration in \$EDITOR ($EDITOR)..."(set_color normal)
            cd "$config_dir"
            $EDITOR .
            cd -
            return 0
        case cd
            cd "$config_dir"
        case lazygit
            lazygit -p "$config_dir"
        case log
            git -C "$config_dir" log
            return $status
        case gc
            echo (set_color yellow)"Running garbage collection for user..."(set_color normal)
            nix-collect-garbage -d
            echo ""
            echo (set_color yellow)"Running garbage collection for system (sudo)..."(set_color normal)
            sudo nix-collect-garbage -d
            return $status
        case sync
            _nixup_ensure_git_repo "$config_dir"
            if test $status -ne 0
                return 1
            end

            echo ""
            echo (set_color yellow)"Staging all changes..."(set_color normal)
            fish -c "cd '$config_dir'; and git add ."
            if test $status -ne 0
                echo (set_color red)"Failed to stage changes with 'git add'."(set_color normal)
                return 1
            end

            set -l commit_message
            if set -q argv[2]; and test -n "$argv[2]"
                set commit_message $argv[2]
            else
                set -l now (date --iso-8601=seconds)
                set commit_message "chore(nixos): manual sync @ $now"
            end

            _nixup_git_sync "$commit_message" "$config_dir"
            return $status
        case apply boot test update
            _nixup_ensure_git_repo "$config_dir"
            if test $status -ne 0
                return 1
            end

            echo ""
            echo (set_color yellow)"Staging all changes..."(set_color normal)
            fish -c "cd '$config_dir'; and git add ."
            if test $status -ne 0
                echo (set_color red)"Failed to stage changes with 'git add'."(set_color normal)
                return 1
            end

            if test $command = update
                echo ""
                echo (set_color yellow)"Updating flake inputs..."(set_color normal)
                fish -c "cd '$config_dir'; and nix flake update"
                if test $status -ne 0
                    echo (set_color red)"Flake update failed. Aborting."(set_color normal)
                    return 1
                end
                fish -c "cd '$config_dir'; and git add flake.lock"
            end

            if fish -c "cd '$config_dir'; and git diff --quiet --cached"
                echo "No changes staged. Nothing to build or commit."
                return 0
            end

            set -l build_msg
            set -l build_command_exec
            switch $command
                case apply
                    set build_msg "Applying new configuration (switch)..."
                    set build_command_exec "nixos switch"
                case boot
                    set build_msg "Building new boot generation..."
                    set build_command_exec "nixos boot"
                case test
                    set build_msg "Building and testing current (staged) configuration..."
                    set build_command_exec "nixos test"
                case update
                    set build_msg "Building new boot generation with all packages upgraded..."
                    set build_command_exec "sudo nixos-rebuild boot --flake '$config_dir' --upgrade-all"
            end

            echo ""
            echo (set_color yellow)$build_msg(set_color normal)
            eval $build_command_exec
            set -l build_status $status

            if test $build_status -eq 0
                if $should_commit
                    echo ""
                    echo (set_color green)"Build successful."(set_color normal)
                    set -l now (date --iso-8601=seconds)
                    set -l commit_message "feat(nixos): configuration update @ $now"
                    if test $command = update
                        set commit_message "feat(nixos): update flake inputs and apply changes @ $now"
                    end
                    _nixup_git_sync "$commit_message" "$config_dir"
                    return $status
                else
                    return 0
                end
            else
                echo ""
                echo (set_color red)"Build failed. Changes are staged but not committed."(set_color normal)
                return $build_status
            end
        case '*'
            if string match -q -- "--*" $command
                echo (set_color red)"Error: Flag \"$command\" must be used with a command (e.g., test, apply)."(set_color normal)
            else
                echo (set_color red)"Error: Unknown command \"$command\""(set_color normal)
            end
            echo
            _nixup_help
            return 1
    end

    if test $command = sync; or begin
            contains $command apply boot test update; and $should_commit
        end
        echo ""
        echo (set_color green)"Done."(set_color normal)
    end
end
