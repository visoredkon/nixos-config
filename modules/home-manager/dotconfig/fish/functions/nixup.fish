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
            printf "%-15s" $argv[1]
            set_color normal
            printf " %s\n" $argv[2]
        end
        echo "Usage: nixup [command]"
        echo
        echo "Manages NixOS configuration with Git integration."
        echo
        echo "Commands:"
        _print_help_entry apply "Commit, push, and apply the new configuration"
        _print_help_entry boot "Commit, push, and build a new boot generation"
        _print_help_entry update "Stage, commit, push, update flake inputs, and build"
        _print_help_entry test "Stage changes and test the configuration"
        _print_help_entry test-commit "Commit, push, then build and test the configuration"
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

        if git diff --quiet HEAD --
            echo "No manual changes to commit."
            cd "$original_dir"
            return 0
        end

        echo ""
        echo (set_color yellow)"Committing and pushing manual changes..."(set_color normal)
        echo "   Commit message: '"(set_color blue)"$commit_message"(set_color normal)"'"

        git add .; and git commit -m "$commit_message"; and echo ""; and git push
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

    set -l command_to_run $argv[1]

    switch $command_to_run
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
        case test
            echo ""
            echo (set_color yellow)"Staging all changes for the test build..."(set_color normal)
            fish -c "cd '$config_dir'; and git add ."
            if test $status -ne 0
                echo (set_color red)"Failed to stage changes with 'git add'."(set_color normal)
                return 1
            end

            echo (set_color yellow)"Building and testing current (staged) configuration..."(set_color normal)
            nixos test
            return $status
        case update
            _nixup_ensure_git_repo "$config_dir"
            if test $status -ne 0
                return 1
            end

            echo ""
            echo (set_color yellow)"Staging all changes before update..."(set_color normal)
            fish -c "cd '$config_dir'; and git add ."
            if test $status -ne 0
                echo (set_color red)"Failed to stage changes with 'git add'."(set_color normal)
                return 1
            end

            set -l now (date --iso-8601=seconds)
            set -l commit_message "feat(nixos): configuration update @ $now"
            _nixup_git_sync "$commit_message" "$config_dir"
            if test $status -ne 0
                return 1
            end

            echo ""
            echo (set_color yellow)"Updating flake inputs..."(set_color normal)
            fish -c "cd '$config_dir'; and nix flake update"
            if test $status -ne 0
                echo (set_color red)"Flake update failed. Aborting."(set_color normal)
                return 1
            end

            echo ""
            echo (set_color yellow)"Committing updated 'flake.lock' file..."(set_color normal)
            set -l now_lock (date --iso-8601=seconds)
            set -l lock_commit_message "chore(nix): update flake.lock @ $now_lock"

            set -l original_dir_update (pwd)
            cd "$config_dir"
            git add flake.lock; and git commit -m "$lock_commit_message"; and echo ""; and git push; or begin
                echo "Could not commit 'flake.lock' (it may be unchanged). Continuing build..."
            end
            cd "$original_dir_update"

            echo ""
            echo (set_color yellow)"Building new boot generation with all packages upgraded..."(set_color normal)
            sudo nixos-rebuild boot --flake "$config_dir" --upgrade-all
        case apply boot test-commit
            _nixup_ensure_git_repo "$config_dir"
            if test $status -ne 0
                return 1
            end

            set -l now (date --iso-8601=seconds)
            set -l commit_message "feat(nixos): configuration update @ $now"
            _nixup_git_sync "$commit_message" "$config_dir"
            if test $status -ne 0
                return 1
            end

            echo ""

            if test $command_to_run = boot
                echo (set_color yellow)"Building new boot generation..."(set_color normal)
                nixos boot
            else if test $command_to_run = test-commit
                echo (set_color yellow)"Building and testing committed configuration..."(set_color normal)
                nixos test
            else
                echo (set_color yellow)"Applying new configuration..."(set_color normal)
                nixos apply
            end
        case '*'
            echo (set_color red)"Error: Unknown command \"$command_to_run\""(set_color normal)
            echo
            _nixup_help
            return 1
    end

    if contains $command_to_run apply boot update test-commit
        echo ""
        echo (set_color green)"Done."(set_color normal)
    end
end
