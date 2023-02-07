#!/bin/python

import asyncio
import signal

ntfy_command = ["ntfy", "subscribe", "ntfy.sh/ian_obsidian_notifs_x77bf"]

class Data:
    must_close = False

async def run():
    proc = await asyncio.create_subprocess_exec(ntfy_command, stdout=asyncio.subprocess.PIPE)

    while not Data.must_close:
        notif = await proc.stdout.read()
        print(f"NOTIFICATION RECIEVED: {notif}")

    proc.close()

# handle sigINT 
def signal_handler(sig, frame):
    Data.must_close = True
    print("SIGINT recieved, stop recieving notifications.")
signal.signal(signal.SIGINT, signal_handler)

# asynchronously handle notifications B)
asyncio.run(run())
