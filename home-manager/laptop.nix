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
    ./dotfiles

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
    zed-editor
  ];

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

  programs.fish.enable = true;
  programs.foot.enableFishIntegration = true;
  programs.foot.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
