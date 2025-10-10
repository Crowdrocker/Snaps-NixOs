{ config, pkgs, lib, inputs, ... }:

{
  # Network configuration
  networking = {
    hostName = "snaps-pc";
    networkmanager.enable = true;
    
    firewall = {
      enable = true;
      allowPing = true;
      
      # Gaming ports
      allowedTCPPorts = [
        27015 27016     # Steam and games
        3478 3479       # PlayStation Network
        3659            # Battle.net
        6112            # Blizzard
      ];
      
      allowedUDPPorts = [
        2456 2457 2458  # Valheim
        27015 27016     # Games
        3478 3479       # PSN
        3659            # Battle.net
        6112            # Blizzard
        8767 27036      # Steam
      ];
    };
  };

  # DNS configuration
  services.resolved = {
    enable = true;
    extraConfig = ''
      [Resolve]
      DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
      FallbackDNS=8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844
      Domains=~.
      DNSSEC=yes
      DNSOverTLS=yes
    '';
  };

  # Tailscale for remote access
  services.tailscale.enable = true;

  # Network tools
  environment.systemPackages = with pkgs; [
    networkmanager
    wget
    curl
    inetutils
    ethtool
    dhcpcd
    dnsmasq
    iwd
    nmap
    speedtest-cli
  ];
}