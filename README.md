# starship.fish
Simplified hooks for starship for Fish shell, with transient prompt.

## Installation

Install with [Fisher][]:

```console
fisher install martonperei/starship.fish
```

Add a `transient` profile to your `starship.toml` config.
Example:
```toml
[profiles]
transient="""
$character
"""
```

## Acknowledgments

- [zzhaolei/transient.fish][] - Used as a base to improve starship's transient rendering

[fisher]: https://github.com/jorgebucaran/fisher
[zzhaolei/transient.fish]: https://github.com/zzhaolei/transient.fish 
