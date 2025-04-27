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

  vim-sentencer = prev.vimUtils.buildVimPlugin {
    pname = "vim-sentencer";
    version = "8826dcb";
    src = prev.fetchFromGitHub {
      owner = "whonore";
      repo = "vim-sentencer";
      rev = "master";
      sha256 = "sha256-6hI+JBdK+LJiTp1pPceHPKzX26cx0LLUmv3yI2TNPyk=";
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

  mutt-oauth = prev.stdenv.mkDerivation {
    pname = "mutt_oauth2";
    version = "354c5b11eaac97063dd98cbc58acbcecc34e6729";
    meta = {
      mainProgram = "mutt_oauth2.py";
    };
    buildInputs = [ prev.python3 ];
    nativeBuildInputs = [ prev.makeWrapper ];
    src = prev.fetchFromGitLab {
      owner = "muttmua";
      repo = "mutt";
      rev = "354c5b11eaac97063dd98cbc58acbcecc34e6729";
      sha256 = "sha256-3slr77Rd2yDyhiTt5C+g2h5hxytqu7LJo/6u4Q15N3s=";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp $src/contrib/mutt_oauth2.py $out/bin
      sed -i s/YOUR_GPG_IDENTITY/tim@timraymond.com/g $out/bin/mutt_oauth2.py
      chmod +x $out/bin/mutt_oauth2.py
      wrapProgram $out/bin/mutt_oauth2.py \
        --prefix PATH : ${prev.lib.makeBinPath [ prev.python3 ]}
    '';
  };
}
