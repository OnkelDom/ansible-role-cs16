# Bundled community maps

These files are copies of the community maps currently used by the LenMail
server. They are included so the Ansible role can reproduce its configured
start map and rotation without depending on unstable third-party download URLs.

- `fy_pool_day` — its resource file attributes the map to GameBanana mod 86562.
- `fy_iceworld`
- `fy_snow`
- `aim_map`
- `awp_map`

Valve-owned stock maps and stock game assets are not duplicated here. Review
the individual community map licensing terms before redistributing this role
outside the server owner's own infrastructure.

`fy_iceworld` references `de_vegas.wad`; it is bundled alongside the map and
declared in `maps/fy_iceworld.res` so clients receive the required textures via
FastDL before loading the map.

## Aim and AWP maps added 2026-11-06

- `aim_deagle`: [map source](https://gamebanana.com/mods/94185), [archive](https://gamebanana.com/dl/401796). BSP SHA-256: `e180c6620bae11a1cd6e666cda5a363e2dd7c2ca18104daf6e15cca91ab20e17`.
- `aim_awp`: [map source](https://gamebanana.com/mods/93864), [archive](https://gamebanana.com/dl/296533). BSP SHA-256: `ad3b665ebf880d659342e7f337dfa64c18f65c41858438c2ebd5ea4925915600`.
- `aim_ak-colt`: [map source](https://hl2go.com/downloads/cs1-6/maps/aim_/aim_ak-colt/), [archive](https://files.hl2go.com/downloads/cs1-6/maps/aim_/aim_ak-colt/?download=3711). BSP SHA-256: `17b445d1f4ec64e306b8cd1d1b90e44bfe1b57ebc6815e17198ce0a3d9da3866`.
- `awp_india`: [map source](https://hl2go.com/downloads/cs1-6/maps/awp_/awp_india/), [archive](https://files.hl2go.com/downloads/cs1-6/maps/awp_/awp_india/?download=7604). BSP SHA-256: `c3d2311d633ab68aaf3708c49778e923f5a43e2dc2631abf5d602c56f2f2156f`.

Preserve the bundled map credits in `maps/*.txt`. Only the BSP, credits,
overviews and explicit resource lists are deployed. The supplied `.nav` and
PODBot waypoint files are excluded because this server uses YaPB. Resource
lists contain only files shipped with each map; unrelated announcer sounds
and missing `maps/default.txt` entries from mirror archives are excluded.

YaPB navigation graphs are bundled separately in `files/bot_graphs/` from
[the official graph database](https://github.com/yapb/graph/tree/d15bdc9f36bd14c68a31a939df04f65c7febf9be/graph)
(commit `d15bdc9f36bd14c68a31a939df04f65c7febf9be`, Unlicense). They are installed on the game server only.
