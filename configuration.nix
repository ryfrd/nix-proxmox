{ pkgs, config, ... }: {

  imports = [
    ./hardware-configuration.nix
    ./additions.nix
  ];

  # automatic nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  nix.settings = {
    # enable flakes
    experimental-features = "nix-command flakes";
    # saves some disk space
    auto-optimise-store = true;
    # allows remote rebuild
    trusted-users = [ "james" ];
  };

  # auto update system
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "${config.users.users.james.home}/nix-config/";
    flags = [
      "--update-input" "nixpkgs"
    ];
    allowReboot = true;
  };

  # bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # firewall !!!
  networking.firewall.enable = true;

  # ssh access
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
  # open ssh port
  networking.firewall.allowedTCPPorts = [ 97 ];

  # tailscale daemon
  services.tailscale.enable = true;

  users.users.james = {
    isNormalUser = true;
    initialPassword = "thisisabadpassword";
    # sudo
    extraGroups = [ "wheel" ];
    # let me in
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKW4ofxuyFKtDXCHHR6UDf5hGolKwZqt3h7SFLCCy++6 james@baron"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzFa1hmBsCrPL5HvJZhXVEaWiZIMi34oR6AOcKD35hQ james@countess"
    ];
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # install some basic stuff for humans
  environment.systemPackages = with pkgs; [
    neovim
    git
    tree
    curl
    dua
    ranger
    rsync
  ];

}
