{ config, pkgs, ... }:

let
  mod = "Mod1";
  laptopScreen = "eDP-1";
  externalMonitor = "DP-1";
in {
  home.username = "viodid";
  home.homeDirectory = "/home/viodid";
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    feh
    i3lock
    rofi
    brightnessctl
    pavucontrol
    xclip
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  services.blueman-applet.enable = true;

  # ----------------------------------------------------------------------------
  # Alacritty Terminal
  # ----------------------------------------------------------------------------
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
      colors = {
        primary = {
          background = "0x1e1e2e";
          foreground = "0xcdd6f4";
        };
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Tmux
  # ----------------------------------------------------------------------------
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

  # ----------------------------------------------------------------------------
  # Picom
  # ----------------------------------------------------------------------------
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    fade = false;
  };

  # ----------------------------------------------------------------------------
  # Dunst
  # ----------------------------------------------------------------------------
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "JetBrainsMono Nerd Font 10";
        frame_width = 1;
        frame_color = "#89b4fa";
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # i3status-rust
  # ----------------------------------------------------------------------------
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      blocks = [
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
        {
          block = "sound";
        }
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
      theme = "gruvbox-dark";
      icons = "awesome5";
    };
  };

  # ----------------------------------------------------------------------------
  # i3 Window Manager
  # ----------------------------------------------------------------------------
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      terminal = "alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons";

      focus = {
        followMouse = false;
        wrapping = "force";
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      workspaceOutputAssign = [
        { workspace = "1"; output = externalMonitor; }
        { workspace = "2"; output = externalMonitor; }
        { workspace = "3"; output = externalMonitor; }
        { workspace = "4"; output = externalMonitor; }
        { workspace = "5"; output = externalMonitor; }
        { workspace = "6"; output = externalMonitor; }
        { workspace = "7"; output = externalMonitor; }
        { workspace = "8"; output = externalMonitor; }
        { workspace = "9"; output = externalMonitor; }
        { workspace = "10"; output = laptopScreen; }
      ];

      keybindings = pkgs.lib.mkOptionDefault {
        "${mod}+Shift+x" = "exec ${pkgs.i3lock}/bin/i3lock -c 1e1e2e";

        # Audio
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

        # Brightness
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 10%-";

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
          command = "xrandr --output ${externalMonitor} --mode 3840x2560 --rate 119.99 --primary --pos 0x0 --output ${laptopScreen} --auto --pos 3840x1480";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ~/linux.png || true";
          always = true;
          notification = false;
        }
      ];

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs /home/viodid/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [ "JetBrainsMono Nerd Font" "FontAwesome" ];
            size = 13.0;
          };
        }
      ];
    };
  };

  programs.home-manager.enable = true;
}
