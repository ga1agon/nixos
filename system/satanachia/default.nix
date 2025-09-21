{ inputs, lib, config, pkgs, ... }: {
	# You can import other NixOS modules here
	imports = [
		(inputs.impermanence + "/nixos.nix")

		../../cachix.nix

		./audio.nix

		# subfiles
		./filesystems
		./users
		./boot
		./software
		#./gpu/intel.nix
		./appimage.nix
		./services.nix
		./fonts.nix
		./stylix.nix

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

	documentation.man.enable = true;
	documentation.dev.enable = true;
	documentation.info.enable = false;
	documentation.doc.enable = false;
	documentation.nixos.enable = true;

	security.sudo.enable = false; # run0
	# security.sudo.extraConfig = ''
	# 	Defaults passwd_timeout=0
	# 	Defaults passprompt="* password for %p: "
	# 	Defaults timestamp_timeout=1
	# 	Defaults insults
	# 	Defaults lecture = never
	# 	#Defaults passwd_timeout=0,passprompt="^G* password for %p: ",timestamp_timeout=0,insults,lecture=never
	# '';

	fonts.fontDir.enable = true;
 
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
		networkmanager-openvpn
		networkmanager-l2tp
	];

	## time
	time.timeZone = "Europe/Warsaw";
	#time.hardwareClockInLocalTime = true;

	## console
	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.supportedLocales = [
		"en_GB.UTF-8/UTF-8"
		"pl_PL.UTF-8/UTF-8"
	];
	
	console = {
		keyMap = "pl";
		earlySetup = true;
		packages = with pkgs; [ terminus_font ];
		font = "${pkgs.terminus_font}/share/consolefonts/ter-u16n.psf.gz";
	};

	## bluetooth
	hardware.bluetooth.enable = true;
	hardware.bluetooth.settings = {
		General = {
			Enable = "Source,Sink,Media,Socket";
		};
	};

	## firewall
	networking.firewall.allowedTCPPorts = [ 3240 22 ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.enable = true;
	networking.firewall.checkReversePath = false;

	## https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "25.11";
}
