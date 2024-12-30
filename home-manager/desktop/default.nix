{pkgs, ...}: {
  imports = [
    ./compositors/hyprland.nix
    ./compositors/wayland.nix
    ./gnome.nix
    ./fonts.nix
    ./mpv.nix
  ];

  home.packages = with pkgs; [
  ];
}
