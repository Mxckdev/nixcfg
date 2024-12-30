{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.gnome;
in {
  options.features.desktop.gnome.enable =
    mkEnableOption "gnome extensions";

  config = mkIf cfg.enable {

      home.packages = with pkgs.gnomeExtensions; [
        hue-lights
        wtmb-window-thumbnails
        caffeine
        gsconnect
      ];

      dconf = {
        enable = true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false; # enables user extensions
            enabled-extensions = [
              "hue-lights@chlumskyvaclav.gmail.com"
              "caffeine@patapon.info"
              "window-thumbnails@G-dH.github.com"
              "gsconnect@andyholmes.github.io"

              # Put UUIDs of extensions that you want to enable here.
              # If the extension you want to enable is packaged in nixpkgs,
              # you can easily get its UUID by accessing its extensionUuid
              # field (look at the following example)

              # Alternatively, you can manually pass UUID as a string.
              #
              # ...
            ];
            disabled-extensions = [
                      "dash-to-dock@micxgx.gmail.com"
                      "window-list@gnome-shell-extensions.gcampax.github.com"
                      "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
                      "light-style@gnome-shell-extensions.gcampax.github.com"
                      "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
                      "apps-menu@gnome-shell-extensions.gcampax.github.com"
                      "emoji-copy@felipeftn"
                      "native-window-placement@gnome-shell-extensions.gcampax.github.com"
                      "status-icons@gnome-shell-extensions.gcampax.github.com"
            ];
          };

          # Configure individual extensions
          #"org/gnome/shell/extensions/blur-my-shell" = {
          #  brightness = 0.75;
           # noise-amount = 0;
           # };
        };
      };
    };
}
