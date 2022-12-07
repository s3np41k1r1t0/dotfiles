{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_6_0;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
  ];

  # Enable swap on luks
  boot.initrd.luks.devices."luks-956162ae-5b61-4551-a762-1af3a449bcb0".device = "/dev/disk/by-uuid/956162ae-5b61-4551-a762-1af3a449bcb0";
  boot.initrd.luks.devices."luks-956162ae-5b61-4551-a762-1af3a449bcb0".keyFile = "/crypto_keyfile.bin";

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
        brightnessctl
        dunst
        ffmpeg
        flameshot
        nitrogen
        pamixer
        pavucontrol
        picom
        rofi
        scrot
        xclip
        xorg.xbacklight
        xss-lock
        i3blocks
        i3lock
        i3status
        arandr
        autorandr
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
    # general utils
    neovim 
    alacritty
    bintools
    binutils
    ccid
    fzf
    git
    htop
    neofetch
    steam-run
    tmux
    unzip
    p7zip
    usbutils
    vim
    vscode
    wget
    brave

    # devops
    ansible
    docker-compose
    vagrant
    virt-manager
    terraform
    google-cloud-sdk
    minikube
    kubectl

    # reverse
    gdb
    ghidra
    genymotion

    # web
    firefox
    google-chrome
    google-chrome-dev

    # media
    spotify
    discord # unstable

    # java
    jdk17
    jetbrains.idea-ultimate
    maven

    # c/cpp
    cmake
    gcc
    gnumake

    # python
    pypy3
    python3Full
    z3

    # node
    nodejs-16_x

    # misc languages
    go

    # laptop
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

  system.stateVersion = "22.11"; # Did you read the comment?

}
