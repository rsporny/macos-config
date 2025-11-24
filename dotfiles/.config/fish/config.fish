if status is-interactive
    abbr --add -- ll "ls -lha"
    abbr --add -- vim nvim
    direnv hook fish | source
    fish_add_path /opt/homebrew/opt/llvm/bin  # fix secp256k1 rust compilation, clang
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519

    function source_cwd --on-variable FISH_SOURCE_CWD
        if test -n "$FISH_SOURCE_CWD"
            echo "🎣 Hook detected. Sourcing config.fish..."
            source "$PWD/config.fish"
        end
    end
end

