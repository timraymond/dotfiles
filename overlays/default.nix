final: prev: {
  tmux-themepack = prev.stdenv.mkDerivation {
    pname = "tmux-themepack";
    version = "1.1.0";

    src = prev.fetchFromGitHub {
      owner = "jimeh";
      repo = "tmux-themepack";
      rev = "1.1.0";
      sha256 = "f6y92kYsKDFanNx5ATx4BkaB/E7UrmyIHU/5Z01otQE=";
    };

    installPhase = ''
      mkdir -p $out/share/tmux-themepack
      cp -r * $out/share/tmux-themepack
    '';

    meta = {
      description = "A pack of various themes for Tmux.";
      homepage = "https://github.com/jimeh/tmux-themepack";
    };
  };

  space-vim-theme = prev.vimUtils.buildVimPlugin {
    pname = "space-vim-theme";
    version = "master";
    src = prev.fetchFromGitHub {
      owner = "liuchengxu";
      repo = "space-vim-theme";
      rev = "master";
      sha256 = "1nv099x5qq8mal9dwjj29dk357mzhn4vb9wljhglra9imammrz43";
    };
  };

  vim-bicep = prev.vimUtils.buildVimPlugin {
    pname = "vim-bicep";
    version = "master";
    src = prev.fetchFromGitHub {
      owner = "carlsmedstad";
      repo = "vim-bicep";
      rev = "master";
      sha256 = "1ouXcJHWhX7vPuOa27kPT+49cBTFB4n3HZ/LwE+12aw=";
    };
  };

  pinentry-wsl = prev.stdenv.mkDerivation {
    pname = "pinentry-wsl";
    version = "41c6ea1";
    meta = {
      mainProgram = "pinentry-wsl-ps1.sh";
    };
    src = prev.fetchFromGitHub {
      owner = "diablodale";
      repo = "pinentry-wsl-ps1";
      rev = "4fc6ea16270c9c2f2d9daeae1ba4aa0d868d1b2a";
      sha256 = "sha256-nAK3GwVYOOghFVf9Yj5zFOcVeFfSsW5fHy6rfH+edAs=";
    };
    buildInputs = [ prev.bash ];
    nativeBuildInputs = [ prev.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      chmod +x pinentry-wsl-ps1.sh
      cp pinentry-wsl-ps1.sh $out/bin/pinentry-wsl-ps1.sh
      wrapProgram $out/bin/pinentry-wsl-ps1.sh \
        --prefix PATH : ${prev.lib.makeBinPath [ prev.bash ]}
    '';
  };
}
