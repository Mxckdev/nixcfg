{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.flatpak;
in {
  options.features.desktop.flatpak.enable =
    mkEnableOption "enable user flatpaks";

  config = mkIf cfg.enable {
services.flatpak.remotes = lib.mkOptionDefault [{
    name = "flathub-beta";
    location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
   }];



  services.flatpak.uninstallUnmanaged = false;
  services.flatpak.update.onActivation = true;
  services.flatpak.packages = [


        # Discord canary for wayland support
		    { appId = "com.discordapp.DiscordCanary"; origin = "flathub-beta";  }

        # Default browser
        "org.mozilla.firefox"

        # Microphone noise cancellation
        "com.github.wwmm.easyeffects"


        # Media
        "com.obsproject.Studio"
		    "io.mpv.Mpv"

        # Internet/Network
        "org.qbittorrent.qBittorrent"
        "com.anydesk.Anydesk"

        # Flatpak tools
        "com.github.tchx84.Flatseal"
        "io.github.flattool.Warehouse"


        # Themes
        "org.gtk.Gtk3theme.adw-gtk3"
        "org.gtk.Gtk3theme.adw-gtk3-dark"

        "org.kde.ark"


  ];
	services.flatpak.update.auto = {
  	enable = true;
  	onCalendar = "weekly"; # Default value
};

    services.flatpak.overrides = {
    global = {
      # Force Wayland by default
      Context.sockets = ["wayland" "!x11" "fallback-x11"];
      Context.device = ["dri"];

      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

        # Force correct theme for some GTK apps
        GTK_THEME = "Adwaita:dark";
      };
    };

    "com.discordapp.DiscordCanary".Context = {
      filesystems = "home";
      sockets = ["wayland" "x11" "!fallback-x11"];
    };
  };
};
}
