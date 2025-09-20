{ pkgs, lib, ... }: {
	boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
	boot.kernelParams = [
		"amd_pstate=guided"
		"amdgpu.ppfeaturemask=0xffffffff"
		"sysrq_always_enabled=1"
		"panic=10" "vsyscall=native" ];
	boot.initrd.kernelModules = [ "dm-snapshot" "dm-crypt" ];
	boot.consoleLogLevel = 9;

	boot.loader = {
		efi.canTouchEfiVariables = true;
		systemd-boot.enable = true;
	};
}
