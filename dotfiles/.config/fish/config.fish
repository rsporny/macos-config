if status is-interactive
    abbr --add -- ll "ls -lha"
    abbr --add -- vim nvim
    direnv hook fish | source
    fish_add_path /opt/homebrew/opt/llvm/bin  # fix secp256k1 rust compilation, clang
end
