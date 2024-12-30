{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.features.desktop.mpv;
in {
  options.features.desktop.mpv = {
    enable = mkEnableOption "Enable and configure Flatpak MPV player.";
  };

  config = mkIf cfg.enable {
    home.file.".var/app/io.mpv.Mpv/config/mpv/mpv.conf".text = ''
      # Mick's settings

      target-colorspace-hint=yes

      # Enable hardware acceleration
      hwdec=auto-copy
      hwdec-codecs=all

      # Disable pipewire and fallback to alsa (for Discord Wayland streaming)
      ao=pulse

      # Improve performance
      deband=no

      # Disable compositor bypass (for WTMB PiP)
      x11-bypass-compositor=no

      # Disable OSD bar
      osd-bar=no

      # Disable window border
      border=no

      # Smoother UI
      video-sync=display-resample
    '';

    home.file.".var/app/io.mpv.Mpv/config/mpv/input.conf".text = ''
      # Mick's bindings

      F2 af toggle "acompressor=ratio=4,loudnorm"
      F3 af toggle "format=channels=stereo,dynaudnorm"

      ctrl+r cycle_values video-rotate "90" "180" "270" "0"

      - add video-zoom -.25
      = add video-zoom .25

      kp8 add video-pan-y .05
      kp6 add video-pan-x -.05
      kp2 add video-pan-y -.05
      kp4 add video-pan-x .05

      kp5 set video-pan-x 0; set video-pan-y 0; set video-zoom 0
    '';
  };
}
