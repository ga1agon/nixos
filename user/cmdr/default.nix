{ pkgs, ... }:
{
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
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCgo+2yFgSlrX2KV2jnG2yb2T5eAroA9TQ7/puKL6ql cmdr@anarchy"
		];
	};

	#systemd.user.services.docker.enable = true;
}
