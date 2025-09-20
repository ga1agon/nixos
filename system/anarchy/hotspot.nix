{ pkgs, lib, ... }:
{
# 	networking = {
# 		bridges.br0 = {
# 			interfaces = [
# 				"eno1"
# 			];
# 		};
# 
# 		interfaces.br0.ipv4.addresses = [
# 			{
# 				address = "192.168.127.1";
# 				prefixLength = 24;
# 			}
# 		];
# 
# 		networkmanager.unmanaged = [ "interface-name:wlp6s0" ];
# 		firewall.allowedUDPPorts = [ 53 67 ];
# 	};
# 
# 	services.hostapd = {
# 		enable = true;
# 		radios.wlp6s0 = {
# 			networks.wlp6s0 = {
# 				ssid = "dsdasdaadsad";
# 				authentication = {
# 					mode = "wpa2-sha256";
# 					wpaPassword = "123123456";
# 				};
# 			};
# 
# 			wifi6 = {
# 				enable = true;
# 				require = true;
# 				operatingChannelWidth = "160";
# 			};
# 		};
# 	};

	services.dnsmasq = {
		enable = true;
		settings = {
			interface = "br0";
			dhcp-range = [ "192.168.127.1,192.168.127.254" "255.255.255.0,24h" ];
		};
	};

	boot.kernel.sysctl = {
		"net.ipv4.ip_forward" = true;
	};
}
