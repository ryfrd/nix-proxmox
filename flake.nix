{ config, ... }: {
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  outputs = { nixpkgs, ... }: {
    # change hostname
    nixosConfigurations.${config.networking.hostname} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
