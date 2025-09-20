{ pkgs, lib, ... }:
{
	boot.kernelPackages = pkgs.linuxKernel.kernels.linux_lqx;
	boot.kernelParams = [
		"scheduler=pds" "mitigations=off"
		#"i915.enable_guc=3 i915.enable_fbc=1 i915.enable_psr=1 i915.enable_dc=2"
		#"intel_pstate=passive"
		"sysrq_always_enabled=1"
		"panic=10" "vsyscall=native"
	];
	boot.initrd.kernelModules = [ ];
	boot.consoleLogLevel = 9;
	boot.kernelModules = [ "usbip_host" ];

	environment.systemPackages = with pkgs.linuxKernel.packages.linux_lqx; [
		perf
		usbip
	] ++ [
		pkgs.perf-tools
	];

	boot.loader = {
		efi.canTouchEfiVariables = true;
		
		systemd-boot = {
			enable = true;
			netbootxyz.enable = true;
			consoleMode = "0";
			configurationLimit = 10;
		};
	};

	boot.sysfs = {
		devices.system.cpu."cpu[0-9]*".power.energy_perf_bias = "8";
	};

	specialisation.rescue.configuration = {
		system.nixos.tags = [ "rescue" ];
		boot.kernelParams = [ "systemd.unit=rescue.target" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" "modprobe.blacklist=i915" ];
	};

	specialisation.emergency.configuration = {
		system.nixos.tags = [ "emergency" ];
		boot.kernelParams = [ "systemd.unit=emergency.target" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" "modprobe.blacklist=amdgpu" ];
	};
}
