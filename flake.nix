{
  description = "Marcus' Alacritty terminal";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    overrides.x86_64-linux.alacritty = let 
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in alacrittyConfig: pkgs.runCommand "alacritty" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } (let 
      allArgs = { 
        inherit pkgs;
        config = alacrittyConfig; 
      };
      config = import ./config.nix allArgs;
    in /* bash */ ''
      mkdir -p $out/bin
      mkdir -p $out/share
      ln -s ${config} $out/share/alacritty.toml

      makeWrapper \
        ${pkgs.alacritty}/bin/alacritty \
        $out/bin/alacritty \
        --add-flags "--config-file $out/share/alacritty.toml"

      mkdir -p $out/share/applications
      cat > $out/share/applications/alacritty.desktop << EOF
      [Desktop Entry]
      Version=1.0
      Name=Alacritty
      GenericName=A cross-platform, OpenGL terminal emulator.
      Terminal=false
      Type=Application
      Exec=$out/bin/alacritty
      EOF
    '');

    packages.x86_64-linux.alacritty = self.overrides.x86_64-linux.alacritty {};
    packages.x86_64-linux.default = self.packages.x86_64-linux.alacritty;
  };
}
