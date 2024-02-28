How to build a reproducible docker image using Nix
==================================================

For docs check out: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools

```bash
$ nix build
$ docker image load -i result
$ docker run -it my-awesome-img:latest bash
bash-5.2# gcc --version
gcc (GCC) 13.2.0
```
