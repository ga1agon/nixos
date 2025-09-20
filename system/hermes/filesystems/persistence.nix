{
	environment.persistence."/@" = {
		directories = [
			"/etc/nixos"
			"/etc/NetworkManager"
			"/var/log"
			"/etc/ssh"
			"/var/lib/nixos"
			"/var/lib/samba"
		];
		files = [
			"/etc/machine-id"
			"/etc/nix/id_rsa"
		];
	};
}
