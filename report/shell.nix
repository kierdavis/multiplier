with (import <nixpkgs> {});
stdenv.mkDerivation {
  name = "d1-report-env";
  buildInputs = [
    pkgs.python27Packages.pygments
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic etoolbox fancyvrb float framed ifplatform lineno minted xcolor xstring;
    })
  ];
}
