{ config, pkgs, lib, ... }:

{
  # Enable printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      hplip
      gutenprint
    ];
  };

  # Printing tools
  environment.systemPackages = with pkgs; [
    cups
    cups-filters
    hplip
    system-config-printer
  ];

  # CUPS configuration
  services.cupsd = {
    enable = true;
    extraConf = ''
      # Allow remote administration
      <Location />
        Order allow,deny
        Allow all
      </Location>
      
      <Location /admin>
        Order allow,deny
        Allow all
      </Location>
      
      <Location /admin/conf>
        AuthType Default
        Require user @SYSTEM
        Order allow,deny
        Allow all
      </Location>
    '';
  };
}