#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <engine>

#define PLUGIN "LenMail Classic+"
#define VERSION "1.0.0"
#define AUTHOR "OnkelDom"
#define TASK_WELCOME 4200

new Float:g_last_activity[33]
new g_last_origin[33][3]
new Float:g_last_angles[33][3]
new bool:g_initialized[33]
new g_spec_seconds
new g_kick_seconds

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    g_spec_seconds = register_cvar("classic_afk_spec_seconds", "90")
    g_kick_seconds = register_cvar("classic_afk_kick_seconds", "600")
    set_task(5.0, "check_afk_players", 0, "", 0, "b")
}

public client_putinserver(id)
{
    if (is_user_bot(id) || is_user_hltv(id))
        return

    reset_activity(id)
    set_task(8.0, "show_welcome", TASK_WELCOME + id)
}

public client_disconnected(id)
{
    remove_task(TASK_WELCOME + id)
    g_initialized[id] = false
}

public show_welcome(taskid)
{
    new id = taskid - TASK_WELCOME
    if (!is_user_connected(id))
        return

    client_print(id, print_chat, "[Classic+] Willkommen! 5on5-Bots, Rank und Mapvotes sind aktiv.")
    client_print(id, print_chat, "[Classic+] Befehle: rtv, nominate, /rank, /top15, timeleft, nextmap")
}

public check_afk_players()
{
    new players[32], count
    get_players(players, count, "ch")

    for (new i = 0; i < count; i++)
    {
        new id = players[i]
        if (player_is_active(id))
        {
            reset_activity(id)
            continue
        }

        new Float:idle = get_gametime() - g_last_activity[id]
        new kick_after = get_pcvar_num(g_kick_seconds)
        new spec_after = get_pcvar_num(g_spec_seconds)

        if (kick_after > 0 && idle >= float(kick_after))
        {
            client_print(0, print_chat, "[Classic+] %n wurde nach 10 Minuten AFK entfernt.", id)
            server_cmd("kick #%d ^"AFK seit 10 Minuten^"", get_user_userid(id))
            continue
        }

        new CsTeams:team = cs_get_user_team(id)
        if (spec_after > 0 && idle >= float(spec_after) && (team == CS_TEAM_T || team == CS_TEAM_CT))
        {
            if (is_user_alive(id))
                user_silentkill(id)
            cs_set_user_team(id, CS_TEAM_SPECTATOR)
            client_print(0, print_chat, "[Classic+] %n wurde wegen AFK zu Spectator verschoben.", id)
        }
    }
}

bool:player_is_active(id)
{
    new origin[3]
    new Float:angles[3]
    get_user_origin(id, origin)
    entity_get_vector(id, EV_VEC_v_angle, angles)

    if (!g_initialized[id])
        return true

    if (get_user_button(id) != 0)
        return true

    if (get_distance(origin, g_last_origin[id]) > 8)
        return true

    if (floatabs(angles[0] - g_last_angles[id][0]) > 2.0 ||
        floatabs(angles[1] - g_last_angles[id][1]) > 2.0)
        return true

    return false
}

reset_activity(id)
{
    g_last_activity[id] = get_gametime()
    get_user_origin(id, g_last_origin[id])
    entity_get_vector(id, EV_VEC_v_angle, g_last_angles[id])
    g_initialized[id] = true
}
