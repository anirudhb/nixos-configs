{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    devShell.@@SYSTEM@@ = let
      pkgs = nixpkgs.legacyPackages.@@SYSTEM@@;
    in with pkgs; mkShell {
      nativeBuildInputs = with pkgs; [
        @@BUILDINPUTS@@
        # Add build inputs here!
      ];
    };
  };
}
