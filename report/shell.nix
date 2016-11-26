with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "d1-report-env";
  buildInputs = [
    pkgs.python27Packages.pygments
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic
        caption
        etoolbox # dependency of minted
        fancyvrb # dependency of minted
        float # dependency of minted
        framed # dependency of minted
        ifplatform # dependency of minted
        l3kernel # dependency of siunitx
        l3packages # dependency of siunitx
        lineno # dependency of minted
        minted
        ms # dependency of todonotes
        pgf # dependency of todonotes
        siunitx
        todonotes
        xcolor # dependency of minted, todonotes
        xkeyval # dependency of todonotes
        xstring # dependency of minted
      ;
    })
  ];
}
