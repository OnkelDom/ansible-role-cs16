# Counter-Strike 1.6 Ansible role

Installs a native SteamCMD/HLDS server on Debian with:

- dedicated unprivileged service account;
- systemd lifecycle and crash restart;
- 32-bit runtime and Steam compatibility link;
- AMX Mod X and SteamID-based admins;
- YaPB bots that fill to a configurable player count;
- bot-aware AMX fun announcements with bundled classic WAV sounds;
- an optional FastDL service for custom content;
- optional Fail2ban whitelist management;
- UFW rule for the UDP game port;
- synchronized HLDS/AMX map lists and bundled classic community maps;
- configurable slots, rates, map cycle and optional additional maps.

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
cs16_hostname: "LenMail CS 1.6 Fun Server | Classics, Bots & RTV"
cs16_port: 27015
cs16_maxplayers: 16
cs16_sys_ticrate: 500
cs16_pingboost: 2
cs16_bot_fill_players: 10
cs16_bot_difficulty: 1
cs16_bot_shoots_thru_walls: 0
cs16_bot_chat_enabled: 1
cs16_bot_chat_percent: 5
cs16_mp_timelimit: 20
cs16_mp_maxrounds: 0
cs16_mp_freezetime: 3
cs16_fastdl_enabled: true
cs16_fastdl_port: 8081
cs16_fastdl_url: "http://srv01.lenmail.de:8081/cstrike"
cs16_install_bundled_maps: true
cs16_admin_steamids:
  - steamid: "STEAM_0:1:44263"
    comment: "OnkelDom"
```

YaPB `fill` mode keeps the total number of players at
`cs16_bot_fill_players`; bots leave when humans connect. The slot limit remains
independent, so the example allows 16 human players.

Hetzner Cloud Firewall rules are external to the guest and are not changed by
this role. Allow inbound UDP `cs16_port` and, when FastDL is enabled, inbound
TCP `cs16_fastdl_port` in Hetzner as well.

The role bundles the LenMail AMX plugin sources, classic announcer WAVs and the
five community maps used by the configured rotation (`fy_pool_day`,
`fy_iceworld`, `fy_snow`, `aim_map`, `awp_map`). They are deployed to the game
server and mirrored to FastDL. Set `cs16_install_bundled_maps: false` if you do
not want to deploy them. Provenance and redistribution notes are documented in
`roles/cs16_server/files/custom_content/SOURCES.md`.

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
