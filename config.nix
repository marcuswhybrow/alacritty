{ 
  pkgs,
  config,
}: let
  fontFamily = "FiraCode Nerd Font";
  padding = 40;
  opacity = 0.9;
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    rev = "071d73effddac392d5b9b8cd5b4b527a6cf289f9";
    sha256 = "sha256-HiIYxTlif5Lbl9BAvPsnXp8WAexL8YuohMDd/eCJVQ8=";
  };
  baseConfig = {
    import = [
      "${catppuccin}/catppuccin-latte.toml"
    ];
    keyboard.bindings = [
      {
        key = "Minus";
        mods = "Control|Shift";
        command = {
          program = "alacritty";
          args = [
            "msg"
            "config"
            "window.padding.x=${toString padding}"
            "window.padding.y=${toString padding}"
          ];
        };
      }
      {
        key = "Plus";
        mods = "Control|Shift";
        command = {
          program = "alacritty";
          args = [
            "msg"
            "config"
            "window.padding.x=0"
            "window.padding.y=0"
          ];
        };
      }
    ];
    window = {
      inherit opacity;
      padding = {
        x = padding;
        y = padding;
      };
    };
    font = {
      normal.family = fontFamily;
      normal.style = "Regular";

      bold.family = fontFamily;
      bold.style = "Bold";

      italic.family = fontFamily;
      italic.style = "Light";
    };
  };

  finalConfig = pkgs.lib.attrsets.recursiveUpdate baseConfig config;
  configFormat = pkgs.formats.toml {};
  configFile = configFormat.generate "alacritty.toml" finalConfig;
in configFile
