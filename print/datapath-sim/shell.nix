with (import <nixpkgs> {});
stdenv.mkDerivation {
  name = "datapath-sim-env";
  buildInputs = [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic graphics xcolor;
    })
  ];
}
