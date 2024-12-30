# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./cli
    ./desktop
    ./flatpak
  # ./dotfiles

  ];

  features = {
    cli = {
      fish.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
    };

    desktop = {
      fonts.enable = true;
      gnome.enable = true;
      flatpak.enable = true;
      hyprland.enable = true;
      wayland.enable = true;
      mpv.enable = true;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "mick";
    homeDirectory = "/home/mick";
  };

  nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };


  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    nixd
    nil
    kitty
    zed-editor
    nwg-drawer
    brightnessctl
    cmake
    ffmpeg-full
    wmctrl
  ];

  wayland.windowManager.hyprland = {
    settings = {
      device = [
        {
          name = "keyboard";
          kb_layout = "ie";
        }
        {
          name = "mouse";
          sensitivity = -0.5;
        }
      ];
      monitor = [
        "DP-1,1366x768@60,0x0,1"
      ];
      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-1"
        "7, monitor:DP-1"
      ];
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "mxckdev";
    userEmail = "186430819+Mxckdev@users.noreply.github.com";
    aliases = {st = "status";};
    extraConfig = {
      core.excludesfile = "~/.gitignore_global";
      init.defaultBranch = "main";
    };
  };

  services.flatpak.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  wayland.windowManager.hyprland.systemd.variables = ["--all"];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
