{ pkgs, ... }: {
	
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet -i --asterisks --time --cmd Hyprland";
				user = "greeter";
			};
		};
	};

	environment.systemPackages = with pkgs; [
		tuigreet
	];
}
