{
	stdenvNoCC,
	lib,
	...
}:
stdenvNoCC.mkDerivation {
	pname = "oxanium-font";
	version = "1.0";
	src = ../assets/fonts/Oxanium;

	installPhase = ''
		mkdir -p $out/share/fonts/truetype/
		cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
	'';

	meta = with lib; {
		description = "Oxanium";
		homepage = "https://fonts.google.com/specimen/Oxanium";
		platforms = platforms.all;
	};
}
