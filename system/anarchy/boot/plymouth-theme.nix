{
	stdenv,
}:
stdenv.mkDerivation {
	name = "plymouth-theme-Chicago95";
	version = "1.0.0";
	src = ./Chicago95;
	dontBuild = true;
	installPhase = ''
		mkdir -p $out/share/plymouth/themes/Chicago95
		cp * $out/share/plymouth/themes/Chicago95
		find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
	'';
}
