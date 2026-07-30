# Start ssh-agent automatically
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
end

# mise
if type -q mise
    mise activate fish | source
end

# starship
if type -q starship
    starship init fish | source
end
