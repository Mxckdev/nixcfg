{pkgs, ...}: {
  environment.systemPackages = with pkgs.gnomeExtensions; [
    hue-lights
    wtmb-window-thumbnails
    caffeine
    gsconnect
  ];
}
