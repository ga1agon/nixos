{ pkgs, lib, ... }: {
	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;

	services.gnome = {
		core-os-services.enable = true;
		core-shell.enable = true;
		core-utilities.enable = true;
		core-developer-tools.enable = false;
		games.enable = false;

		gnome-online-miners.enable = lib.mkForce false;
		gnome-online-accounts.enable = lib.mkForce true;
		gnome-initial-setup.enable = lib.mkForce false;
		gnome-remote-desktop.enable = lib.mkForce true;
		rygel.enable = lib.mkForce true;
		sushi.enable = lib.mkForce false;
	};

	services.packagekit.enable = lib.mkForce false;
	services.power-profiles-daemon.enable = lib.mkForce true;

	programs.gnome-terminal.enable = lib.mkForce true;
	programs.geary.enable = lib.mkForce true;

	environment.gnome.excludePackages = with pkgs; [
		gnome-tour
		gnome-user-docs
		orca
		gnome-console
		gnome-photos
		loupe
		simple-scan
		yelp
		cheese
		epiphany
		gnome-contacts
		gnome-logs
		gnome-maps
		gnome-music
		nautilus
		totem
	];

	environment.systemPackages = with pkgs; [
		gnome.gnome-shell-extensions
		gnome.gnome-tweaks
		gnome.dconf-editor

		cinnamon.nemo-with-extensions
		cinnamon.nemo-fileroller

		gnome.adwaita-icon-theme
		
		gthumb # image viewer

		gjs
	];

	xdg.mime.defaultApplications = {
		"inode/directory" = "nemo.desktop";
		"application/x-gnome-saved-search" = "nemo.desktop";
	};

	xdg.portal.enable = true;
	xdg.portal.xdgOpenUsePortal = true;
}
