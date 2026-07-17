#include <amxmodx>

#define PLUGIN  "LenMail Fun Sounds"
#define VERSION "1.0.0"
#define AUTHOR  "OnkelDom"

new bool:g_first_blood
new g_kills[33]
new g_streak[33]
new Float:g_last_kill[33]

public plugin_precache()
{
    precache_sound("lenmail_classic/prepare.wav")
    precache_sound("lenmail_classic/firstblood.wav")
    precache_sound("lenmail_classic/headshot.wav")
    precache_sound("lenmail_classic/doublekill.wav")
    precache_sound("lenmail_classic/multikill.wav")
    precache_sound("lenmail_classic/killingspree.wav")
    precache_sound("lenmail_classic/unstoppable.wav")
    precache_sound("lenmail_classic/knifekill.wav")
    precache_sound("lenmail_classic/grenadekill.wav")
    precache_sound("radio/bombpl.wav")
    precache_sound("radio/bombdef.wav")
    precache_sound("buttons/bell1.wav")
    precache_sound("fvox/danger.wav")
}

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_event("HLTV", "event_round_start", "a", "1=0", "2=0")
    register_event("DeathMsg", "event_death", "a")
    register_logevent("event_bomb_planted", 3, "2=Planted_The_Bomb")
    register_logevent("event_bomb_defused", 3, "2=Defused_The_Bomb")
    register_clcmd("say /soundtest", "cmd_soundtest")
    register_clcmd("say_team /soundtest", "cmd_soundtest")
}

public event_round_start()
{
    g_first_blood = true
    for (new id = 1; id <= 32; id++)
    {
        g_kills[id] = 0
        g_streak[id] = 0
        g_last_kill[id] = 0.0
    }

    play_global("lenmail_classic/prepare.wav")
}

public event_death()
{
    new killer = read_data(1)
    new victim = read_data(2)
    new headshot = read_data(3)
    new weapon[24]
    read_data(4, weapon, charsmax(weapon))

    if (killer <= 0 || killer == victim)
        return

    new killer_name[32]
    get_user_name(killer, killer_name, charsmax(killer_name))

    g_streak[victim] = 0
    g_streak[killer]++

    if (g_first_blood)
    {
        g_first_blood = false
        announce("FIRST BLOOD!  %s", killer_name)
        play_global("lenmail_classic/firstblood.wav")
    }

    if (headshot)
    {
        announce("HEADSHOT!  %s", killer_name)
        play_global("lenmail_classic/headshot.wav")
    }

    if (equal(weapon, "knife"))
    {
        announce("KNIFE KILL!  %s", killer_name)
        play_global("lenmail_classic/knifekill.wav")
    }
    else if (equal(weapon, "grenade"))
    {
        announce("GRENADE KILL!  %s", killer_name)
        play_global("lenmail_classic/grenadekill.wav")
    }

    new Float:now = get_gametime()
    g_kills[killer] = (now - g_last_kill[killer] <= 4.0) ? g_kills[killer] + 1 : 1
    g_last_kill[killer] = now

    if (g_kills[killer] == 2)
    {
        announce("DOUBLE KILL!  %s", killer_name)
        play_global("lenmail_classic/doublekill.wav")
    }
    else if (g_kills[killer] >= 3)
    {
        announce("MULTI KILL!  %s", killer_name)
        play_global("lenmail_classic/multikill.wav")
    }

    if (g_streak[killer] == 3)
    {
        announce("KILLING SPREE!  %s", killer_name)
        play_global("lenmail_classic/killingspree.wav")
    }
    else if (g_streak[killer] == 5)
    {
        announce("UNSTOPPABLE!  %s", killer_name)
        play_global("lenmail_classic/unstoppable.wav")
    }
}

public event_bomb_planted()
{
    announce("THE BOMB HAS BEEN PLANTED!")
    play_global("radio/bombpl.wav")
}

public event_bomb_defused()
{
    announce("THE BOMB HAS BEEN DEFUSED!")
    play_global("radio/bombdef.wav")
}

public cmd_soundtest(id)
{
    play_global("lenmail_classic/headshot.wav")
    client_print(id, print_chat, "[Fun Sounds] Global sound test played")
    return PLUGIN_HANDLED
}

stock play_global(const sample[])
{
    emit_sound(0, CHAN_AUTO, sample, VOL_NORM, ATTN_NONE, 0, PITCH_NORM)
}

stock announce(const message[], any:...)
{
    new text[192]
    vformat(text, charsmax(text), message, 2)
    set_hudmessage(255, 120, 20, -1.0, 0.28, 1, 0.1, 2.5, 0.1, 0.2, -1)
    show_hudmessage(0, "%s", text)
}
