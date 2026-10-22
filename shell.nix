with import <nixpkgs> {
  crossSystem = {
    config = "riscv32-none-elf";

    gcc = {
      arch = "rv32i_zicsr";
      abi = "ilp32";
    };
  };
};
mkShell {
  nativeBuildInputs = [
    buildPackages.meson
    buildPackages.ninja
    buildPackages.pkg-config
    buildPackages.clang-tools
    buildPackages.bear
  ];
}
