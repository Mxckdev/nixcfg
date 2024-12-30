{
  pkgs,
  inputs,
  ...
}: {
  home.file.".var/app/io.mpv.Mpv/config/mpv" = {
    source = "${inputs.dotfiles}/mpv";
    recursive = true;
  };
  home.file.".var/app/com.github.wwmm.easyeffects/config/easyeffects" = {
    source = "${inputs.dotfiles}/easyeffects";
    recursive = true;
  };
}
