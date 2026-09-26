{ ... }:

{
  nix-homebrew = {
    enable = true;
    user = "alputer";
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = false;
    };

    taps = [
      { name = "nikitabobko/tap"; trusted = true; }
      { name = "FelixKratz/formulae"; trusted = true; }
    ];

    brews = [
      # Build dependencies used by mise-managed language runtimes.
      "autoconf"
      "automake"
      "pkg-config"
      "libtool"
      "libffi"
      "openssl@3"
      "zlib"
      "gmp"
      "libyaml"
      "readline"

      # Host CLIs and macOS integrations.
      "borders"
      "colima"
      "container"
      "fish"
      "kanata"
      "mas"
      "mise"
      "sketchybar"
      "stow"
      "zsh-autosuggestions"
      "zsh-history-substring-search"
      "zsh-syntax-highlighting"
    ];

    casks = [
      "font-jetbrains-mono-nerd-font"
      "font-sketchybar-app-font"
      "aerospace"
      "brave-browser"
      "cursor"
      "docker-desktop"
      "figma"
      "notion"
      "obsidian"
      "postman"
      "raycast"
      "shottr"
      "slack"
      "tailscale-app"
      "visual-studio-code"
      "wezterm"
      "whatsapp"
      "zoom"
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}
