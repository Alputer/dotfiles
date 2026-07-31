# starship
if type -q starship
    starship init fish | source
else
    echo "fish: starship not found — brew install starship" >&2
end

# mise
if type -q mise
    mise activate fish | source
else
    echo "fish: mise not found — brew install mise" >&2
end

# Start ssh-agent automatically
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
end

# system info once per boot
if status is-interactive
    if type -q fastfetch
        set -l stamp_file ~/.cache/fastfetch-boot
        set -l boot_time (sysctl -n kern.boottime | string replace -r '.*sec = (\d+).*' '$1')
        mkdir -p ~/.cache
        if not test -f $stamp_file; or test (cat $stamp_file) != $boot_time
            echo $boot_time > $stamp_file
            fastfetch
        end
    else
        echo "fish: fastfetch not found — brew install fastfetch" >&2
    end
end


# modern cli tools
if type -q zoxide
    zoxide init fish | source
else
    echo "fish: zoxide not found — brew install zoxide" >&2
end
