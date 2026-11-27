{
  description = "anki-cli on Python 3.14 over the official anki wheel";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      anki-cli = nixpkgs.legacyPackages.${system}.callPackage ./nix/package.nix { };
    in
    {
      packages.${system} = {
        inherit anki-cli;
        default = anki-cli;
      };
      apps.${system}.default = {
        type = "app";
        program = "${anki-cli}/bin/anki-cli";
      };
    };
}
