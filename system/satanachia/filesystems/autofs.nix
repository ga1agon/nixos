{ pkgs, ... }:
let
	hermesData = pkgs.writeText "hermesData" ''
		data -fstype=cifs,username=Workspace0,password=Workspace0,mfsymlinks,acl,uid=1000,gid=100 ://HERMES/data
	'';

	hermesArchive = pkgs.writeText "hermesArchive" ''
		archive -fstype=cifs,username=Workspace0,password=Workspace0,mfsymlinks,acl,uid=1000,gid=100 ://HERMES/archive
	'';
in
{
	services.autofs = {
		enable = true;
		autoMaster = ''
			/@/HERMES/data file:${hermesData}
			/@/HERMES/archive file:${hermesArchive}
		'';
	};
}
