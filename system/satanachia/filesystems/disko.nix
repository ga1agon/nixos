{
	disko.devices = {
		disk = {
			main = {
				type = "disk";
				device = "/dev/vda";
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
						nixos = {
							size = "100%";
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
		};
	};
}
