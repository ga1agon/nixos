{ pkgs, ... }:
let
	oxanium = pkgs.callPackage ../../pkgs/oxanium-font.nix { inherit pkgs; };
	jura = pkgs.callPackage ../../pkgs/jura-font.nix { inherit pkgs; };
	garamond = pkgs.callPackage ../../pkgs/garamond-font.nix { inherit pkgs; };
in
{
	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-color-emoji

		oxanium
		jura
		garamond

		maple-mono.variable
		maple-mono.truetype
	];
}
