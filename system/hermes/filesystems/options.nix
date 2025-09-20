{ pkgs, config, ... }:
{
	fileSystems."/".options = [ "noatime" "nodiratime" ];
	fileSystems."/tmp".options = [ "size=10G" "noatime" "nodiratime" ];

	fileSystems."/@".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/home".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/nix".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];

	fileSystems."/@".neededForBoot = true;

	fileSystems."/@/archive" = {
		device = "/dev/disk/by-uuid/F09AE4EF9AE4B370";
		fsType = "ntfs3";
		options = [ "noatime" "nodiratime" "uid=1000" "gid=100" "force" ];
	};

	fileSystems."/@/data" = {
		device = "/dev/disk/by-uuid/8C1CD54E1CD533C4";
		fsType = "ntfs3";
		options = [ "noatime" "nodiratime" "uid=1000" "gid=100" "discard" "force" ];
	};
}
