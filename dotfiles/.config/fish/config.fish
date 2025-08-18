if status is-interactive
    abbr --add -- ll "ls -lha"
    abbr --add -- vim nvim
    direnv hook fish | source
end
