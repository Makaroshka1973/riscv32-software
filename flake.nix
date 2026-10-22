{
  description = "DevShell for developing and building Mak's RISC-V software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        hostPkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          config.allowBroken = true;
          crossSystem = {
            config = "riscv32-none-elf";
            gcc = {
              arch = "rv32i_zicsr";
              abi = "ilp32";
            };
          };
        };
      in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs.buildPackages; [
              meson
              ninja
              pkg-config
              
              hostPkgs.clang-tools
              hostPkgs.bear
            ];
          };
        }));
}
