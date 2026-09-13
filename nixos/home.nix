{ config, pkgs, lib, ... }:

let
  mod = "Mod1";
  laptopScreen = "eDP-1";
  externalMonitor = "DP-1";

  # Catppuccin Mocha palette, shared by every program below
  colors = {
    base = "1e1e2e";
    text = "cdd6f4";
    blue = "89b4fa";
  };

  wallpaper = ./linux.png;

  # Full paths to binaries (named *Bin so they don't shadow pkgs.* inside `with pkgs`)
  xrandrBin 	   = "${pkgs.xrandr}/bin/xrandr";
  wpctlBin         = "${pkgs.wireplumber}/bin/wpctl";
  brightnessctlBin = "${pkgs.brightnessctl}/bin/brightnessctl";

  # Pick a power profile from a rofi menu
  powerProfileMenu = pkgs.writeShellScript "power-profile-menu" ''
    current=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)
    choice=$(printf 'power-saver\nbalanced\nperformance' \
      | ${pkgs.rofi}/bin/rofi -dmenu -p "power ($current)") || exit 0
    ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$choice"
  '';
in {
  home.username = "viodid";
  home.homeDirectory = "/home/viodid";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  # ---------------------------------------------------------------------------
  # Packages
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Desktop
    feh
    brightnessctl
    pavucontrol
    xclip
    gimp
    nerd-fonts.jetbrains-mono

    # Neovim + LSP servers enabled in lsp.lua
    neovim
    basedpyright
    gopls
    clang-tools            # clangd
    lua-language-server
    ruff
    nil                    # nix

    # Plugin build/runtime deps
    gcc gnumake            # telescope-fzf-native `build = 'make'`
    ripgrep fd             # multigrep.lua shells out to rg
  ];

  programs.firefox.enable = true;

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "viodid";
        email = "david.yunta.aller@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    font = "JetBrainsMono Nerd Font 11";
  };

  services.blueman-applet.enable = true;

  # Lock on suspend/lid close and after 10 min idle
  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -c ${colors.base}";
    inactiveInterval = 10;
  };

  # ---------------------------------------------------------------------------
  # Neovim
  # ---------------------------------------------------------------------------
  home.file.".local/share/nvim/site/pack/nix/start/nvim-treesitter".source =
    pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
      python go c cpp lua bash json yaml toml
      markdown markdown_inline dockerfile nix rust
      javascript typescript tsx html css sql
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";

  # ---------------------------------------------------------------------------
  # Alacritty
  # ---------------------------------------------------------------------------
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 10; y = 10; };
        opacity = 0.95;
      };
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        size = 11.0;
      };
      colors.primary = {
        background = "0x${colors.base}";
        foreground = "0x${colors.text}";
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Tmux
  # ---------------------------------------------------------------------------
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    escapeTime = 5;
    extraConfig = ''
      set -g status off
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      unbind n
      bind n last-window
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel '${pkgs.xclip}/bin/xclip -in -selection clipboard'
    '';
  };

  # ---------------------------------------------------------------------------
  # Picom
  # ---------------------------------------------------------------------------
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    fade = false;
  };

  # ---------------------------------------------------------------------------
  # Dunst
  # ---------------------------------------------------------------------------
  services.dunst = {
    enable = true;
    settings.global = {
      font = "JetBrainsMono Nerd Font 10";
      frame_width = 1;
      frame_color = "#${colors.blue}";
      background = "#${colors.base}";
      foreground = "#${colors.text}";
      timeout = 5;
    };
  };

  # ---------------------------------------------------------------------------
  # i3status-rust
  # ---------------------------------------------------------------------------
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      theme = "ctp-mocha";
      icons = "material-nf";
      blocks = [
        {
          block = "custom";
          command = "${pkgs.curl}/bin/curl -s --max-time 2 ifconfig.me";
          interval = 60;
          format = " $text ";
        }
        {
          block = "disk_space";
          path = "/";
          info_type = "available";
          interval = 60;
          format = " $icon $available ";
        }
        {
          block = "memory";
          format = " $icon $mem_used_percents ";
        }
        {
          block = "cpu";
          interval = 2;
        }
        { block = "sound"; }
        {
          block = "battery";
          interval = 10;
          format = " $icon $percentage ";
        }
        {
          block = "time";
          interval = 60;
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
        }
      ];
    };
  };

  # ---------------------------------------------------------------------------
  # i3
  # ---------------------------------------------------------------------------
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons";

      focus = {
        followMouse = true;
        wrapping = "force";
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      workspaceOutputAssign =
        map (n: { workspace = toString n; output = externalMonitor; }) (lib.range 1 9)
        ++ [ { workspace = "10"; output = laptopScreen; } ];

      keybindings = lib.mkOptionDefault {
        "${mod}+Shift+x" = "exec ${config.services.screen-locker.lockCmd}";

        # Power profile picker
        "${mod}+p" = "exec --no-startup-id ${powerProfileMenu}";

        # Audio (PipeWire/WirePlumber, capped at 100%)
        "XF86AudioRaiseVolume" = "exec --no-startup-id ${wpctlBin} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${wpctlBin} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute"        = "exec --no-startup-id ${wpctlBin} set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # Brightness
        "XF86MonBrightnessUp"   = "exec --no-startup-id ${brightnessctlBin} set +10%";
        "XF86MonBrightnessDown" = "exec --no-startup-id ${brightnessctlBin} set 10%-";

        # Navigation (Vim keys)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
      };

      startup = [
        {
          # Docked layout; falls back to laptop-only if DP-1 is not connected
          command = lib.concatStringsSep " " [
            "${xrandrBin} --output ${externalMonitor} --mode 3840x2560 --rate 120 --primary --pos 0x0"
            "--output ${laptopScreen} --auto --pos 3840x1480"
            "|| ${xrandrBin} --output ${laptopScreen} --auto --primary"
          ];
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
          always = true;
          notification = false;
        }
      ];

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
          fonts = {
            names = [ "JetBrainsMono Nerd Font" ];
            size = 13.0;
          };
        }
      ];
    };
  };
}
