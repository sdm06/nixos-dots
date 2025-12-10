/* See LICENSE file for copyright and license details. */

/* --- APPEARANCE & BEHAVIOR --- */
static int surfuseragent    = 1;  /* Append Surf version to default WebKit user agent */
static char *fulluseragent  = ""; /* Or override the whole user agent string */
static char *scriptfile     = "~/.surf/script.js";
static char *styledir       = "~/.surf/styles/";
static char *certdir        = "~/.surf/certificates/";
static char *cachedir       = "~/.surf/cache/";
static char *cookiefile     = "~/.surf/cookies.txt";

/* Set Default Homepage to DuckDuckGo */
static char *homepage       = "https://duckduckgo.com";

/* Webkit default features */
static Parameter defconfig[ParameterLast] = {
    /* parameter                    Arg value       priority */
    [AccessMicrophone]    =       { { .i = 0 },     },
    [AccessWebcam]        =       { { .i = 0 },     },
    [Certificate]         =       { { .i = 0 },     },
    [CaretBrowsing]       =       { { .i = 0 },     },
    [CookiePolicies]      =       { { .v = "@Aa" }, },
    [DarkMode]            =       { { .i = 1 },     }, /* Default to Dark Mode */
    [DefaultCharset]      =       { { .v = "UTF-8" }, },
    [DiskCache]           =       { { .i = 1 },     },
    [DNSPrefetch]         =       { { .i = 0 },     },
    [Ephemeral]           =       { { .i = 0 },     },
    [FileURLsCrossAccess] =       { { .i = 0 },     },
    [FontSize]            =       { { .i = 14 },    }, /* Increased Font Size */
    [Geolocation]         =       { { .i = 0 },     },
    [HideBackground]      =       { { .i = 0 },     },
    [Inspector]           =       { { .i = 0 },     },
    [JavaScript]          =       { { .i = 1 },     },
    [KioskMode]           =       { { .i = 0 },     },
    [LoadImages]          =       { { .i = 1 },     },
    [MediaManualPlay]     =       { { .i = 1 },     },
    [PDFJSviewer]         =       { { .i = 0 },     },
    [PreferredLanguages]  =       { { .v = (char *[]){ NULL } }, },
    [RunInFullscreen]     =       { { .i = 0 },     },
    [ScrollBars]          =       { { .i = 0 },     }, /* Hide Scrollbars (Clean Look) */
    [ShowIndicators]      =       { { .i = 1 },     },
    [SiteQuirks]          =       { { .i = 1 },     },
    [SmoothScrolling]     =       { { .i = 1 },     }, /* Enable Smooth Scroll */
    [SpellChecking]       =       { { .i = 1 },     }, /* Enable Spellcheck */
    [SpellLanguages]      =       { { .v = ((char *[]){ "en_US", NULL }) }, },
    [StrictTLS]           =       { { .i = 1 },     },
    [Style]               =       { { .i = 1 },     },
    [WebGL]               =       { { .i = 1 },     }, /* Enable WebGL for maps/3D */
    [ZoomLevel]           =       { { .f = 1.0 },   }, 
};

static UriParameters uriparams[] = {
    { "(://|\\.)suckless\\.org(/|$)", {
      [JavaScript] = { { .i = 0 }, 1 },
    }, },
};

/* default window size: width, height */
static int winsize[] = { 1280, 720 };

static WebKitFindOptions findopts = WEBKIT_FIND_OPTIONS_CASE_INSENSITIVE |
                                    WEBKIT_FIND_OPTIONS_WRAP_AROUND;

/* --- CUSTOM COMMANDS --- */

/* 1. USE SURF-OPEN (SEARCH ENGINE SUPPORT) */
/* Replaces 'dmenu' with our smart script that handles searches */
#define PROMPT_GO   "surf-open -w $0"

#define PROMPT_FIND "Find:"

/* SETPROP macro (Standard) */
#define SETPROP(r, s, p) { \
        .v = (const char *[]){ "/bin/sh", "-c", \
             "prop=\"$(printf '%b' \"$(xprop -id $1 "r" " \
             "| sed -e 's/^"r"(UTF8_STRING) = \"\\(.*\\)\"/\\1/' " \
             "      -e 's/\\\\\\(.\\)/\\1/g')\" " \
             "| dmenu -p '"p"' -w $1)\" " \
             "&& xprop -id $1 -f "s" 8u -set "s" \"$prop\"", \
             "surf-setprop", winid, NULL \
        } \
}

/* DOWNLOAD (Uses st + curl) */
#define DOWNLOAD(u, r) { \
        .v = (const char *[]){ "st", "-e", "/bin/sh", "-c",\
             "curl -g -L -J -O -A \"$1\" -b \"$2\" -c \"$2\"" \
             " -e \"$3\" \"$4\"; read", \
             "surf-download", useragent, cookiefile, r, u, NULL \
        } \
}

