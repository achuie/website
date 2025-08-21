#lang pollen

◊(define-meta published "31 03 2025")

◊post-title{Setting Up a Server for My Server}

So I set up my homelab, but now I have to make it accessible from outside my apartment. Normally this is trivially done
with port forwarding rules on one's router, but my apartment building has a centralized, building-wide router from our
internet provider that I don't have control over. I could probably call and ask them about it, but knowing Japan I bet
they either don't allow it or hide it behind so many bureaucratic processes and forms as to render it not worth the
while.

Instead, I will attempt to use a persistent reverse SSH tunnel from my homelab to a hosted virtual machine, in this case
a Digital Ocean droplet.

◊(subheading 'h2 "Making the Base Image")

NixOS has a convenient
◊body-link["https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/digital-ocean-config.nix"]{
config module for droplets} with sane defaults, which I imported in my NixOS configuration:

◊file-block["configuration.nix"]{
imports =
  [
    "${inputs.nixpkgs-stable}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];
}

I also found it convenient to include my SSH public key at this stage so I can connect immediately after setup:

◊file-block["configuration.nix"]{
users.users.${your_user} = {
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA user@hostname"
  ]
};
}

And here's the sshd config:

◊file-block["configuration.nix"]{
services.openssh = {
  enable = true;
  authorizedKeysInHomedir = true;
  allowSFTP = true;
  settings = { PasswordAuthentication = false; GatewayPorts = "yes"; };
};
}

From here the options are like those for any other machine config, though I kept it a bit minimal; just the usual nix
path and flakes-enabling settings, plus utilities I thought I'd use:

◊file-block["configuration.nix"]{
nix = {
  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
};

environment = {
  systemPackages = with pkgs; [ vim git lynx fd ripgrep rsync ];
  pathsToLink = [ "/libexec" ];
};
}

The way I've set up this config to be built by the same flake that builds my other machines is to put this
◊code{configuration.nix} file in its own subdirectory, and include it as a module when building with ◊code{nixosSystem}.
It should look like the following:

◊file-block["flake.nix"]{
nixosConfigurations = {
  ${your_hostname} = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit (self) inputs; };
    modules = [
      ./nixos/${your_hostname}/configuration.nix
    ];
  };
  ${other_hostname} = nixpkgs.lib.nixosSystem {
    (...)
  };
  (...)
};
}

With this setup, I can specify the following attribute to build an image to upload to Digital Ocean:

◊code-block{
$ nix build ".#nixosConfigurations.$HOSTNAME.config.system.build.digitalOceanImage"
}

Then spin up a VM based on that image.

◊(subheading 'h2 "Setting up the SSH Tunnel")

With the VM alive, I reserved a static IP address for it on DO's management page. Then I configured my homelab to reach
out to that address with ◊code{autossh}.

◊file-block["configuration.nix"]{
systemd.services.tunnel = {
  description = "Start reverse tunnel, and keep it alive.";
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" "network-online.target" "sshd.service" ];
  serviceConfig = {
    ExecStart = ''
      # Port 2222 can be any unreserved port
      ${pkgs.autossh}/bin/autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -N -R *:2222:localhost:22 \
      -i /home/$USER/.ssh/id_ed25519 $USER@$STATIC_IP
    '';
  };
};
}

The aptly-named ◊code{systemd.services} attribute creates a systemd service to automatically start the ◊code{autossh}
connection after the ◊code{sshd} and ◊code{network} targets come online. I don't really like having to translate the
actual service field names to their equivalent Nix attribute names, but recording it in the config here is pretty
convenient for tracking the state of the system.

One ◊code{nixos-rebuild switch} later and we're connected.

◊(subheading 'h2 "Rebuilding Remotely")

Another thing we'll have to do from time to time is change the config or update the droplet. Actually I've already had
to do this when I forgot to include ◊code{GatewayPorts = "yes"} for openssh. I don't want to incur any additional
compute charges with DO unnecessarily, so my MO is to build the system on my homelab, then copy and install the result
to the droplet; easily done with ◊code{--target-host}.

◊code-block{
$ nixos-rebuild switch --flake ".#$HOSTNAME" --target-host "$USER@$STATIC_IP"
}

◊(subheading 'h2 "Wrap Up")

That's it for today, I'll have to think of what to do next with NixOS and droplets in the future.
