{ config, pkgs, inputs, lib, ... }:

{
  home.username = "remko";
  home.homeDirectory = "/home/remko";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [

    # archivers
    zip
    xz
    unzip
    p7zip
    
    # utils
    jq

    # networking tools
    mtr
    iperf3
    dnsutils

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd

    # productivity
    hugo
    glow

    # system call monitoring
    strace
    ltrace
    lsof

    # system tools
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # rockchip development
    screen
    rkdeveloptool
    
    # visual studio code
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        redhat.vscode-yaml
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        jnoortheen.nix-ide
      ];
    })

    # fonts
    (nerdfonts.override { fonts = ["JetBrainsMono" "Inconsolata"]; })
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs.alacritty = {
		enable = true;
		settings = {
			env.TERM = "xterm-256color";
			window.padding = {
				x = 10;
				y=10;
			};
			window.decorations = "none";
			window.opacity = 0.7;
			scrolling.history = 1000;
			font = {
				normal = {
					family = "JetBrains Mono Nerd Font";
					style = "Regular";
				};
				bold = {
					family = "JetBrains Mono Nerd Font";
					style = "Bold";
				};
				italic = {
					family = "JetBrains Mono Nerd Font";
					style = "Italic";
				};
				size = 14;
			};
		};
	};

  programs.git = {
    enable = true;
    userName = "Remko Molier";
    userEmail = "remko.molier@googlemail.com";
    lfs.enable = true;
    signing = {
      key = "CAA1B2810DAA078F";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };
      core = {
        whitespace = "trailing-space,space-before-tab";
      };
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.zsh.enable = true;

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = ["git" "docker"];
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  
    
  
}
