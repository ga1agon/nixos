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
	#services.arrpc.enable = true;
	
	programs.home-manager.enable = true;
	
	home.packages = with pkgs; [
		any-nix-shell
		#clipboard-jh
		multipath-tools
		openssl

		# useful default DE apps replacements
		#gthumb
		haruna
		#peazip
		p7zip

		#sshfs
		#partition-manager
		aria2

		github-desktop

		#discord
		strawberry
		#vlc
		#krita
		#kodi-wayland
		obsidian
		
		parsec-bin
		moonlight-qt

		gst_all_1.gstreamer
		gst_all_1.gst-plugins-rs
		gst_all_1.gst-vaapi
		gst_all_1.gst-libav

		lutris
		#legendary-gl
		(prismlauncher.override {
			jdks = [
				temurin-bin-8
				temurin-bin-17
				graalvm-ce
			];
		})
		#clonehero
		#ferium
		#ckan

		alsa-oss
		opencomposite

		#kompare
		krita
		#inkscape
		obs-studio
		kdePackages.kdenlive
		novelwriter

		#temurin-bin-17
		#graalvm-ce

		#kdevelop

		poetry
		#pipenv

		fluidsynth
		soundfont-generaluser
		soundfont-fluid

		tenacity

		spotify
		nicotine-plus

		#oneko
		discord
		vesktop
		#kdePackages.konversation
		
		cura-appimage
		prusa-slicer
		orca-slicer

		# needed for tmodloader
		dotnetCorePackages.dotnet_8.sdk

		# IDEs
		#jetbrains.clion
		#kdePackages.kdevelop
		#unityhub
		
		kdePackages.filelight

		#superTuxKart
		#osu-lazer-bin

		blender-hip
		#blender
		#goxel
		xournalpp
		blockbench

		kicad

		#cura

		kdePackages.krdc

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

	xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";
	
	xdg.configFile."openvr/openvrpaths.vrpath".text = ''
	  {
	    "config" :
	    [
	      "${config.xdg.dataHome}/Steam/config"
	    ],
	    "external_drivers" : null,
	    "jsonid" : "vrpathreg",
	    "log" :
	    [
	      "${config.xdg.dataHome}/Steam/logs"
	    ],
	    "runtime" :
	    [
	      "${pkgs.opencomposite}/lib/opencomposite"
	    ],
	    "version" : 1
	  }
	'';

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			function fish_prompt
				set_color brblue; printf "<"

				if test -n "$IN_NIX_SHELL"
						set_color --dim brblue; printf "<nix-shell> "; set_color normal
				end

				set_color white; printf "$USER"; set_color magenta; printf "@"; set_color white; printf "$hostname"
				set_color brblack; printf (string replace "$HOME" "~" ":$(pwd)")

				set_color cyan; printf (fish_vcs_prompt)

				set_color brblue; printf "> "; set_color white
			end

			set fish_greeting # Disable greeting
			any-nix-shell fish --info-right | source
		'';
		shellInit = ''
			set -Ux PIPENV_VENV_IN_PROJECT 1
			set -Ux POETRY_VIRTUALENVS_IN_PROJECT 1

			set -Ux PIPENV_TIMEOUT 999999999
			
			set -x HSA_OVERRIDE_GFX_VERSION 11.0.2
			set -x PYTORCH_HIP_ALLOC_CONF garbage_collection_threshold:0.95,max_split_size_mb:128

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
			fps_limit = 0;
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
		#"QT_QPA_PLATFORM" = "wayland";
		#"NIXOS_OZONE_WL" = "1";
		#"LUTRIS_SKIP_INIT" = "1";
		"DOTNET_ROOT" = "${pkgs.dotnetCorePackages.dotnet_8.sdk}/share/dotnet";
	};

	# Nicely reload system units when changing configs
	systemd.user.startServices = "sd-switch";

	# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	home.stateVersion = "23.11";
}
