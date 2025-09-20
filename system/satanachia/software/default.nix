{ pkgs, lib, ... }: {
	imports = [
		./desktop/hyprland.nix
	];

	hardware.logitech.wireless.enable = true;

	#services.thermald.enable = true;
	#services.tlp.enable = true;

	# TODO
	services.undervolt = {
		enable = false;
	};

	services.acpid.enable = true;
	services.printing.enable = false;
	services.fwupd.enable = true;

	#services.gnome.gnome-keyring.enable = true;
	#programs.seahorse.enable = true;

	#services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

	#programs.ssh = {
	#	startAgent = true;
	#	askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
	#};

	services.openssh = {
		enable = true;

		settings = {
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
		};
	};

	programs.steam.enable = true;
	programs.steam.extraPackages = with pkgs; [
		libcef
	];
	
	programs.fish.enable = true;
	programs.dconf.enable = true;
	programs.adb.enable = true;
	programs.nix-ld.enable = true;
	programs.virt-manager.enable = true;

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

		nvtopPackages.intel
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
		inteltool

		xfsprogs

		wineWowPackages.staging
		winetricks
		protontricks

		vivaldi
		vivaldi-ffmpeg-codecs

		ffmpeg-full
		wl-clipboard

		podman-tui
		podman-compose
	];

	nixpkgs.overlays = [
		(final: prev: {
			steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
				extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
					openssl
					xorg.libSM
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

	virtualisation = {
		waydroid.enable = false;

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

		containers.enable = true;
		
		podman = {
			enable = true;
			dockerCompat = true;
			defaultNetwork.settings.dns_enabled = true;
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
