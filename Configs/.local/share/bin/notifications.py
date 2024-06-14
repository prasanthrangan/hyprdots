#!/usr/bin/python3

import subprocess
import json
import time
import sys

def get_dunst_history():
    result = subprocess.run(['dunstctl', 'history'], stdout=subprocess.PIPE)
    history = json.loads(result.stdout.decode('utf-8'))
    return history

def format_history(history):
    count = len(history['data'][0])
    alt = 'none'
    tooltip_click = []
    tooltip_click.append("󰎟 Notifications")
    tooltip_click.append("󰳽 click-left:  history pop")
    tooltip_click.append("󰳽 click-middle: 󰛌 clear history")
    tooltip_click.append("󰳽 click-right: 󱄊 close all")

    tooltip = []

    if count > 0:
        for notification in history['data'][0]:
            body = notification.get('body', {}).get('data', '')
            category = notification.get('category', {}).get('data', '')
            if category:
                alt = category + '-notification'
                tooltip.clear()
                tooltip.append(f"{body} ({category})\n ")
                break
            else:
                alt = 'notification'
                if not tooltip:
                    tooltip.append(f"{body}\n ")
    isDND = subprocess.run(['dunstctl', 'get-pause-level'], stdout=subprocess.PIPE)
    isDND = isDND.stdout.decode('utf-8').strip()
    if isDND != '0':
        alt = "dnd"
    formatted_history = {
        "text": str(count),
        "alt": alt,
        "tooltip": '\n '.join(tooltip_click) + '\n\n ' + '\n '.join(tooltip),
        "class": alt
    }
    return formatted_history

def main():
    # while True:
        history = get_dunst_history()
        formatted_history = format_history(history)
        sys.stdout.write(json.dumps(formatted_history) + '\n')
        sys.stdout.flush()
        # time.sleep(1)

if __name__ == "__main__":
    main()
