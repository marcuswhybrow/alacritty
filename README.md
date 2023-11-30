```bash
nix run github:marcuswhybrow/alacritty
```

Or as input to a nix flake:

```nix
{
    inputs.alacritty.url = "github:marcuswhybrow/alacritty";
    outputs = inputs: {
        packages.x86_64-linux.alacritty = inputs.alacritty.overrides.x86_64-linux.alacritty {
            window.opacity = 1;
            window.padding.x = 0;
            window.padding.y = 0;
        };
    };
}
```

