# For docs check out: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools
#
# $ nix build
# $ docker image load -i result
# $ docker run -it my-awesome-img:latest bash
# bash-5.2# gcc --version
# gcc (GCC) 13.2.0
{
  description = "Example how to build a docker image via Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      pkgs_x86_64-linux = import nixpkgs { system = "x86_64-linux"; };

      # See: https://hub.docker.com/layers/nixos/nix/2.20.3/images/sha256-4e7052357753c139fbb0eca825f4d4c773bcc8bfea61f31f2762a89e1750940d
      nixFromDockerHub = pkgs.dockerTools.pullImage {
        imageName = "nixos/nix";
        imageDigest = "sha256:4e7052357753c139fbb0eca825f4d4c773bcc8bfea61f31f2762a89e1750940d";
        finalImageName = "nix";
        finalImageTag = "2.20.3";
        sha256 = "sha256-0tkm5cNoJUUdBCj4vLPTUdIdB5DSR4R2iupxZ09eTsk=";
        os = "linux";
        arch = "x86_64";
      };
    in
      {
        packages.default = pkgs.dockerTools.buildLayeredImage {
          name = "my-awesome-img";
          tag = "latest";
          fromImage = nixFromDockerHub;
          contents = [
            pkgs_x86_64-linux.gnumake
            pkgs_x86_64-linux.gcc
          ];
          maxLayers = 102;
          extraCommands = ''
            mkdir root
            echo 'export PATH="$PATH:/bin"' >> root/.bashrc
          '';
        };
      }
  );
}
