{ pkgs, ... }:
{
	services.xserver = {
		enable = true;
		displayManager.defaultSession = "xfce";
		
		# displayManager.lightdm = {
		# 	enable = true;
		# 	greeters.slick.enable = true;
		# };
		
		desktopManager = {
			xfce.enable = true;
			xterm.enable = false;
		};
	};

	services.displayManager.ly.enable = true;
	services.blueman.enable = true;

	environment.systemPackages = with pkgs.xfce; [
		xfce4-volumed-pulse
		xfce4-battery-plugin
		xfce4-clipman-plugin
		xfce4-pulseaudio-plugin
		xfce4-notes-plugin
		xfce4-power-manager

		gigolo
	] ++ (with pkgs; [
		#custom-pkgs.bluecurve-gtk-theme
		libadwaita
		zenity

		speedcrunch # calculator
	]);

	environment.xfce.excludePackages = with pkgs.xfce; [
		parole
		ristretto
	];

	programs.thunar = {
		enable = true;
		plugins = with pkgs.xfce; [
			thunar-archive-plugin
			thunar-media-tags-plugin
			thunar-volman
		];
	};

	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;

		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		configPackages = [ pkgs.xfce.xfce4-session ];
	};
}
