{ pkgs, ... }: {
	users.users.cmdr = {
		uid = 1000;
		group = "users";
		isNormalUser = true;
		home = "/home/cmdr";
		shell = pkgs.fish;
		hashedPasswordFile = "/@/default.pass";
		extraGroups = [ "wheel" "audio" "video" "dialout" "kvm" "render" "adbusers" "libvirt" "docker" ];
		subUidRanges = [
			{ startUid = 100000; count = 65536; }
		];
		subGidRanges = [
			{ startGid = 100000; count = 65536; }
		];
	};

	systemd.user.services.docker.enable = true;
}
