# Counter-Strike 1.6 Ansible role

Installs a native SteamCMD/HLDS server on Debian with:

- dedicated unprivileged service account;
- systemd lifecycle and crash restart;
- 32-bit runtime and Steam compatibility link;
- AMX Mod X and SteamID-based admins;
- YaPB bots that fill to a configurable player count;
- UFW rule for the UDP game port;
- configurable slots, rates, map cycle and optional custom maps.

## Usage

Install the required collection:

```bash
ansible-galaxy collection install -r requirements.yml
```

Copy `inventory.example.ini`, then run:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

SSH keys remain in the operator's normal SSH configuration. Do not put private
keys in this project.

## Important variables

```yaml
cs16_hostname: "LenMail CS 1.6"
cs16_port: 27015
cs16_maxplayers: 16
cs16_sys_ticrate: 500
cs16_pingboost: 2
cs16_bot_fill_players: 10
cs16_bot_difficulty: 2
cs16_mp_timelimit: 20
cs16_mp_maxrounds: 12
cs16_admin_steamids:
  - steamid: "STEAM_0:1:44263"
    comment: "OnkelDom"
```

YaPB `fill` mode keeps the total number of players at
`cs16_bot_fill_players`; bots leave when humans connect. The slot limit remains
independent, so the example allows 16 human players.

Hetzner Cloud Firewall rules are external to the guest and are not changed by
this role. Allow inbound UDP `cs16_port` in Hetzner as well.

## Updates

Run on the managed host:

```bash
sudo /usr/local/sbin/update-cs16
```

## Optional custom maps

Only use map downloads you are licensed to redistribute:

```yaml
cs16_custom_maps:
  - url: "https://example.invalid/maps/fy_pool_day.bsp"
    filename: "fy_pool_day.bsp"
```

Add the map name to `cs16_mapcycle` separately. Maps with additional models,
sounds or sprites should be packaged through a dedicated archive task rather
than as a single BSP.
