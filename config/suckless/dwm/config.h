/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 2;
static const unsigned int snap      = 32;
static const unsigned int gappih    = 3;
static const unsigned int gappiv    = 3;
static const unsigned int gappoh    = 3;
static const unsigned int gappov    = 3;
static       int smartgaps          = 0;
static const int showbar            = 1;
static const int topbar             = 1;
static const char *fonts[] = { "JetBrainsMono Nerd Font Mono:style=Bold:size=16" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font Mono:style=Bold:size=16";

/* TokyoNight Colors */
static const char col_bg[]     = "#1a1b26";
static const char col_fg[]     = "#a9b1d6";
static const char col_blk[]    = "#32344a";
static const char col_red[]    = "#f7768e";
static const char col_grn[]    = "#9ece6a";
static const char col_ylw[]    = "#e0af68";
static const char col_blu[]    = "#7aa2f7";
static const char col_mag[]    = "#ad8ee6";
static const char col_cyn[]    = "#0db9d7";
static const char col_brblk[]  = "#444b6a";

static const char *colors[][3] = {
    [SchemeNorm] = { col_fg,    col_bg,    col_brblk },
    [SchemeSel]  = { col_cyn,   col_bg,    col_mag   },
};

static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
    { "Gimp", NULL, NULL, 0, 1, -1 },
    { "Google-chrome", NULL, NULL, 1 << 1, 0, -1 },
    { "Brave-browser", NULL, NULL, 1 << 1, 0, -1 },
    { "firefox", NULL, NULL, 1 << 2, 0, -1 },
    { "Slack", NULL, NULL, 1 << 3, 0, -1 },
    { "discord", NULL, NULL, 1 << 4, 0, -1 },
    { "kdenlive", NULL, NULL, 1 << 7, 0, -1 },
};

static const float mfact     = 0.55;
static const int nmaster     = 1;
static const int resizehints = 1;
static const int lockfullscreen = 1;

#define FORCE_VSPLIT 1
#include "vanitygaps.c"

static const Layout layouts[] = {
    { "󰝘", tile },
    { "", NULL },
    { "[M]", monocle },
    { "", spiral },
    { "[\\]", dwindle },
};

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
    &((Keychord){1, {{MODKEY, KEY}}, view, {.ui = 1 << TAG} }), \
    &((Keychord){1, {{MODKEY|ControlMask, KEY}}, toggleview, {.ui = 1 << TAG} }), \
    &((Keychord){1, {{MODKEY|ShiftMask, KEY}}, tag, {.ui = 1 << TAG} }), \
    &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, KEY}}, toggletag, {.ui = 1 << TAG} }),

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_fg, "-sb", col_cyn, "-sf", col_bg, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *slock[]    = { "slock", NULL };
static const char *screenshotcmd[] = { "/bin/sh", "-c", "maim -s | xclip -selection clipboard -t image/png", NULL };
static const char *rofi[]  = { "rofi", "-show", "drun", "-theme", "~/.config/rofi/config.rasi", NULL };

static const char *upvol[]   = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *downvol[] = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *mutevol[] = { "pactl", "set-sink-mute",   "@DEFAULT_SINK@", "toggle", NULL };
static const char *brup[]    = { "brightnessctl", "set", "+10%", NULL };
static const char *brdown[]  = { "brightnessctl", "set", "10%-", NULL };

