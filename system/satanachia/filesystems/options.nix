{ pkgs, config, ... }:
{
	fileSystems."/".options = [ "noatime" "nodiratime" ];
	fileSystems."/tmp".options = [ "size=8G" "noatime" "nodiratime" ];

	#fileSystems."/@".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	#fileSystems."/home".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	#fileSystems."/nix".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	#fileSystems."/@/data".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];

	fileSystems."/@".neededForBoot = true;

	fileSystems."/nix/data" = {
		device = "/@/data";
		options = [ "bind" ];
	};

	# fonts
	system.fsPackages = [ pkgs.bindfs ];

	fileSystems."/usr/share/fonts" = {
	      device = (pkgs.buildEnv {
	            name = "system-fonts";
	            paths = config.fonts.packages;
	            pathsToLink = [ "/share/fonts" ];
	          }) + "/share/fonts";
	      fsType = "fuse.bindfs";
	      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
	  };
}
