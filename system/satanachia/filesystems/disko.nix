{
	disko.devices = {
		disk = {
			main = {
				type = "disk";
				device = "/dev/nvme0n1";

				content = {
					type = "gpt";

					partitions = {
						boot = {
							priority = 1;
							name = "boot";
							size = "1G";
							type = "EF00";

							content = {
								type = "filesystem";
								format = "vfat";
								mountpoint = "/boot";
								mountOptions = [ "noatime" "umask=0777" "iocharset=utf8" ];
							};
						};

						lvm = {
							size = "100%";

							content = {
								type = "lvm_pv";
								vg = "primary";
							};
						};
					};
				};
			};
		};

		lvm_vg = {
			primary = {
				type = "lvm_vg";

				lvs = {
					system = {
						size = "100%FREE";

						content = {
							type = "btrfs";
							extraArgs = [ "-f" "-d single" "-m dup" ];

							subvolumes = {
								"/@" = {
									mountpoint = "/@";
									mountOptions = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};

								"/data" = {
									mountpoint = "/@/data";
									mountOptions = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};

								"/home" = {
									mountpoint = "/home";
									mountOptions = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};

								"/nix" = {
									mountpoint = "/nix";
									mountOptions = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};
							};
						};
					};
				};
			};
		};

		nodev = {
			"/tmp" = {
				fsType = "tmpfs";
				mountOptions = [ "noatime" "nodiratime" "size=8G" ];
			};

			"/" = {
				fsType = "tmpfs";
				mountOptions = [ "noatime" "nodiratime" ];
			};
		};
	};
}
