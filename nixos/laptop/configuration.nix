# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ./gnome.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Bootloader.
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;

   boot.initrd.luks.devices."luks-e341af4a-caf2-4391-9b02-46639ea35297".device = "/dev/disk/by-uuid/e341af4a-caf2-4391-9b02-46639ea35297";
   networking.hostName = "laptop"; # Define your hostname.
   # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

   # Configure network proxy if necessary
   # networking.proxy.default = "http://user:password@proxy:port/";
   # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

   # Enable networking
   networking.networkmanager.enable = true;

   # Set your time zone.
   time.timeZone = "Europe/Dublin";

   # Select internationalisation properties.
   i18n.defaultLocale = "en_GB.UTF-8";

   i18n.extraLocaleSettings = {
     LC_ADDRESS = "en_IE.UTF-8";
     LC_IDENTIFICATION = "en_IE.UTF-8";
     LC_MEASUREMENT = "en_IE.UTF-8";
     LC_MONETARY = "en_IE.UTF-8";
     LC_NAME = "en_IE.UTF-8";
     LC_NUMERIC = "en_IE.UTF-8";
     LC_PAPER = "en_IE.UTF-8";
     LC_TELEPHONE = "en_IE.UTF-8";
     LC_TIME = "en_IE.UTF-8";
   };

   nix.settings.experimental-features = [ "nix-command" "flakes" ];

   # Enable automatic login for the user.
   services.displayManager.autoLogin.enable = true;
   services.displayManager.autoLogin.user = "mick";

   # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
   systemd.services."getty@tty1".enable = false;
   systemd.services."autovt@tty1".enable = false;

   # Enable the X11 windowing system.
   services.xserver.enable = true;

   # Enable the GNOME Desktop Environment.
   services.xserver.displayManager.gdm.enable = true;
   services.xserver.desktopManager.gnome.enable = true;

   # Configure keymap in X11
   services.xserver.xkb = {
     layout = "ie";
     variant = "";
   };

   # Configure console keymap
   console.keyMap = "ie";

   # Enable CUPS to print documents.
   services.printing.enable = true;


   services.flatpak.enable = true;

   # Enable sound with pipewire.
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

	environment.sessionVariables = rec {
     XDG_CACHE_HOME  = "$HOME/.cache";
     XDG_CONFIG_HOME = "$HOME/.config";
     XDG_DATA_HOME   = "$HOME/.local/share";
     XDG_STATE_HOME  = "$HOME/.local/state";
     # Not officially in the specification
     XDG_BIN_HOME    = "$HOME/.local/bin";
     PATH = [
       "${XDG_BIN_HOME}"
     ];
   };

   # Enable touchpad support (enabled default in most desktopManager).
   # services.xserver.libinput.enable = true;



   # Install firefox.
   programs.firefox.enable = false;
   programs.fish.enable = true;

   # Allow unfree packages
   nixpkgs.config.allowUnfree = true;

   # List packages installed in system profile. To search, run:
   # $ nix search wget
   environment.systemPackages = with pkgs; [
     neovim
     git
     #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     #  wget
   ];

   environment.gnome.excludePackages = with pkgs; [
       orca
       evince
       # file-roller
       geary
       gnome-disk-utility
       # seahorse
       # sushi
       # sysprof
       #
       # gnome-shell-extensions
       #
       # adwaita-icon-theme
       # nixos-background-info
       gnome-backgrounds
       # gnome-bluetooth
       # gnome-color-manager
       # gnome-control-center
       # gnome-shell-extensions
       gnome-tour # GNOME Shell detects the .desktop file on first log-in.
       gnome-user-docs
       # glib # for gsettings program
       # gnome-menus
       # gtk3.out # for gtk-launch program
       # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
       # xdg-user-dirs-gtk # Used to create the default bookmarks
       #
       baobab
       epiphany
       gnome-text-editor
       gnome-calculator
       gnome-calendar
       gnome-characters
       # gnome-clocks
       gnome-console
       gnome-contacts
       gnome-font-viewer
       gnome-logs
       gnome-maps
       gnome-music
       # gnome-system-monitor
       gnome-weather
       # loupe
       # nautilus
       gnome-connections
       simple-scan
       snapshot
       totem
       yelp
       gnome-software
     ];

     users.defaultUserShell = pkgs.fish;


   	 nixpkgs.overlays = [
     # GNOME 47: triple-buffering-v4-47
     (final: prev: {
           gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
             mutter = gnomePrev.mutter.overrideAttrs (old: {
               src = pkgs.fetchFromGitLab  {
                 domain = "gitlab.gnome.org";
                 owner = "vanvugt";
                 repo = "mutter";
                 rev = "triple-buffering-v4-47";
                 hash = "sha256-145ec3b2c62cba22bc8f5c7a2e8e2fef48f4da8f";
               };
           });
       });
     })
   ];

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    mick = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialHashedPassword = "$y$j9T$/lmwfUAGCNBySU5J1MWwD/$VUpKDO85yn3Wu/9tB6tJd12ps1D/HL/j9/RBgdJ1tL0";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "flatpak"
        "audio"
        "video"
        "plugdev"
        "input"
        "kvm"
        "qemu-libvirtd"
      ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
