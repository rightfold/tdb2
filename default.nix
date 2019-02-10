{pkgs ? import ./Nix/Pkgs.nix {}}:
pkgs.stdenv.mkDerivation {
    name = "Tdb2";
    src = pkgs.lib.sources.cleanSource ./.;
    buildInputs = [
        (pkgs.bash)
        (pkgs.makeWrapper)
        (pkgs.python3Packages.docutils)
        (pkgs.which)
        (pkgs.rWrapper.override {
            packages = [pkgs.rPackages.ggplot2];
        })
        (pkgs.haskellPackages.ghcWithPackages (hpkgs: [
            hpkgs.aeson
            hpkgs.base
            hpkgs.containers
            hpkgs.free
            hpkgs.kan-extensions
            hpkgs.lens
            hpkgs.mtl
            hpkgs.servant
            hpkgs.servant-server
            hpkgs.stm
            hpkgs.text
            hpkgs.transformers
            hpkgs.vector
            hpkgs.warp

            hpkgs.ghcid
        ]))
    ];
    phases = ["unpackPhase" "buildPhase" "installPhase"];
    buildPhase = ''
        mkdir 'UseCases'
        mkdir 'Haddock'

        GHC_OPTIONS=(
            # Warning flags.
            -Wall -Wincomplete-record-updates -Wincomplete-uni-patterns

            # Source files.
            -i'Source'
        )

        HADDOCK_OPTIONS=(
            -h
            -o 'Haddock'
            "''${GHC_OPTIONS[@]/#/--optghc=}"
        )

        ghc                                                                 \
            "''${GHC_OPTIONS[@]}"                                           \
            -O2 -threaded -with-rtsopts='-qg -I0 -A32m'                     \
            -o 'Tdb2d' 'Source/Programs/Tdb2d.hs'

        bash Tools/UseCases 'UseCases'

        find 'Source' -type f -name '*.hs' -print0                          \
            | xargs -0 haddock "''${HADDOCK_OPTIONS[@]}"
    '';
    installPhase = ''
        mkdir -p "$out/bin" "$out/share/doc"

        mv 'Tdb2d' "$out/bin"
        cp -R 'UseCases' "$out/share/doc"
        cp -R 'Haddock' "$out/share/doc"

        # mv 'src/report.R' "$out/share"
        # makeWrapper "$(which Rscript)" "$out/bin/tdb2-report"             \
        #     --add-flags '--vanilla'                                       \
        #     --add-flags "$out/share/report.R"
    '';
}
