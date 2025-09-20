{ pkgs, config, ... }:
let
amdgpu-kernel-module = pkgs.callPackage ./amdgpu.nix {
    # Make sure the module targets the same kernel as your system is using.
    kernel = config.boot.kernelPackages.kernel;
  };
 in
{
	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = [ "amdgpu" ];

	#hardware.opengl.driSupport = true;
	#hardware.opengl.driSupport32Bit = true;

	hardware.graphics.enable32Bit = true;

	hardware.graphics.extraPackages = with pkgs; [
		vaapiVdpau
		libvdpau-va-gl

		rocmPackages.clr.icd
		rocmPackages.clr

		#rocmPackages_5.clr.icd
		#clinfo

		# rocmPackages.rocm-runtime
		# rocmPackages.rocm-smi
		# rocmPackages.rocm-device-libs
		# rocmPackages.rocminfo
		# (rocmPackages.llvm.libcxx.override (prev: {
		# 	buildDocs = false;
		# 	buildMan = false;
		# 	buildTests = false;
		# 	doCheck = false;
		# 	#doInstallCheck = false;
		# }))

		#rocmPackages.clr
	];

	#boot.extraModulePackages = [
	 #   (amdgpu-kernel-module.overrideAttrs (_: {
	  #    patches = [ ./cap_sys_nice_begone.patch ];
	  #  }))
	  #];

	systemd.tmpfiles.rules = [
	"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
	];
}
