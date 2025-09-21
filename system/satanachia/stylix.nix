{ pkgs, ... }:
let
	oxanium = pkgs.callPackage ../../pkgs/oxanium-font.nix { inherit pkgs; };
	jura = pkgs.callPackage ../../pkgs/jura-font.nix { inherit pkgs; };
	garamond = pkgs.callPackage ../../pkgs/garamond-font.nix { inherit pkgs; };
in
{
	stylix = {
		enable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-estuary.yaml";

		fonts = {
			sansSerif = {
				package = jura;
				name = "Jura";
			};

			serif = {
				package = garamond;
				name = "EB Garamond";
			};

			monospace = {
				package = pkgs.maple-mono.truetype;
				name = "Maple Mono";
			};

			emoji = {
				package = pkgs.noto-fonts-color-emoji;
				name = "Noto Emoji Color";
			};
		};
	};
}
