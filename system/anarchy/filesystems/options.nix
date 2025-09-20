{ pkgs, config, ... }:
{
	fileSystems."/".options = [ "noatime" "nodiratime" ];
	fileSystems."/tmp".options = [ "size=10G" "noatime" "nodiratime" ];

	fileSystems."/@".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/home".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/nix".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];

	fileSystems."/@".neededForBoot = true;

	fileSystems."/@/data_linux" = {
		device = "/dev/vg_system/nixos";
		fsType = "btrfs";
		options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" "subvol=data" ];
	};

	fileSystems."/@/rdata_shared" = {
		device = "/dev/disk/by-uuid/8C1CD54E1CD533C4";
		fsType = "ntfs3";
		#options = [ "discard" "noatime" "nodiratime" "nofail" ];
		options = [ "nofail" "rw" "noatime" "nodiratime" "exec" "discard" "acl" ];
	};

	fileSystems."/@/HERMES/data" = {
		device = "//HERMES/data";
		fsType = "cifs";
		options = [ "nofail" "mfsymlinks" "noauto" "username=Workspace0" "password=workspace0" "uid=1000" "gid=100" "acl" ];
	};

	fileSystems."/@/HERMES/archive" = {
		device = "//HERMES/archive";
		fsType = "cifs";
		options = [ "nofail" "noauto" "username=Workspace0" "password=workspace0" "uid=1000" "gid=100" "acl" ];
	};

	fileSystems."/@/HERMES/c" = {
		device = "//HERMES/c";
		fsType = "cifs";
		options = [ "nofail" "noauto" "username=Administrator" "password=admin" "uid=1000" "gid=100" "acl" ];
	};

	# fileSystems."/@/data_shared/games" = {
	# 	device = "/dev/disk/by-uuid/1913bb03-c7ae-4edf-8546-d7b8adb096e2";
	# 	fsType = "btrfs";
	# 	options = [ "nofail" "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" "subvol=games" ];
	# };

	fileSystems."/@/data" = {
		device = "/@/data_linux";
		options = [ "bind" ];
	};

	fileSystems."/nix/data" = {
		device = "/@/data_linux";
		options = [ "bind" ];
	};

	# network mounts
	# systemd.mounts = [
	# 	{
	# 		requires = [ "network-online.target" ];
	# 		after = [ "network-online.target" ];
	# 		type = "cifs";
	# 		mountConfig = {
	# 			options = "noatime,nodiratime,noauto,nofail,x-systemd.automount,uid=1000,gid=100,acl,username=Workspace0,password=workspace0,mfsymlinks";
	# 		};
	# 		what = "//192.168.0.1/data";
	# 		where = "/@/HERMES/data";
	# 	}
	# 	{
	# 		requires = [ "network-online.target" ];
	# 		after = [ "network-online.target" ];
	# 		type = "cifs";
	# 		mountConfig = {
	# 			options = "noatime,nodiratime,noauto,nofail,x-systemd.automount,uid=1000,gid=100,acl,username=Workspace0,password=workspace0,mfsymlinks";
	# 		};
	# 		what = "//192.168.0.1/archive";
	# 		where = "/@/HERMES/archive";
	# 	}
	# 	{
	# 		requires = [ "network-online.target" ];
	# 		after = [ "network-online.target" ];
	# 		type = "cifs";
	# 		mountConfig = {
	# 			options = "noatime,nodiratime,noauto,nofail,x-systemd.automount,uid=1000,gid=100,acl,username=Workspace0,password=workspace0";
	# 		};
	# 		what = "//192.168.0.1/c";
	# 		where = "/@/HERMES/c";
	# 	}
	# ];
	# 
	# systemd.automounts = [
	# 	{
	# 		wantedBy = [ "multi-user.target" ];
	# 		automountConfig = {
	# 			TimeoutIdleSec = "2";
	# 		};
	# 		where = "/@/HERMES/data";
	# 	}
	# 	{
	# 		wantedBy = [ "multi-user.target" ];
	# 		automountConfig = {
	# 			TimeoutIdleSec = "2";
	# 		};
	# 		where = "/@/HERMES/archive";
	# 	}
	# 	{
	# 		wantedBy = [ "multi-user.target" ];
	# 		automountConfig = {
	# 			TimeoutIdleSec = "2";
	# 		};
	# 		where = "/@/HERMES/c";
	# 	}
	# ];

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
