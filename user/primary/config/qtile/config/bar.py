from libqtile import qtile, widget, bar
from libqtile.lazy import lazy
from font import font, windowname
from color import colors
from info import hardware
from layouts import MARGIN, BORDER_WIDTH
import os

CENTER_SPACERS = 100

fontinfo = dict(
    font=font["secondary"]["family"],
    padding=font["secondary"]["padding"],
    fontsize=font["secondary"]["fontsize"]
)

DEFAULT_FG = colors["base05"]
DEFAULT_BG = colors["base00"]
WIDTH=34

def launcher(qtile):
    lazy.spawn("sh " + os.path.expanduser("~/.local/bin/rofi-launchpad.sh"))
    

groupbox = [widget.GroupBox, {
                "font" : font["clear"]["family"],
                "padding" : font["clear"]["padding"],
                "fontsize" : font["clear"]["fontsize"],
                "foreground": colors["base03"],
                "highlight_method": "text",
                "block_highlight_text_color": DEFAULT_FG,
                "active": DEFAULT_FG,
                "inactive": colors["base03"],
                "rounded": False,
                "highlight_color": [DEFAULT_FG, colors["hialt0"]],
                "urgent_alert_method": "line",
                "urgent_text": colors["urgent"],
                "urgent_border": colors["urgent"],
                "disable_drag": True,
                "use_mouse_wheel": False,
                "hide_unused": False,
                "spacing": 5,
                "this_current_screen_border": colors["hialt0"],
            }
        ]

windowname = [widget.WindowName, {
                "font": windowname,
                "fontsize": 16,
                "padding": 3,
                "format": '{name}',
                "background": colors["base03"],
                "center_aligned": True
            }
        ]

systray = [widget.Systray, {
        "background": colors["ansi00"], # needs to always be dark
        "foreground": DEFAULT_FG,
        "theme_path": "rose-pine-gtk",
        }
    ]

spacer_small = [ widget.Spacer, {
        "length" : 14,
        # these values are used by style func, not qtile
        "is_spacer": True,
        "inheirit": True,
        "use_separator": False
    }
]

logo_image = [ widget.Image, {
        "background": colors["highlight"],
        "margin" : 6,
        "filename" : "~/.config/qtile/config/nixlogo-rosepine.png",
        "mouse_callbacks":{
            "Button1": launcher(qtile)
        },
    }
]

logo = [widget.TextBox, {
                # text="  ",
                "font" : font["clear"]["family"],
                "padding" : -2,
                "fontsize" : font["clear"]["fontsize"]*1.6,
                "text": " ",
                #"text": " Σ",
                "background": colors["highlight"],
                "foreground": colors["pfg-highlight"],
                "mouse_callbacks":{
                    "Button1": launcher(qtile)
                },
            }
        ]

cpu = [widget.CPU, {
                **fontinfo,
                "format": " {freq_current}GHz {load_percent}%",
                "background": colors["hialt0"],
                "foreground": colors["pfg-hialt0"]
            }
        ]

disk = [widget.DF, {
                **fontinfo,
                "partition": "/",
                "warn_color": colors["warn"],
                "warn_space":40,
                "visible_on_warn": False,
                "measure":"G",
                "format":"DISK: ({uf}{m}|{r:.0f}%)",
            }
        ]

net = [widget.Net, {
                **fontinfo,
                "format": "\u2193 {down} \u2191 {up}",
                "interface": "wlp0s20f3",
                "update_interval": 3,
                "background": colors["base03"]
            }
        ]

mem = [widget.Memory, {
                **fontinfo,
                "format": ": {MemUsed:.2f}/{MemTotal:.2f}{mm}",
                "update_interval": 1.0,
                "measure_mem": "G",
            }
        ]

batt = [widget.Battery, {
                **fontinfo,
                "background": colors["highlight"],
                "foreground": colors["pfg-highlight"],
                "low_foreground": colors["urgent"],
                "low_background": None,
                "low_percentage": 0.30,
                "charge_char": "",
                "discharge_char": "",
                "full_char": "",
                "empty_char": "X",
                "unknown_char": "?",
                "format": "  {char} {percent:2.0%}",
                "show_short_text": False,
            }
        ]

layout = [widget.CurrentLayout, {
                **fontinfo,
                "background": colors["base02"]
            }
        ]

date = [widget.Clock, {
                **fontinfo,
                "format": '%m/%d/%Y',
                "background": colors["base03"]
            }
        ]

time = [widget.Clock, {
                **fontinfo,
                "format": '%I:%M %p ',
                "background": colors["base04"],
            }
        ]

def widgetlist():
    widgets = [
        spacer_small,
        # logo,
        logo_image,
        groupbox,
        windowname,
        systray,
        cpu,
        (batt if hardware["hasBattery"] else None),
#        disk,
#        net,
        mem,
#        batt,
        layout,
        date,
        time,
    ]
    while None in widgets:
        widgets.remove(None)
    return widgets

def style(widgetlist):
    # adds separator widgets in between the initial widget list
    styled = widgetlist[:]
    
    for index, wid in enumerate(widgetlist): 
        end_sep = {
            "font": "Iosevka Nerd Font",
            "text": " ",
            "fontsize": WIDTH,
            "padding": -1
        }

        if index < len(widgetlist)-1:
            #end_sep["background"]=widgetlist[index+1][1].get("background", DEFAULT_BG)
            #end_sep["foreground"]=wid[1].get("background", DEFAULT_BG)

            end_sep["foreground"]=widgetlist[index+1][1].get("background", DEFAULT_BG)
            end_sep["background"]=wid[1].get("background", DEFAULT_BG)
            if wid[1].get("is_spacer") and wid[1].get("inheirit"):
                bg=widgetlist[index+1][1].get("background", DEFAULT_BG)
                wid[1]["background"] = bg
                end_sep["background"] = bg
            # insert separator before current
            if wid[1].get("use_separator", True):
                styled.insert(styled.index(wid)+1, (widget.TextBox, end_sep))
        
    return [w[0](**w[1]) for w in styled]

def my_bar():
    return bar.Bar(
        [
            *style(widgetlist())
        ],
        WIDTH,
        foreground=DEFAULT_FG,
        background=DEFAULT_BG,
        opacity=1.0,
        margin=[MARGIN, MARGIN, BORDER_WIDTH, MARGIN],

    )
