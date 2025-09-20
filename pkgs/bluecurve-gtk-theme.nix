{
	stdenv,
	lib,
	fetchFromGitHub,
	gnumake,
	cmake,
	gcc,
	gtk2,
	pkg-config,
}:
stdenv.mkDerivation rec {
	pname = "bluecurve-gtk-theme";
	version = "ce2ba9c";

	src = fetchFromGitHub {
		owner = "neeeeow";
		repo = "Bluecurve";
		rev = "ce2ba9ce3d084f265443df28c3781aff1f57463a";
		hash = "sha256-juK+kGi6TVKESrB7oKY5RFs2hP97cyIbafHTzFswozk=";
	};

	nativeBuildInputs = [
		gnumake
		cmake
		gcc
	];

	buildInputs = [
		pkg-config
		gtk2
	];

	dontUseCmakeConfigure = true;

	configurePhase = ''
		runHook preConfigure

		cp -r $src .
		cd engine/src
		cmake .
		
		runHook postConfigure
	'';

	buildPhase = ''
		runHook preBuild

		cp -r $src .
		cd engine/src
		make
		
		runHook postBuild
	'';

	installPhase = ''
		runHook preInstall

		mkdir -p $out/share/themes/
		mkdir -p $out/lib/gtk-2.0/2.10.0/engines
		mkdir -p $out/share/icons

		cp $src/engine/src/libbluecurve.so $out/lib/gtk-2.0/2.10.0/engines/
		cp -r $src/icons/* $out/share/icons/
		cp -r $src/themes/* $out/share/themes/
		
		runHook postInstall
	'';

	meta = with lib; {
		description = "Red Hat Bluecurve theme for GTK 2/3/4";
		homepage = "https://github.com/neeeeow/Bluecurve";
		license = licenses.gpl3Plus;
		platforms = platforms.linux;
	};
}
