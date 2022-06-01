# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let asusctl = pkgs.callPackage ./asusctl.nix {};

in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_5_17;
  # Not working :(
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-956162ae-5b61-4551-a762-1af3a449bcb0".device = "/dev/disk/by-uuid/956162ae-5b61-4551-a762-1af3a449bcb0";
  boot.initrd.luks.devices."luks-956162ae-5b61-4551-a762-1af3a449bcb0".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "lynx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.utf8";
    LC_IDENTIFICATION = "pt_PT.utf8";
    LC_MEASUREMENT = "pt_PT.utf8";
    LC_MONETARY = "pt_PT.utf8";
    LC_NAME = "pt_PT.utf8";
    LC_NUMERIC = "pt_PT.utf8";
    LC_PAPER = "pt_PT.utf8";
    LC_TELEPHONE = "pt_PT.utf8";
    LC_TIME = "pt_PT.utf8";
  };

  environment.pathsToLink = [ "./libexec" ];

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    
    displayManager.gdm = {
  	enable = true;
    };

    windowManager.i3 = {
    	enable = true;
	package = pkgs.i3-gaps;
       	extraPackages = with pkgs; [
	    dmenu #application launcher most people use
            i3status # gives you the default i3 status bar
            i3lock #default i3 screen locker
            i3blocks #if you are planning on using i3blocks over i3status
     	];
    };

    desktopManager.xterm.enable = true;

    desktopManager.gnome = {
    	enable = true;
    };

    layout = "us";
    xkbOptions = "caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.s3np41k1r1t0 = {
    isNormalUser = true;
    description = "s3np41k1r1t0";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    shell = pkgs.zsh;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.dconf.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim 
    vim
    wget
    git
    tmux
    cvs
    neofetch
    htop
    alacritty
    virt-manager
    bintools
    binutils
    usbutils
    unzip

    discord

    google-chrome
    google-chrome-dev
    firefox
    bitwarden

    gcc
    ccls
    cmake
    gnumake
    rustc
    rustup
    cargo
    python3Full
    pypy3

    flex
    bison
    yasm

    nodejs-16_x

    gnome3.gnome-tweaks
    gnomeExtensions.asusctl-gex
    lutris

    asusctl
  ];

  systemd.services.asusd = {
     enable = true;
     description = "ASUS Notebook Control";
     unitConfig = {
       StartLimitInterval = "200";
       StartLimitBurst = "2";
       Before = "multi-user.target";
     };
     environment = {
       IS_SERVICE = "1";
     };
     serviceConfig = {
        Type = "dbus";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = "${asusctl}/bin/asusd";
        Restart = "on-failure"; 
	# Restart = "always";
        RestartSec = "1";
        BusName = "org.asuslinux.Daemon";
        SELinuxContext = "system_u:system_r:unconfined_t:s0";
     };
     wantedBy = [ "multi-user.target" ];
  };

  systemd.user.services.asusd-user = {
     enable = true;
     description = "ASUS User Daemon";
     unitConfig = {
       startLimitInterval = "200";
       startLimitBurst = "2";
     };
     serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = "${asusctl}/bin/asusd";
        Restart = "on-failure";
        RestartSec = 1;
     };
     wantedBy = [ "default.target" ];
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
	enable = true;
	plugins = [ "git" "docker" ];
	theme = "robbyrussell";
    };
  };

  networking.firewall.allowedTCPPorts = [ 57621 ];

  system.stateVersion = "22.05"; # Did you read the comment?

}
