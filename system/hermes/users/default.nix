{ pkgs, ... }: {
	users.mutableUsers = false;

	users.users."Workspace0" = {
		uid = 1000;
		group = "users";
		isNormalUser = true;
		home = "/home/Workspace0";
		shell = pkgs.fish;
		hashedPasswordFile = "/@/Workspace0.pass";
		extraGroups = [ "wheel" "audio" "video" "dialout" "kvm" "render" ];
		subUidRanges = [
			{ startUid = 100000; count = 65536; }
		];
		subGidRanges = [
			{ startGid = 100000; count = 65536; }
		];
	};

	users.users."root".hashedPasswordFile = "/@/root.pass";
}
