{ lib, pkgs, ... }:
{
	services.samba = {
		enable = true;
		openFirewall = true;

		settings = {
			global = {
				"workgroup" = "WORKGROUP";
				"security" = "user";
				"use sendfile" = "yes";
				"guest account" = "nobody";
			};

			"data" = {
				"path" = "/@/data";
				"browseable" = "yes";
				"read only" = "no";
				"guest ok" = "no";
				"create mask" = "0644";
      			"directory mask" = "0755";
				"force user" = "Workspace0";
				"force group" = "users";
			};

			"archive" = {
				"path" = "/@/archive";
				"browseable" = "yes";
				"read only" = "no";
				"guest ok" = "yes";
				"create mask" = "0644";
      			"directory mask" = "0755";
				"force user" = "Workspace0";
				"force group" = "users";
			};
		};
	};

	services.samba-wsdd = {
		enable = true;
		openFirewall = true;
	};

	services.avahi = {
		publish.enable = true;
		publish.userServices = true;
		# ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
		nssmdns4 = true;
		# ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
		enable = true;
		openFirewall = true;
	};
}
