{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = with pkgs; [
  flutter
  clang
  cmake
  ninja
  pkg-config
  gtk3
];
}
