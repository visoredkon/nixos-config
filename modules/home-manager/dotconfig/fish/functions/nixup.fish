function nixup
    set -l config_dir ~/.config/nixos-config
    if set -q nixup_config_dir_override; and test -n "$nixup_config_dir_override"
        set config_dir $nixup_config_dir_override
    end
    set -l secrets_dir "$config_dir/secrets"

    function _print_help_entry
        printf "  "
        set_color cyan
        printf "%-18s" $argv[1]
        set_color normal
        printf " %s\n" $argv[2]
    end

    function _nixup_help
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

        if not git -C "$target_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo (set_color yellow)"Git repository not found. Initializing a new one..."(set_color normal)
            git -C "$target_dir" init \
                and git -C "$target_dir" add . \
                and git -C "$target_dir" commit -m "I use NixOS btw"
            if test $status -ne 0
                echo (set_color red)"Failed to initialize Git repository."(set_color normal)
                return 1
            end
            echo (set_color green)"Git repository initialized successfully."(set_color normal)
        end

        git -C "$target_dir" submodule update --init >/dev/null 2>&1
    end

    function _nixup_fmt
        set -l cfg_dir $argv[1]

        echo ""
        echo (set_color yellow)"Formatting files with nix fmt..."(set_color normal)
        fish -c "cd '$cfg_dir'; and nix fmt"
        if test $status -ne 0
            echo (set_color red)"Formatting failed. Aborting."(set_color normal)
            return 1
        end
    end

    function _nixup_prepare
        set -l cfg_dir $argv[1]
        set -l sec_dir $argv[2]

        _nixup_ensure_git_repo "$cfg_dir"
        if test $status -ne 0
            return 1
        end

        _nixup_fmt "$cfg_dir"
        if test $status -ne 0
            return 1
        end

        echo ""
        echo (set_color yellow)"Staging all changes..."(set_color normal)
        _nixup_stage_all "$cfg_dir" "$sec_dir"
        if test $status -ne 0
            return 1
        end
    end

    function _nixup_stage_all
        set -l cfg_dir $argv[1]
        set -l sec_dir $argv[2]

        if test -d "$sec_dir"
            git -C "$sec_dir" add .
            if test $status -ne 0
                echo (set_color red)"Failed to stage secrets submodule."(set_color normal)
                return 1
            end
        end

        git -C "$cfg_dir" add .
        if test $status -ne 0
            echo (set_color red)"Failed to stage changes with 'git add'."(set_color normal)
            return 1
        end
        return 0
    end

    function _nixup_check_secrets_encrypted
        set -l sec_dir $argv[1]

        if not test -d "$sec_dir"
            return 0
        end

        set -l unencrypted
        for f in (fd -e yaml --exclude .sops.yaml . "$sec_dir")
            if not grep -q 'ENC\[AES256_GCM' "$f"
                set -a unencrypted $f
            end
        end

        if test (count $unencrypted) -gt 0
            echo (set_color red)"Aborted: the following secrets files are not SOPS-encrypted:"(set_color normal)
            for f in $unencrypted
                echo "  "(set_color yellow)"$f"(set_color normal)
            end
            echo "Encrypt with: "(set_color cyan)"sops -e -i <file>"(set_color normal)
            return 1
        end
        return 0
    end

    function _nixup_git_sync
        set -l commit_message $argv[1]
        set -l cfg_dir $argv[2]
        set -l sec_dir $argv[3]

        _nixup_check_secrets_encrypted "$sec_dir"
        if test $status -ne 0
            return 1
        end

        if not string match -rq '^(chore|feat)\([^)]+\): ' $commit_message
            set commit_message "feat(nixos): $commit_message"
        end
        set -l secrets_body (string replace -r '^(chore|feat)\([^)]+\): ' '' $commit_message)
        set -l secrets_hash ""

        if test -d "$sec_dir"; and not git -C "$sec_dir" diff --quiet --cached
            echo ""
            echo (set_color yellow)"Committing secrets submodule..."(set_color normal)
            git -C "$sec_dir" commit -m "feat(secrets): $secrets_body"
            if test $status -ne 0
                echo (set_color red)"Failed to commit secrets submodule."(set_color normal)
                return 1
            end
            git -C "$sec_dir" push
            if test $status -ne 0
                echo (set_color red)"Failed to push secrets submodule."(set_color normal)
                return 1
            end
            set secrets_hash (git -C "$sec_dir" rev-parse --short HEAD)
            git -C "$cfg_dir" add "$sec_dir"
        end

        if git -C "$cfg_dir" diff --quiet --cached
            echo "No staged changes to commit."
            return 0
        end

        echo ""
        echo (set_color yellow)"Committing and pushing changes..."(set_color normal)
        echo "  Commit message: '"(set_color blue)"$commit_message"(set_color normal)"'"

        if test -n "$secrets_hash"
            git -C "$cfg_dir" commit -m "$commit_message" -m "secrets: $secrets_hash"
        else
            git -C "$cfg_dir" commit -m "$commit_message"
        end
        if test $status -ne 0
            echo (set_color red)"Git operation failed. Aborting."(set_color normal)
            return 1
        end

        echo ""
        git -C "$cfg_dir" push
        if test $status -ne 0
            echo (set_color red)"Push failed. Aborting."(set_color normal)
            return 1
        end

        echo (set_color green)"Git operations successful!"(set_color normal)
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
            _nixup_prepare "$config_dir" "$secrets_dir"
            if test $status -ne 0
                return 1
            end

            set -l commit_message
            if set -q argv[2]; and test -n "$argv[2]"
                set commit_message $argv[2]
            else
                set -l now (date --iso-8601=seconds)
                set commit_message "feat(nixos): manual sync @ $now"
            end

            _nixup_git_sync "$commit_message" "$config_dir" "$secrets_dir"
            return $status
        case apply boot test update
            _nixup_prepare "$config_dir" "$secrets_dir"
            if test $status -ne 0
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
                git -C "$config_dir" add flake.lock
            end

            if git -C "$config_dir" diff --quiet --cached
                echo "No changes staged. Nothing to build or commit."
                return 0
            end

            echo ""
            switch $command
                case apply
                    echo (set_color yellow)"Applying new configuration (switch)..."(set_color normal)
                    fish -c "cd '$config_dir'; and nixos apply"
                case boot
                    echo (set_color yellow)"Building new boot generation..."(set_color normal)
                    fish -c "cd '$config_dir'; and nixos boot"
                case test
                    echo (set_color yellow)"Building and testing current (staged) configuration..."(set_color normal)
                    fish -c "cd '$config_dir'; and nixos test"
                case update
                    echo (set_color yellow)"Building new boot generation with all packages upgraded..."(set_color normal)
                    sudo nixos-rebuild boot --flake "$config_dir" --upgrade-all
            end
            set -l build_status $status

            if test $build_status -ne 0
                echo ""
                echo (set_color red)"Build failed. Changes are staged but not committed."(set_color normal)
                return $build_status
            end

            if $should_commit
                echo ""
                echo (set_color green)"Build successful."(set_color normal)
                set -l now (date --iso-8601=seconds)
                set -l commit_message "feat(nixos): configuration update @ $now"
                if test $command = update
                    set commit_message "feat(nixos): update flake inputs and apply changes @ $now"
                end
                _nixup_git_sync "$commit_message" "$config_dir" "$secrets_dir"
                return $status
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

end
