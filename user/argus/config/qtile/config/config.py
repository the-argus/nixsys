# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401
import os
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
#from libqtile.utils import guess_terminal

from color import colors
from font import font
from layouts import custom_layouts, floating
from bar import my_bar

mod = "mod4"
#terminal = guess_terminal()
terminal = "alacritty"

float_types = [
        "dialog"
    ]

float_names = [
        "Calculator",
        "Bluetooth Devices",
        "Network Connections",
        "Color Picker",
        "Steam Guard - Computer Authorization Required"
        ]

#@hook.subscribe.client_new
#def float_to_front(qtile):
#    """
#    Bring all floating windows of the group to front
#    """
#    for window in qtile.currentGroup.windows:
#        if window.floating:
#            window.cmd_bring_to_front()

@hook.subscribe.client_new
def browser(c):
    if c.window.get_wm_class() == ('chromium', 'Chromium'):
       c.togroup(c.qtile.current_group.name)

@hook.subscribe.float_change
@hook.subscribe.client_new
@hook.subscribe.client_focus
def set_hint(window):
    window.window.set_property("QTILE_FLOATING", str(window.floating), type="STRING", format=8)

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.run([home])

@hook.subscribe.client_new
def dialogs(window):
    """Floating dialog"""
    if window.name in float_names or window.window.get_wm_type() in float_types or window.window.get_wm_transient_for():
        window.floating = True

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "mod1"], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    
    Key([], "XF86Calculator", lazy.spawn("gnome-calculator"), desc="Open calculator"), 

    # scripts
    Key([mod], "space", lazy.spawn("sh " + os.path.expanduser("~/.local/bin/rofi-launchpad.sh")), desc="Rofi"), 
    Key([mod], "p", lazy.spawn("sh " + os.path.expanduser("~/.scripts/rofi-powermenu.sh")), desc="Powermenu"),

    Key([], "XF86AudioMute", lazy.spawn("sh " + os.path.expanduser("~/.local/bin/volume.sh mute")), desc="Mute volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("sh " + os.path.expanduser("~/.local/bin/volume.sh down")), desc="Lower volume"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("sh " + os.path.expanduser("~/.local/bin/volume.sh up")), desc="Raise volume"),

    Key([], "XF86MonBrightnessUp", lazy.spawn("sh " + os.path.expanduser("~/.scripts/backlight/increase.sh")), desc="Increase brightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("sh " + os.path.expanduser("~/.scripts/backlight/decrease.sh")), desc="Decrease brightness"),

    Key([], "Print", lazy.spawn("sh " + os.path.expanduser("~/.scripts/take-screenshot.sh")), desc="Take a screenshot"),

    Key([mod], "c", lazy.spawn("clipcat-menu"), desc="Open clipboard manager"),
    
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod, "shift"], "space", lazy.window.toggle_floating(), desc="Toggle floating"),


    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "p", lazy.shutdown(), desc="Shutdown Qtile"),
#    Key([mod], "r", lazy.spawncmd(),
#        desc="Spawn a command using a prompt widget"),
]

#groups = [ Group(f"{i+1}", label="♥") for i in range(5)]
groups = [ Group(f"{i+1}", label="") for i in range(5)]

#  groups = [
    #  Group("1", label=""),
    #  Group("2", label=""),
    #  Group("3", label=""),
    #  #  Group(
        #  #  "3",
        #  #  label="",
        #  #  matches=[
            #  #  Match(wm_class=["zoom"]),
        #  #  ],
    #  #  ),
    #  Group("4", label=""),
    #  Group("5", label="")
#  ]


for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = custom_layouts
floating_layout = floating

widget_defaults = dict(
    **font["clear"],
)

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=my_bar()
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False

#wmname = "LG3D"
wmname = "qtile"
