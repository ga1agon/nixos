{ pkgs, ... }:
let
	theme-custom = pkgs.callPackage ./plymouth-theme.nix {};
in
{
	boot.initrd.systemd.enable = true;
	boot.initrd.services.lvm.enable = true;

	boot.plymouth = {
		enable = true;
		theme = "Chicago95";
		themePackages = [ theme-custom ];
	};
}
