with (import <nixpkgs> {});
stdenv.mkDerivation {
  name = "datapath-code-env";
  buildInputs = [
    pkgs.python27Packages.pygments
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic etoolbox fancyvrb float framed ifplatform lineno minted xcolor xstring;
    })
  ];
}
