{ pkgs, lib, ... }:
{
	systemd.services.usbipd = {
		enable = true;
		after = [ "network.target" ];
		wantedBy = [ "multi-user.target" ];
		description = "USB-over-IP daemon";
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.linuxKernel.packages.linux_xanmod_stable.usbip}/sbin/usbipd";
			Restart = "on-failure";
		};
	};
}
