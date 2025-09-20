{
	stdenvNoCC,
	lib,
}:
stdenvNoCC.mkDerivation {
	pname = "jura-font";
	version = "1.0";
	src = ../assets/fonts/Jura;

	installPhase = ''
		mkdir -p $out/share/fonts/truetype/
		cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
	'';

	meta = with lib; {
		description = "Jura";
		homepage = "https://fonts.google.com/specimen/Jura";
		platforms = platforms.all;
	};
}
