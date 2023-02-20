#!/bin/python

import subprocess
import signal
import json
import os

ntfy_command = ["ntfy", "subscribe"]

with open(os.path.expanduser("~/.config/ntfy_subscription")) as f:
    ntfy_command.append(f.readline())

def notify(notification_text: str):
    subprocess.Popen(["notify-send", notification_text])

class Data:
    must_close = False

# handle sigINT 
def signal_handler(sig, frame):
    Data.must_close = True
    print("SIGINT recieved, stop recieving notifications.")
signal.signal(signal.SIGINT, signal_handler)

def run():
    proc = subprocess.Popen(ntfy_command, stdout=subprocess.PIPE)

    while not Data.must_close:
        # get a non-empty string from stdout
        notif = proc.stdout.readline()
        if not notif:
            continue

        # parse that notification and send it to the user
        print(f"NOTIFICATION RECIEVED: {notif}")
        parsed = json.loads(notif)["message"]
        notify(f"NTFY: {parsed}")

    proc.terminate()

run()
