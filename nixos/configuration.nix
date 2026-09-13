{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---------------------------------------------------------------------------
  # Nix
  # ---------------------------------------------------------------------------
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Arrow Lake is new; uncomment if you hit graphics glitches or poor idle
  # battery on the default kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---------------------------------------------------------------------------
  # Hardware: Intel Core Ultra 7 255U (Arrow Lake-U)
  # ---------------------------------------------------------------------------
  hardware.cpu.intel.updateMicrocode = true;

  # iGPU: OpenGL/Vulkan + hardware video decode (VA-API)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # BIOS / firmware updates via LVFS  (fwupdmgr refresh && fwupdmgr update)
  services.fwupd.enable = true;

  # ---------------------------------------------------------------------------
  # Power management
  # ---------------------------------------------------------------------------
  # Three profiles (power-saver / balanced / performance) via `powerprofilesctl`
  services.power-profiles-daemon.enable = true;

  # Proactive thermal management for Intel CPUs
  services.thermald = {
    enable = true;
    # Uncomment if `journalctl -u thermald` says the CPU model is unsupported
    # ignoreCpuidCheck = true;
  };

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  # systemd-resolved owns /etc/resolv.conf; NetworkManager and OpenVPN both
  # talk to it instead of fighting over the file.
  services.resolved.enable = true;

  # ---------------------------------------------------------------------------
  # Localization & Timezone
  # ---------------------------------------------------------------------------
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = lib.genAttrs [
    "LC_ADDRESS" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MONETARY"
    "LC_NAME" "LC_NUMERIC" "LC_PAPER" "LC_TELEPHONE" "LC_TIME"
  ] (_: "es_ES.UTF-8");

  # ---------------------------------------------------------------------------
  # X11, LightDM, i3
  # ---------------------------------------------------------------------------
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      options = "caps:escape";
    };
    displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
    };
    windowManager.i3.enable = true;
  };

  services.libinput.enable = true;
  console.useXkbConfig = true;
  services.printing.enable = true;

  # PAM service so i3lock can actually verify the password
  programs.i3lock.enable = true;

  # ---------------------------------------------------------------------------
  # Bluetooth
  # ---------------------------------------------------------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  services.blueman.enable = true;

  # ---------------------------------------------------------------------------
  # Audio (PipeWire)
  # ---------------------------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Users
  # ---------------------------------------------------------------------------
  users.users.viodid = {
    isNormalUser = true;
    description = "viodid";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
  };

  # ---------------------------------------------------------------------------
  # Docker
  # ---------------------------------------------------------------------------
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;   # socket-activated: starts on first `docker` call
    # Alternative that avoids the root-equivalent "docker" group:
    # rootless = { enable = true; setSocketVariable = true; };
  };

  # ---------------------------------------------------------------------------
  # NordVPN via OpenVPN
  # ---------------------------------------------------------------------------
  services.openvpn.servers =
    let
      nord = ovpn: autoStart: {
        config = ''
          config ${ovpn}
          auth-user-pass /etc/openvpn/nordvpn-creds.txt
        '';
        updateResolvConf = true;
        inherit autoStart;
      };
    in {
      nordvpn     = nord "/etc/openvpn/nordvpn-udp.ovpn" true;   # default (UDP, fast)
      nordvpn-tcp = nord "/etc/openvpn/nordvpn-tcp.ovpn" false;  # fallback for restricted networks
    };

  # ---------------------------------------------------------------------------
  # System-wide packages (dev toolchain + basic CLI)
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
    gcc
    gnumake
    unzip
    curl
    wget
    fd
  ];

  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";

  # ---------------------------------------------------------------------------
  # Home Manager
  # ---------------------------------------------------------------------------
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.viodid = import ./home.nix;
  };

  system.stateVersion = "26.05";
}
