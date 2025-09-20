{ pkgs, ... }: {
	
	services.acpid.enable = true;

	services.openssh = {
		enable = true;
	};

	programs.git = {
		enable = true;
		lfs.enable = true;
	};

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
		'';
		shellInit = ''
			set -Ux POETRY_VIRTUALENVS_IN_PROJECT 1

			function runbg
				$argv &> /dev/null &
			end

			function reboot_windows
				sudo efibootmgr -n 0000
				sudo systemctl reboot
			end

			function reboot_linux
				sudo efibootmgr -n 0003
				sudo systemctl reboot
			end
		'';
	};

	# programs.nix-index = {
	# 	enable = true;

	# 	enableFishIntegration = true;
	# 	enableBashIntegration = false;
	# 	enableZshIntegration = false;
	# };

	environment.systemPackages = with pkgs; [
		any-nix-shell
		amdctl

		micro
		tmux
		
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

		xfsprogs

		clinfo
		rocmPackages.rocminfo
		rocmPackages.amdsmi
		amdgpu_top
		lact

		efibootmgr
	];

	environment.variables = {
		EDITOR = "micro";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