/* PLUMB (Open external links in default app) */
#define PLUMB(u) {\
        .v = (const char *[]){ "/bin/sh", "-c", \
             "xdg-open \"$0\"", u, NULL \
        } \
}

/* VIDEOPLAY (Watch in MPV - force X11 mode to prevent crash) */
#define VIDEOPLAY(u) {\
        .v = (const char *[]){ "/bin/sh", "-c", \
             "mpv --force-window --ytdl-format='bestvideo[height<=1080]+bestaudio/best' \"$0\"", u, NULL \
        } \
}

/* styles */
static SiteSpecific styles[] = {
    /* regexp               file in $styledir */
    { ".*",                 "default.css" },
};

/* certificates */
static SiteSpecific certs[] = {
    /* regexp               file in $certdir */
    { "://suckless\\.org/", "suckless.org.crt" },
};

#define MODKEY GDK_CONTROL_MASK

/* --- KEY BINDINGS --- */
static Key keys[] = {
    /* modifier              keyval          function       arg */
    
    /* Ctrl+g: Open Search Bar (using surf-open) */
    { MODKEY,                GDK_KEY_g,      spawn,       SETPROP("_SURF_URI", "_SURF_GO", PROMPT_GO) },
    
    /* Find on page */
    { MODKEY,                GDK_KEY_f,      spawn,       SETPROP("_SURF_FIND", "_SURF_FIND", PROMPT_FIND) },
    { MODKEY,                GDK_KEY_slash,  spawn,       SETPROP("_SURF_FIND", "_SURF_FIND", PROMPT_FIND) },

    /* Navigation */
    { 0,                     GDK_KEY_Escape, stop,        { 0 } },
    { MODKEY,                GDK_KEY_c,      stop,        { 0 } },
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_r,      reload,      { .i = 1 } }, /* Hard Reload */
    { MODKEY,                GDK_KEY_r,      reload,      { .i = 0 } },
    { MODKEY,                GDK_KEY_l,      navigate,    { .i = +1 } }, /* Forward */
    { MODKEY,                GDK_KEY_h,      navigate,    { .i = -1 } }, /* Back */

    /* Vim Scrolling */
    { MODKEY,                GDK_KEY_j,      scrollv,     { .i = +10 } },
    { MODKEY,                GDK_KEY_k,      scrollv,     { .i = -10 } },
    { MODKEY,                GDK_KEY_space,  scrollv,     { .i = +50 } },
    { MODKEY,                GDK_KEY_b,      scrollv,     { .i = -50 } },
    { MODKEY,                GDK_KEY_i,      scrollh,     { .i = +10 } },
    { MODKEY,                GDK_KEY_u,      scrollh,     { .i = -10 } },

    /* Zoom */
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_j,      zoom,        { .i = -1 } },
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_k,      zoom,        { .i = +1 } },
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_q,      zoom,        { .i = 0  } },
    { MODKEY,                GDK_KEY_minus,  zoom,        { .i = -1 } },
    { MODKEY,                GDK_KEY_plus,   zoom,        { .i = +1 } },

    /* Clipboard */
    { MODKEY,                GDK_KEY_p,      clipboard,   { .i = 1 } }, /* Paste URL */
    { MODKEY,                GDK_KEY_y,      clipboard,   { .i = 0 } }, /* Copy URL */

    /* Search Next/Prev */
    { MODKEY,                GDK_KEY_n,      find,        { .i = +1 } },
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_n,      find,        { .i = -1 } },

    /* Toggles (Adblock, Images, JS) */
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_s,      toggle,      { .i = JavaScript } }, /* Nuclear Option */
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_i,      toggle,      { .i = LoadImages } },
    { MODKEY|GDK_SHIFT_MASK, GDK_KEY_m,      toggle,      { .i = Style } },      /* Toggle CSS */

    /* External Handlers */
    { MODKEY,                GDK_KEY_t,      showcert,    { 0 } },
    { 0,                     GDK_KEY_F11,    togglefullscreen, { 0 } },
};

static Button buttons[] = {
    /* target       event mask      button  function        argument        stop event */
    { OnLink,       0,              2,      clicknewwindow, { .i = 0 },     1 },
    { OnLink,       MODKEY,         2,      clicknewwindow, { .i = 1 },     1 },
    { OnLink,       MODKEY,         1,      clicknewwindow, { .i = 1 },     1 },
    { OnAny,        0,              8,      clicknavigate,  { .i = -1 },    1 },
    { OnAny,        0,              9,      clicknavigate,  { .i = +1 },    1 },
    /* Ctrl+Click Media -> Play in MPV */
    { OnMedia,      MODKEY,         1,      clickexternplayer, { 0 },       1 },
};;