static Keychord *keychords[] = {
    &((Keychord){1, {{MODKEY, XK_r}}, spawn, {.v = dmenucmd } }),
    &((Keychord){1, {{MODKEY, XK_Return}}, spawn, {.v = termcmd } }),
    &((Keychord){1, {{MODKEY, XK_l}}, spawn, {.v = slock } }),
    &((Keychord){1, {{ControlMask, XK_Print}}, spawn, {.v = screenshotcmd } }),
    &((Keychord){1, {{MODKEY, XK_d}}, spawn, {.v = rofi } }),

    &((Keychord){1, {{0, XF86XK_AudioMute}}, spawn, {.v = mutevol } }),
    &((Keychord){1, {{0, XF86XK_AudioLowerVolume}}, spawn, {.v = downvol } }),
    &((Keychord){1, {{0, XF86XK_AudioRaiseVolume}}, spawn, {.v = upvol } }),
    &((Keychord){1, {{0, XF86XK_MonBrightnessDown}}, spawn, {.v = brdown } }),
    &((Keychord){1, {{0, XF86XK_MonBrightnessUp}}, spawn, {.v = brup } }),

    &((Keychord){1, {{MODKEY, XK_b}}, togglebar, {0} }),
    &((Keychord){1, {{MODKEY, XK_j}}, focusstack, {.i = +1 } }),
    &((Keychord){1, {{MODKEY, XK_k}}, focusstack, {.i = -1 } }),
    &((Keychord){1, {{MODKEY, XK_i}}, incnmaster, {.i = +1 } }),
    &((Keychord){1, {{MODKEY, XK_p}}, incnmaster, {.i = -1 } }),
    &((Keychord){1, {{MODKEY, XK_g}}, setmfact, {.f = -0.05} }),
    &((Keychord){1, {{MODKEY, XK_h}}, setmfact, {.f = +0.05} }),
    &((Keychord){1, {{MODKEY, XK_z}}, incrgaps, {.i = +3 } }),
    &((Keychord){1, {{MODKEY, XK_x}}, incrgaps, {.i = -3 } }),
    &((Keychord){1, {{MODKEY, XK_a}}, togglegaps, {0} }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_a}}, defaultgaps, {0} }),
    &((Keychord){1, {{MODKEY, XK_Tab}}, view, {0} }),
    &((Keychord){1, {{MODKEY, XK_q}}, killclient, {0} }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_t}}, setlayout, {.v = &layouts[0]} }),
    &((Keychord){1, {{MODKEY, XK_m}}, setlayout, {.v = &layouts[2]} }),
    &((Keychord){1, {{MODKEY, XK_c}}, setlayout, {.v = &layouts[3]} }),
    &((Keychord){1, {{MODKEY, XK_o}}, setlayout, {.v = &layouts[4]} }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_Return}}, setlayout, {0} }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_f}}, fullscreen, {0} }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_space}}, togglefloating, {0} }),
    &((Keychord){1, {{MODKEY, XK_0}}, view, {.ui = ~0 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_0}}, tag, {.ui = ~0 } }),
    &((Keychord){1, {{MODKEY, XK_comma}}, focusmon, {.i = -1 } }),
    &((Keychord){1, {{MODKEY, XK_period}}, focusmon, {.i = +1 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_comma}}, tagmon, {.i = -1 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_period}}, tagmon, {.i = +1 } }),

    /* SCRIPT KEYCHORDS */
    &((Keychord){2, {{MODKEY, XK_f}, {0, XK_f}}, spawn, SHCMD("$HOME/nixos-dotfiles/scripts/rofi-menus/repos-dmenu.sh")}),
    &((Keychord){2, {{MODKEY, XK_f}, {0, XK_o}}, spawn, SHCMD("$HOME/nixos-dotfiles/scripts/rofi-menus/tmux-dmenu.sh")}),
    &((Keychord){2, {{MODKEY, XK_f}, {0, XK_b}}, spawn, SHCMD("$HOME/nixos-dotfiles/scripts/rofi-menus/bookmarks-dmenu.sh")}),

    TAGKEYS(XK_1, 0)
    TAGKEYS(XK_2, 1)
    TAGKEYS(XK_3, 2)
    TAGKEYS(XK_4, 3)
    TAGKEYS(XK_5, 4)
    TAGKEYS(XK_6, 5)
    TAGKEYS(XK_7, 6)
    TAGKEYS(XK_8, 7)
    TAGKEYS(XK_9, 8)

    &((Keychord){1, {{MODKEY|ShiftMask, XK_q}}, quit, {0} }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_r}}, quit, {1} }),
};

static const Button buttons[] = {
    { ClkLtSymbol, 0, Button1, setlayout, {0} },
    { ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]} },
    { ClkStatusText, 0, Button2, spawn, {.v = termcmd } },
    { ClkClientWin, MODKEY, Button1, movemouse, {0} },
    { ClkClientWin, MODKEY, Button2, togglefloating, {0} },
    { ClkClientWin, MODKEY, Button3, resizemouse, {0} },
    { ClkTagBar, 0, Button1, view, {0} },
    { ClkTagBar, 0, Button3, toggleview, {0} },
    { ClkTagBar, MODKEY, Button1, tag, {0} },
    { ClkTagBar, MODKEY, Button3, toggletag, {0} },
};
