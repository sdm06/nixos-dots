from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
import subprocess

# --- AUTOSTART HOOK ---
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    # Start Notification Daemon
    subprocess.Popen(["dunst"])
    # Start Network Manager Applet (System Tray)
    subprocess.Popen(["nm-applet"])
    # Optional: Run your custom shell script if you have one
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])

mod = "mod4"
terminal = guess_terminal()
myTerm = "alacritty" 

# Variable for HOME to use in paths below
home = os.path.expanduser('~')

keys = [
    # --- WINDOW FOCUS ---
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # --- WINDOW MOVEMENT ---
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # --- WINDOW RESIZING ---
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # --- CLIPBOARD (Greenclip) ---
    Key([mod], "v", lazy.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'")),
    
    # --- DMENU ---
    Key([mod], "p", lazy.spawn("dmenu_run -fn 'JetBrainsMono Nerd Font-14' -nb '#1a1b26' -nf '#a9b1d6' -sb '#7aa2f7' -sf '#1a1b26'")),

    # --- ROFI MENUS ---
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons"), desc='Run Launcher'),

    # --- SYSTEM / LAYOUT ---
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle split"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    
    # Power Menu
    Key(
        [mod, "shift"], "q", 
        lazy.spawn(os.path.expanduser("~/nixos-dotfiles/scripts/powermenu.sh")),
        desc="Open Power Menu"
    ),

    # --- SCREENSHOT ---
    Key([mod], "s", lazy.spawn("sh -c 'maim -s -u | xclip -selection clipboard -t image/png -i'"), desc="Screenshot to clipboard"),

    # --- OSD CONTROLS (Brightness) ---
    # Screen Brightness (XF86 + F1/F2 fallback)
    Key([], "XF86MonBrightnessUp", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness screen up")),
    Key([], "XF86MonBrightnessDown", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness screen down")),
    Key([], "F2", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness screen up")),
    Key([], "F1", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness screen down")),

    # Keyboard Brightness (XF86 + F5/F6 fallback)
    Key([], "XF86KbdBrightnessUp", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness kbd up")),
    Key([], "XF86KbdBrightnessDown", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness kbd down")),
    Key([], "F6", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness kbd up")),
    Key([], "F5", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-brightness kbd down")),
    
    # --- AUDIO CONTROLS (Volume) ---
    # Calls the 'osd-volume' script we just created
    Key([], "XF86AudioMute", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-volume mute")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-volume down")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-volume up")),
    # F-Key Fallbacks for Volume (F10/F11/F12)
    Key([], "F10", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-volume mute")),
    Key([], "F11", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-volume down")),
    Key([], "F12", lazy.spawn(home + "/nixos-dotfiles/scripts/osd-volume up")),
]

# Wayland VT switching (Optional)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc=f"Move window to group {i.name}"),
    ])

colors = [
    ["#1a1b26", "#1a1b26"],  # bg
    ["#a9b1d6", "#a9b1d6"],  # fg
    ["#32344a", "#32344a"],  # color01
    ["#f7768e", "#f7768e"],  # color02
    ["#9ece6a", "#9ece6a"],  # color03
    ["#e0af68", "#e0af68"],  # color04
    ["#7aa2f7", "#7aa2f7"],  # color05
    ["#ad8ee6", "#ad8ee6"],  # color06
    ["#0db9d7", "#0db9d7"],  # color15
    ["#444b6a", "#444b6a"]   # color[9]
]

layout_theme = {
    "border_width" : 1,
    "margin" : 1,
    "border_focus" : colors[6],
    "border_normal" : colors[0],
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(),
    layout.MonadTall(**layout_theme),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font Propo Bold",
    fontsize=16,
    padding=0,
    background=colors[0],
)
extension_defaults = widget_defaults.copy()

sep = widget.Sep(linewidth=1, padding=8, foreground=colors[9])

screens = [
    Screen(
        top=bar.Bar(
            widgets = [
                widget.Prompt(
                    font = "Ubuntu Mono",
                    fontsize = 20,
                    foreground = colors[1]
                ),
                widget.GroupBox(
                    fontsize = 22,
                    margin_y = 5,
                    margin_x = 5,
                    padding_y = 0,
                    padding_x = 2,
                    borderwidth = 3,
                    active = colors[8],
                    inactive = colors[9],
                    rounded = False,
                    highlight_color = colors[0],
                    highlight_method = "line",
                    this_current_screen_border = colors[7],
                    this_screen_border = colors [4],
                    other_current_screen_border = colors[7],
                    other_screen_border = colors[4],
                ),
                widget.TextBox(text='|', font="JetBrainsMono Nerd Font Propo Bold", foreground=colors[9], padding=2, fontsize=20),
                widget.CurrentLayout(foreground=colors[1], padding=5, fontsize=20),
                widget.TextBox(text='|', font="JetBrainsMono Nerd Font Propo Bold", foreground=colors[9], padding=2, fontsize=20),
                widget.WindowName(foreground=colors[6], padding=8, max_chars=40, fontsize=20),
                
                # --- WIDGETS WITH CALLBACKS (FIXED) ---
                widget.GenPollText(
                    update_interval=300, 
                    func=lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True), 
                    foreground=colors[3], padding=8, fmt='{}', fontsize=20
                ),
                sep,
                widget.CPU(
                    foreground=colors[4], padding=8, 
                    # Fixed: Use qtile.spawn instead of qtile.cmd_spawn
                    mouse_callbacks={'Button1': lambda: qtile.spawn(myTerm + ' -e btop')}, 
                    format="CPU: {load_percent}%", fontsize=20
                ),
                sep,
                widget.Memory(
                    foreground=colors[8], padding=8, 
                    mouse_callbacks={'Button1': lambda: qtile.spawn(myTerm + ' -e btop')}, 
                    format='Mem: {MemUsed:.0f}{mm}', fontsize=20
                ),
                sep,
                # DISK WIDGET (Click for Notification)
                widget.DF(
                    update_interval=60, foreground=colors[5], padding=8, 
                    # Fixed callback
                    mouse_callbacks={'Button1': lambda: qtile.spawn(home + '/nixos-dotfiles/scripts/notify-disk')}, 
                    partition='/', format='{uf}{m} free', fmt='Disk: {}', visible_on_warn=False, fontsize=20
                ),
                sep,
               widget.Battery(
                    foreground=colors[6], padding=8, update_interval=5, 
                    format='{percent:2.0%} {char} {hour:d}:{min:02d}', fmt='Bat: {}', 
                    charge_char='', discharge_char='', full_char='✔', unknown_char='?', empty_char='!', 
                    mouse_callbacks={'Button1': lambda: qtile.spawn(home + "/nixos-dotfiles/scripts/notify-battery")}, 
                    fontsize=20
                ),                sep,
                # VOLUME WIDGET (Uses PulseAudio)
                widget.PulseVolume(foreground=colors[7], padding=8, fmt='Vol: {}', fontsize=20, limit_max_volume=True),
                sep,
                # CLOCK WIDGET (Click for Calendar Notification)
                widget.Clock(
                    foreground=colors[8], padding=8, 
                    # Fixed callback
                    mouse_callbacks={'Button1': lambda: qtile.spawn(home + '/nixos-dotfiles/scripts/notify-date')}, 
                    format="%a, %b %d - %H:%M", fontsize=20
                ),
                widget.Systray(padding=6, icon_size=24),
                widget.Spacer(length=8),
            ],
            margin=[0, 0, 0, 0],
            size=42 
        ),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
