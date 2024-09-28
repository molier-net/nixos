{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "remko";
  home.homeDirectory = "/home/remko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-vscode-remote.remote-containers
      ];
    })
    pkgs.google-chrome
    pkgs.veracrypt
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    #
    ".config/Yubico/u2f_keys".text = ''
      remko:*,z0XJK34h5cWkrhX7/xSnhzqCwN8Mz33+yXSTVLRs/pdIAmCciLosREm8rTuzhzf1cAqFrO8XExEjXphMLeDrNA==,es256,+presence+pin
      remko:*,BpHmLhso1VcYGXqdcKlbfK7n8pqylgt+YcUcksWibG6z9H5ayrIw2fYGsBzffYtUDXSWGkjHutnUmQ+FAmphLg==,es256,+presence+pin
    '';
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/remko/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    addKeysToAgent = "ask 1h";
    forwardAgent = true;
    hashKnownHosts = false;
  };

  # GIT configuration
  programs.git = {
    enable = true;
    userName  = "Remko Molier";
    userEmail = "remko.molier@googlemail.com";
    signing = {
      key = "1683D7541D7BA1AA";
      signByDefault = true;
    };
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
    lfs.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
