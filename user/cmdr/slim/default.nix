{ inputs, lib, config, pkgs, ... }:
let
	community-vscode-extensions = inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace;
in
{
	# You can import other home-manager modules here
	imports = [
		# If you want to use home-manager modules from other flakes (such as nix-colors):
		# inputs.nix-colors.homeManagerModule
		#./gnome.nix
		#./cde
		#./hyprland
		#./stylix.nix
		#./e16
		#./gnome
	];

	nixpkgs = {
		# You can add overlays here
		overlays = [
			# If you want to use overlays exported from other flakes:
			# neovim-nightly-overlay.overlays.default

			# Or define it inline, for example:
			# (final: prev: {
			#   hi = final.hello.overrideAttrs (oldAttrs: {
			#     patches = [ ./change-hello-to-hi.patch ];
			#   });
			# })
		];
		# Configure your nixpkgs instance
		config = {
			# Disable if you don't want unfree packages
			allowUnfree = true;
			# Workaround for https://github.com/nix-community/home-manager/issues/2942
			allowUnfreePredicate = (_: true);
			# github-desktop needs openssl-1.1.1 :(
			permittedInsecurePackages = [
				"openssl-1.1.1u"
				"electron-25.9.0"
			];
			packageOverrides = super: {
				mplayer = super.mplayer.override {
					v4lSupport = true;
				};
			};
		};
	};

	home = {
		username = "master";
		homeDirectory = "/home/default";
	};

	services.easyeffects.enable = true;

	programs.home-manager.enable = true;
	
	home.packages = with pkgs; [
		any-nix-shell
		multipath-tools
		openssl

		aria2

		github-desktop

		vesktop
		vlc

		obsidian
		xournalpp
		
		moonlight-qt

		gst_all_1.gstreamer
		gst_all_1.gst-plugins-rs
		gst_all_1.gst-vaapi
		gst_all_1.gst-libav

		lutris

		alsa-oss

		obs-studio

		poetry

		fluidsynth
		soundfont-generaluser
		soundfont-fluid

		#cura-appimage
		#prusa-slicer
		orca-slicer

		jetbrains.clion
		jetbrains.rider

		kicad

		osu-lazer-bin

		(vscode-with-extensions.override {
			vscodeExtensions = with vscode-extensions; [
				#tamasfe.even-better-toml
				ms-vscode.cpptools

				#VisualStudioExptTeam.vscodeintellicode
			] ++ (with community-vscode-extensions; [
				editorconfig.editorconfig

				llvm-vs-code-extensions.vscode-clangd
				ms-vscode.cpptools-themes
				twxs.cmake
				webfreak.debug
				rioj7.vscode-file-templates
				mesonbuild.mesonbuild
				leonardssh.vscord

				platformio.platformio-ide

				bbenoist.nix

				#scala-lang.scala
				#scalameta.metals

				#vscjava.vscode-gradle
				#vscjava.vscode-maven

				#redhat.java
				#vscjava.vscode-java-pack
				#vscjava.vscode-java-debug
				#vscjava.vscode-java-dependency

				ms-python.python
				ms-python.debugpy
								
				ms-vscode.cmake-tools

				#vadimcn.vscode-lldb
				
				#(ms-dotnettools.csharp.overrideAttrs (_: { sourceRoot = "extension"; }))
				#(ms-dotnettools.vscodeintellicode-csharp.overrideAttrs (_: { sourceRoot = "extension"; }))
				#(ms-dotnettools.dotnet-maui.overrideAttrs (_: { sourceRoot = "extension"; }))
				#ms-dotnettools.csdevkit
				#ms-dotnettools.vscode-dotnet-runtime

				#nadako.vshaxe
				#kodetech.kha-extension-pack

				#rust-lang.rust-analyzer
				#vadimcn.vscode-lldb
				tamasfe.even-better-toml
				
				geequlim.godot-tools
				jacqueslucke.blender-development

				#prunoideae.probejs

				#ms-vscode-remote.remote-containers
			]) ++ [
				community-vscode-extensions."13xforever".language-x86-64-assembly
			];
		})
	];

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			function fish_prompt
				set_color brred; printf "<"

				if test -n "$IN_NIX_SHELL"
						set_color --dim brblue; printf "<nix-shell> "; set_color normal
				end

				set_color white; printf "$USER"; set_color red; printf "@"; set_color white; printf "$hostname"
				set_color brblack; printf (string replace "$HOME" "~" ":$(pwd)")

				set_color cyan; printf (fish_vcs_prompt)

				set_color brred; printf "> "; set_color white
			end

			set fish_greeting # Disable greeting
			any-nix-shell fish --info-right | source
		'';
		shellInit = ''
			set -Ux PIPENV_VENV_IN_PROJECT 1
			set -Ux POETRY_VIRTUALENVS_IN_PROJECT 1

			set -Ux PIPENV_TIMEOUT 999999999

			set -x WINEDLLOVERRIDES winemenubuilder.exe=d
			set -x WINEDEBUG -all

			set -x EM_CACHE ~/.cache/emscripten

			function runbg
				$argv &> /dev/null &
			end

			fish_add_path $HOME/.local/bin
		'';
		shellAliases = {
			".." = "cd ..";
			"..." = "cd ../..";
		};
	};

	programs.mangohud = {
		enable = true;
		settings = {
			fps_limit = 60;
			#vsync = 0;
			#gl_vsync = 1;

			#preset = 3;

			gpu_stats = true;
			gpu_temp = true;
			#gpu_junction_temp = true;
			gpu_power = true;
			gpu_load_change = true;
			#gpu_fan = true;
			gpu_core_clock = true;

			cpu_stats = true;
			cpu_temp = true;
			cpu_power = true;
			cpu_load_change = true;
			cpu_mhz = true;
			
			#core_load = true;
			#core_load_change = true;

			io_read = true;
			io_write = true;

			vram = true;
			ram = true;

			fps = true;
			frametime = true;

			battery = true;
			#battery_icon = true;

			#font_size = 20;
			round_corners = 8;
			no_display = true;

			gpu_name = true;
			exec_name = true;
		};
	};

	dconf.settings = {
		"org/virt-manager/virt-manager/connections" = {
			autoconnect = ["qemu:///system"];
			uris = ["qemu:///system"];
		};
	};

	home.sessionVariables = {
		"QT_QPA_PLATFORM" = "wayland";
		"NIXOS_OZONE_WL" = "1";
		#"LUTRIS_SKIP_INIT" = "1";
	};

	# Nicely reload system units when changing configs
	systemd.user.startServices = "sd-switch";

	# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	home.stateVersion = "25.11";
}
