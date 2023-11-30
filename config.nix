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
    rev = "3c808cbb4f9c87be43ba5241bc57373c793d2f17";
    sha256 = "sha256-w9XVtEe7TqzxxGUCDUR9BFkzLZjG8XrplXJ3lX6f+x0=";
  };
  baseConfig = {
    import = [
      "${catppuccin}/catppuccin-latte.yml"
    ];
    key_bindings = [
      {
        key = "Plus";
        mods = "Control|Shift";
        command = {
          program = "~/Repositories/alacritty/result/bin/alacritty";
          args = [
            "msg"
            "config"
            "window.padding.x=${toString padding}"
            "window.padding.y=${toString padding}"
          ];
        };
      }
      {
        key = "Underline";
        mods = "Control|Shift";
        command = {
          program = "~/Repositories/alacritty/result/bin/alacritty";
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
  yaml = builtins.toJSON finalConfig; # YAML is a superset of JSON
in pkgs.writeText "alacritty.yml" yaml
