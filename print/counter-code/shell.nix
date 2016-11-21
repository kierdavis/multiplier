with (import <nixpkgs> {});
stdenv.mkDerivation {
  name = "counter-code-env";
  buildInputs = [
    pkgs.python27Packages.pygments
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic etoolbox fancyvrb float framed graphics ifplatform lineno minted xcolor xstring;
    })
  ];
}
