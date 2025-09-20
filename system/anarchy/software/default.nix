{ pkgs, lib, ... }: {
	imports = [
		#./desktop/enlightenment
		#./desktop/greetd.nix
		#./desktop/gnome
		#./desktop/hyprland.nix
		./desktop/plasma6
		#./desktop/cde
		#./desktop/enlightenment.nix
		#./desktop/cinnamon.nix
		#./desktop/greetd.nix
		#./desktop/xfce
		./desktop/greetd.nix
	];

	hardware.logitech.wireless.enable = true;

	#services.tlp.enable = true;
	services.acpid.enable = true;
	#services.tailscale.enable = true;
	#services.asusd.enable = true;
	services.printing.enable = false;
	services.fwupd.enable = true;
	services.xserver.wacom.enable = true;

	services.tailscale.enable = false;
	services.tailscale.openFirewall = true;

	services.gnome.gnome-keyring.enable = true;
	programs.seahorse.enable = true;

	services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

	programs.ssh = {
		startAgent = true;
		askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
	};

	services.openssh = {
		enable = false;
		settings.X11Forwarding = false;
	};

	#powerManagement.powertop.enable = true;

	programs.steam.enable = true;
	programs.steam.extraPackages = with pkgs; [
		libcef
	];
	
	programs.fish.enable = true;
	programs.dconf.enable = true;
	programs.adb.enable = true;
	programs.nix-ld.enable = true;
	#programs.kdeconnect.enable = true;
	#programs.direnv.enable = true;
	programs.virt-manager.enable = true;

	# programs.corectrl = {
	# 	enable = true;
	# 	gpuOverclock.enable = true;
	# };

	programs.git = {
		enable = true;
		lfs.enable = true;
	};

	programs.nix-index = {
		enable = true;

		enableFishIntegration = true;
		enableBashIntegration = false;
		enableZshIntegration = false;
	};

	environment.systemPackages = with pkgs; [
		amdctl
		
		home-manager
		cachix

		#solaar

		micro
		tmux

		xf86_input_wacom
		
		(python312.withPackages (pp: [
			pp.setuptools
		]))

		nvtopPackages.amd
		btop
		acpi

		rsync
		curl
		binutils
		file
		inetutils
		usbutils
		pciutils
		util-linux
		dmidecode
		hdparm
		smartmontools

		nvme-cli
		amdctl
		asusctl

		xfsprogs

		qemu

		wineWowPackages.staging
		winetricks
		protontricks

		vivaldi
		vivaldi-ffmpeg-codecs
		
		virtiofsd

		ffmpeg-full
		#docker-compose

		wl-clipboard
		#weston
	];

	environment.etc = {
		"X11/xorg.conf.d/90-intuos-pro-m.conf" = {
			text = ''
				Section "InputClass"
				    Identifier "Tablet"
				    Driver "wacom"
				    MatchDevicePath "/dev/input/event*"
				    MatchUSBID "056a:0315"
				EndSection
			'';

			mode = "0644";
		};
	};

	nixpkgs.overlays = [
		(final: prev: {
			steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
				extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
					openssl
					xorg.libSM
					openxr-loader
					libcap
				]) ++ ([(pkgs.runCommand "share-fonts" { preferLocalBuild = true; } ''
					mkdir -p "$out/share/fonts"
					font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
					find ${toString (import ./fonts.nix { inherit pkgs; })} -regex "$font_regexp" \
						-exec ln -sf -t "$out/share/fonts" '{}' \;
				'')]);
			});
		})
	];

	# virtualisation.sharedDirectories = {
	# 	default-share = {
	# 		source = "/@/data/virtual machines/shared";
	# 		target = "vm_shared";
	# 	};
	# };

	virtualisation = {
		waydroid.enable = false;
		lxd.enable = false;

		spiceUSBRedirection.enable = true;

		libvirtd = {
			enable = true;

			qemu.verbatimConfig = ''
				cgroup_device_acl = [
					"/dev/kvmfr0", "/dev/kvm",
					"/dev/null", "/dev/zero", "/dev/random", "/dev/urandom",
					"/dev/ptmx", "/dev/pts/ptmx", "/dev/pts/0"
				]
			'';
		};
		
		docker = {
			enable = true;
			storageDriver = "btrfs";
			rootless = {
			  enable = true;
			  setSocketVariable = true;
			};
			daemon.settings = {
			  data-root = "/@/data/docker";
			};
		};
	};

	environment.variables = {
		EDITOR = "micro";
		GTK_USE_PORTAL = "1";
		GDK_DEBUG = "portals";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
