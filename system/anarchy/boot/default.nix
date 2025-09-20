{ pkgs, lib, ... }: {
	imports = [
		./plymouth.nix
	];

	boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
	boot.kernelParams = [
		"amd_pstate=guided"
		"amdgpu.gpu_recovery=1" "amdgpu.sg_display=1" "amdgpu.ppfeaturemask=0xfff7ffff" "amdgpu.abmlevel=0" "amdgpu.enable_psr=0" "amdgpu.dcdebugmask=0x10"
		"sysrq_always_enabled=1"
		"panic=10" "vsyscall=native"
		"quiet" "splash"
	];
	boot.initrd.kernelModules = [ "dm-snapshot" "dm-crypt" "v4l2loopback" "ryzen_smu" ];
	boot.consoleLogLevel = 9;
	boot.kernelModules = [ "usbip_host" ];

	boot.extraModulePackages = with pkgs.linuxKernel.packages.linux_xanmod_stable; [
		v4l2loopback
		ryzen-smu
	];

	environment.systemPackages = with pkgs.linuxKernel.packages.linux_xanmod_stable; [
		perf
		usbip
	] ++ [
		pkgs.perf-tools
	];

	#boot.initrd.preLVMCommands = ''
	#	for tty in /dev/tty{1..6}; do
	#		setleds -D +num < "$tty";
	#	done
	#'';
	#boot.initrd.preDeviceCommands = ''
	#	echo         ..---..
	#	echo       .:  .'::::.
	#	echo      :   ::::::::: 
	#	echo     |   ::::::::::|
	#	echo      :  ':::::::::
	#	echo       ':  `,::::'
	#	echo         ``===``
	#	sleep 1
	#'';

	boot.loader = {
		efi.canTouchEfiVariables = true;
		
		grub = {
			enable = true;
			efiSupport = true;
			device = "nodev";
			configurationLimit = 20;
			theme = pkgs.stdenv.mkDerivation {
				pname = "workbench-grub-theme";
				version = "1.0";
				src = builtins.path {
					path = ./theme;
					name = "workbench-grub-theme";
				};
				installPhase = "mkdir -p $out && cp * $out/";
			};
			splashImage = ./theme/background.png;
		};
	};

	#specialisation.mainline.configuration = {
	#	system.nixos.tags = [ "mainline" ];
	#	boot.kernelPackages = pkgs.linuxPackages_testing;
	#};

	# specialisation.igpu.configuration = {
	# 	system.nixos.tags = [ "igpu" ];
	# 	boot.kernelParams = [ "asus_wmi.gpu_mux_mode=1" "asus_wmi.dgpu_disable=1" ];
	# };
# 
# 	specialisation.dgpu.configuration = {
# 		system.nixos.tags = [ "dgpu" ];
# 		boot.kernelParams = [ "asus_wmi.gpu_mux_mode=0" "asus_wmi.dgpu_disable=0" ];
# 	};

 	specialisation.vm.configuration = {
 		system.nixos.tags = [ "vfio" ];
 		boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];

		boot.extraModprobeConfig = ''
			softdep amdgpu pre: vfio-pci
			softdep drm pre: vfio-pci
			# ethernet controller, gpu & gpu audio
			options vfio-pci ids=10ec:8168,1002:7480,1002:ab30
		'';
 		
 		#boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_4.kvmfr ];
 		#boot.extraModprobeConfig = ''
 		#	options kvmfr static_size_mb=32
 		#'';
 
 		#environment.systemPackages = with pkgs; [
 		#	looking-glass-client
 		#];
 
 		#services.udev.extraRules = ''
 		#	SUBSYSTEM=="kvmfr", OWNER="kiso", GROUP="kvm", MODE="0600"
 		#'';
 	};

	specialisation.rescue.configuration = {
		system.nixos.tags = [ "rescue" ];
		boot.kernelParams = [ "systemd.unit=rescue.target" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" "modprobe.blacklist=amdgpu" ];
	};

	specialisation.emergency.configuration = {
		system.nixos.tags = [ "emergency" ];
		boot.kernelParams = [ "systemd.unit=emergency.target" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" ];
	};

	# systemd.services.noGpuSleep = {
	# 	wantedBy = [ "multi-user.target" ];
	# 	description = "Disables the D3cold power state for the dGPU";
	# 	serviceConfig = {
	# 		Type = "oneshot";
	# 		User = "root";
	# 		RemainAfterExit = "yes";
	# 		WorkingDirectory = "/sys/bus/pci/devices/0000:03:00.0";
	# 		ExecStart = "${pkgs.bash}/bin/bash -c 'echo 0 > /sys/bus/pci/devices/0000:03:00.0/d3cold_allowed'";
	# 		ExecStop = "${pkgs.bash}/bin/bash -c 'echo 1 > /sys/bus/pci/devices/0000:03:00.0/d3cold_allowed'";
	# 	};
	# };

	systemd.services.chargingLimit = {
		wantedBy = [ "multi-user.target" ];
		description = "Lowers the battery charging limit to increase lifespan";
		serviceConfig = {
			Type = "oneshot";
			User = "root";
			RemainAfterExit = "yes";
			WorkingDirectory = "/sys/class/power_supply/BAT0";
			ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
			ExecStart = "${pkgs.bash}/bin/bash -c 'echo 75 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
			ExecStop = "${pkgs.bash}/bin/bash -c 'echo 100 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
		};
	};
}
