with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "d1report-env";
  buildInputs = [
    pkgs.python27Packages.pygments
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic
        biblatex
        biblatex-ieee
        booktabs
        caption
        etoolbox # dependency of biblatex, minted
        fancyvrb # dependency of minted
        float # dependency of minted
        framed # dependency of minted
        ifplatform # dependency of minted
        iftex # dependency of biblatex
        l3kernel # dependency of siunitx
        l3packages # dependency of siunitx
        lineno # dependency of minted
        logreq # dependency of biblatex
        minted
        ms # dependency of todonotes
        pgf # dependency of todonotes
        siunitx
        todonotes
        wrapfig
        xcolor # dependency of minted, todonotes
        xkeyval # dependency of todonotes
        xstring # dependency of biblatex, minted
      ;
    })
  ];
}
