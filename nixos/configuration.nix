# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # asusctl = pkgs.callPackage ./asusctl.nix {};
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
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
  boot.kernelPackages = pkgs.linuxPackages_5_19;
  # boot.kernelParams = [ "mem_sleep_default=deep" ];
  # Not working :(
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  networking = {
    hostName = "lynx";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 57621 ];
    nameservers = [ "1.1.1.1" ];
    # networkmanager.dns = "none";
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
  };

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

  services.pcscd.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT="schedutil";
      CPU_SCALING_GOVERNOR_ON_AC="performance";

      STOP_CHARGE_THRESH_BAT0=60;

      CPU_BOOST_ON_AC=0;
      CPU_BOOST_ON_BAT=0;
    };
  };

  environment.pathsToLink = [ "./libexec" ];

  hardware.opengl.enable = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    amdgpuBusId = "PCI:4:0:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  console.useXkbConfig = true;
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      touchpad.naturalScrolling = false;
    };

    videoDrivers = [ "nvidia" "amdgpu" ];
    
    displayManager.gdm = {
  	enable = true;
    };

    windowManager.i3 = {
    	enable = true;
			package = pkgs.i3-gaps;
       	extraPackages = with pkgs; [
	    xclip
	    rofi
	    dunst
            i3status
            i3lock
	    xss-lock
            i3blocks
	    ffmpeg
	    xorg.xbacklight
	    brightnessctl
	    pavucontrol
	    pamixer
	    flameshot
     	];
    };

    desktopManager.gnome = {
    	enable = true;
    };

    layout = "us";
    xkbOptions = "caps:escape,altwin:swap_lalt_lwin";
  };

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
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.s3np41k1r1t0 = {
    isNormalUser = true;
    description = "s3np41k1r1t0";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "adbusers" ];
    shell = pkgs.zsh;
  };

  virtualisation.libvirtd.enable = true;

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  users.extraGroups.vboxusers.members = [ "s3np41k1r1t0" ];

  virtualisation.docker.enable = true;

  programs.dconf.enable = true;

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    bintools
    binutils
    cvs
    docker-compose
    fzf
    git
    htop
    neofetch
    neovim 
    tmux
    unzip
    usbutils
    vim
    virt-manager
    wget
    kitty
    gdb

    picom
    nitrogen
    scrot
    ghidra

    auto-cpufreq

    unstable.discord
    spotify

    # jdk
    # jdk8
    jdk11
    # jdk17
    maven

    google-chrome
    google-chrome-dev
    firefox
    bitwarden

    gcc
    cmake
    gnumake
    rustc
    rustup
    cargo
    python3Full
    pypy3
    jetbrains.idea-ultimate

    flex
    bison
    yasm

    vscode
    nodejs-16_x

    gnome3.gnome-tweaks
    steam-run

    z3

    ccid
    wireshark

    go

    nvidia-offload
  ];

  # make NetworkManager not kill itself
  systemd.services.NetworkManager-wait-online.enable = false;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
			enable = true;
			plugins = [ "git" "docker" ];
			theme = "robbyrussell";
    };
  };

  fonts.fonts = with pkgs; [ meslo-lg iosevka ];

  system.stateVersion = "22.05"; # Did you read the comment?

}
