# mise
if type -q mise
    mise activate fish | source
else
    echo "fish: mise not found — brew install mise" >&2
end

# starship
if type -q starship
    starship init fish | source
else
    echo "fish: starship not found — mise install starship" >&2
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
        echo "fish: fastfetch not found — mise install fastfetch" >&2
    end
end


# modern cli tools
if type -q zoxide
    zoxide init fish | source
else
    echo "fish: zoxide not found — mise install zoxide" >&2
end
