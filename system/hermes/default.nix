{ inputs, lib, config, pkgs, ... }: {
	# You can import other NixOS modules here
	imports = [
		(inputs.impermanence + "/nixos.nix")

		# subfiles
		./filesystems
		./users
		./boot
		./software
		./gpu/amd.nix
		./samba.nix

		# custom systemd services
		# ./services/00-amdctl-undervolt.nix

		# hardware config
		./hardware.nix
	];

	nixpkgs = {
		# You can add overlays here
		overlays = [
			# If you want to use overlays exported from other flakes:
			# neovim-nightly-overlay.overlays.default

			# Or define it inline, for example:
			# (final: prev: {
			#   hi = final.hello.overrideAttrs (oldAttrs: {
			#     patches = [ ./change-hello-to-hi.patch ];
			#   });
			# })
		];
		# Configure your nixpkgs instance
		config = {
			# Disable if you don't want unfree packages
			allowUnfree = true;
		};
	};

	nix = {
		# This will add each flake input as a registry
		# To make nix3 commands consistent with your flake
		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

		# This will additionally add your inputs to the system's legacy channels
		# Making legacy nix commands consistent as well, awesome!
		nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 14d";
		};

		settings = {
			# Enable flakes and new 'nix' command
			experimental-features = "nix-command flakes";
			# Deduplicate and optimize nix store
			auto-optimise-store = true;
		};

		optimise.automatic = true;
	};

	documentation.man.enable = false;
	documentation.dev.enable = false;
	documentation.info.enable = false;
	documentation.doc.enable = false;
	documentation.nixos.enable = false;

	security.sudo.enable = true;
	#security.sudo-rs.enable = true;
 
	powerManagement = {
		enable = true;
		cpuFreqGovernor = lib.mkForce "schedutil";
	};

	zramSwap = {
		enable = true;
		memoryPercent = 100;
	};

	## enable periodic fstrim
	services.fstrim.enable = true;

	## networking
	networking.networkmanager.enable = true;
	networking.networkmanager.plugins = with pkgs; [
		networkmanager_strongswan
		networkmanager-openvpn
		networkmanager-l2tp
	];

	## time
	time.timeZone = "Europe/Warsaw";
	time.hardwareClockInLocalTime = true;

	## console
	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.supportedLocales = [
		"en_GB.UTF-8/UTF-8"
		"en_US.UTF-8/UTF-8"
	];
	
	console = {
		#font = "Lat2-Terminus16";
		keyMap = "pl";
		earlySetup = true;
		packages = with pkgs; [ terminus_font ];
		font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
	};

	## firewall
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.enable = false; # TODO allow LAN access for all ports?
	networking.firewall.checkReversePath = false;
	networking.firewall.allowPing = true;

	## https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "25.05";
}
