with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "d1-report-env";
  buildInputs = [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic graphics;
    })
  ];
};
