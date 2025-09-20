{ pkgs, config, ... }:
{
	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = [ "amdgpu" ];

	hardware.graphics.enable32Bit = true;

	hardware.graphics.extraPackages = with pkgs; [
		vaapiVdpau
		libvdpau-va-gl

		rocmPackages.clr.icd

		rocmPackages.rocm-runtime
		rocmPackages.rocm-smi
		rocmPackages.rocm-device-libs

		rocmPackages.clr
	];

	systemd.tmpfiles.rules = 
	let
		rocmEnv = pkgs.symlinkJoin {
			name = "rocm-combined";
			paths = with pkgs.rocmPackages; [
				rocblas
				hipblas
				clr
			];
		};
	in [
		"L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
	];
}
