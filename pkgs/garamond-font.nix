{
	stdenvNoCC,
	lib,
	...
}:
stdenvNoCC.mkDerivation {
	pname = "garamond-font";
	version = "1.0";
	src = ../assets/fonts/EB_Garamond;

	installPhase = ''
		mkdir -p $out/share/fonts/truetype/
		cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
	'';

	meta = with lib; {
		description = "EB Garamond";
		homepage = "https://fonts.google.com/specimen/EB+Garamond";
		platforms = platforms.all;
	};
}
