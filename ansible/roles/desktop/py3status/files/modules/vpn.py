#!/usr/bin/env python3

class Py3status:

    lock_icon = "\uf023"
    unlock_icon = "\uf09c"

    def main(self):

        active_conns = self.py3.command_output("nmcli connection show --active")
        vpn = None
        for conn in active_conns.splitlines():
            conn = conn.split()
            if conn[2] == "vpn":
                vpn = conn[0]
                break

        if vpn:
            color = "#00FF00"
            text = ' '.join([self.lock_icon, vpn])
        else:
            color = "#FF0000"
            text = ' '.join([self.unlock_icon, "VPN Down"])


        return {
            'full_text': text,
            'color': color
        }

    def on_click(self, event):

        button = event['button']

        if button == 1:  # Left Click
            self.py3.command_run("nm-dmenu VPN")
        elif button == 3:  # Right Click
            self.py3.command_run("nm-connection-editor")
 

if __name__ == "__main__":
    from py3status.module_test import module_test
    module_test(Py3status)