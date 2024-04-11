#!/usr/bin/env python3

import json
import os
import sys
import time
from socket import timeout  # exception

import i3ipc

import i3
from jinja2 import Template

template = Template(''.join([
"<span color='#00ffff'><sub>",
"{{ available | join(',') }} ",
"</sub></span>",
"<span size='smaller'>",
"{% for output in outputs %}",
"<big><span color='#aa00dd'>[ </span></big>",
  "{% for ws in output %}",
    "<span color='{{ '#ff0000' if ws.urgent else '#00ffff' }}'><sub>",
    "{{ ws.num }} ",
    "</sub></span>",
    "{% if ws.urgent  %}<span color='#ff0000'>{% endif %}",
    "{{ ws.labels | join(' ') }}",
    "{% if ws.urgent %}</span>{% endif %}",
    "{% if not loop.last %} | {% endif %}",
    "{% endfor %}",
  "<big><span color='#aa00dd'> ]</span></big>",
"{% endfor %}",
"</span>"
]))

class Py3status:

    output_file = os.path.join(os.environ['HOME'], "shm/.workspaces.pango")

    cache_timeout = 1

    #def post_config_hook(self):
    #    self.cache_timeout = self.py3.CACHE_FOREVER

    def main(self):
        try:
            with open(self.output_file) as fh:
                output = fh.read().strip()
        except:
            output = ""


        return {
            'full_text':  output,
            'cache_timeout': self.cache_timeout,
            'markup': "pango"
        }

    def on_click(self, event):

        button = event['button']

#class MyPy3status:
class WorkspacesDaemon:

    cache_timeout = 1

    #def post_config_hook(self):
    def __init__(self):

        self.iii = i3ipc.Connection()
        self._subscribe()
        self.iii.event_socket_setup()
        self.iii.sub_socket.settimeout(0.02)

        ws = Workspaces(["eDP-1"])

        self.return_data = {
            'full_text': str(ws),
            'cache_timeout': self.cache_timeout,
            'markup': "pango"
        }
        with open("/home/david/shm/log", "w") as fh:
            fh.write("")
        with open("/home/david/shm/event-log", 'w') as fh:
            fh.write("")

    def main(self):

        if not self._has_new_event():
            return self.return_data

        ws = Workspaces(["eDP1"])

        self.x += 1
        self.return_data['full_text'] = str(self.x)#str(ws)

        with open("/home/david/shm/log", 'a') as fh:
            fh.write(str(self.return_data) + "\n\n")

        return self.return_data

    #def on_click(self, event):

    #    button = event['button']


    def _has_new_event(self):
        events = []
        try:
            events.append(self.iii._ipc_recv(self.iii.sub_socket))
        except timeout:
            return False

        try:
            while True:
                events.append(self.iii._ipc_recv(self.iii.sub_socket))
        except timeout:
            pass

        with open("/home/david/shm/event-log", 'a') as fh:
            fh.write("\n\n")
            fh.write('\n'.join(str(e) for e in events))

        return True

    def _subscribe(self):
        #self.iii.on('workspace::empty', lambda _:_)
        self.iii.on('workspace', lambda _:_)
        self.iii.on('window', lambda _:_)
        #self.iii.on('workspace::urgent', lambda _:_)
        #self.iii.on('window::new', lambda _:_)
        #self.iii.on('window::close', lambda _:_)


class Workspaces(object):

    def __str__(self):
        return template.render(outputs=self.outputs, available=self.available)

    def __init__(self, outputs):

        tree = i3.get_tree()
        output_order = outputs

        output_map = {
            x['name']: self.get_workspaces(x)
            for x in tree['nodes']
        }
        self.outputs = [
            output_map[o]
            for o in output_order
        ]

        ws_nums = []
        for output in self.outputs:
            for workspace in output:
                ws_nums.append(workspace['num'])
                for window in workspace['windows']:
                    window['label'] = self.get_win_label(window)
                self.set_ws_attrs(workspace)

        self.available = [ num for num in range(1,9) if num not in ws_nums ]

    def get_workspaces(self, output):

        def flatten(container):
            """
            Digs through containers to return a flat list of windows

            """
            if not container['nodes']:
                return [container]
            else:
                windows = []
                for pane in container['nodes']:
                    pane_windows = flatten(pane)
                    windows.extend( pane_windows )
                return windows

        content = [ x for x in output['nodes'] if x['name'] == "content" ][0]
        workspaces = content['nodes']

        return [
            {
                'windows': flatten(workspace),
                'num': workspace['num']
            }
            for workspace in workspaces
        ]

    def get_win_label(self, window):

        try:
            win_class = window['window_properties']['class']
            win_instance = window['window_properties']['instance']
        except KeyError:
            return ""

        multi_subs = [  # if win_class in [0], return [1]
            [["Pidgin"], "\uf075 "],  # fa-comment
            [["Sublime_text", "Atom"], "\uf044"],  # fa-pencil-square-o # \uf121 fa-code
            [["Firefox", "firefox"], "\uf269 "],  # fa-firefox
            [["oogle-chrome", "hromium-browser"], "\uf268"],  # fa-chrome
            [["libreoffice-calc"], "\uf0ce "],  # fa-table
            [["libreoffice-writer"], "\uf036 "],  # fa-align-left
            [["Virt-manager"], "\uf24d "],  # fa-clone
            [["Inkscape"], "\uf248 "],  # fa-object-ungroup
            [["Steam"], "\uf1b6"],  # fa-steam
            [["load-RazorSQL"], "\uf1c0 "],  # fa-database
            [["xfreerdp"], "\uf26c "],  # fa-television
            [["Totem"], "\uf16a "], # fa-youtube-play
            [["Nautilus", "Thunar"], "\uf115 "],  # fa-folder-open-o
            [["Eog"], "\uf03e"],  # fa-picture
            [["Evince"], "\uf1c1"],  # fa-file-pdf-o
            [["Quodlibet", "Rhythmbox"], "♪"],
            [["X-terminal-emulator", "Terminator"], "~$"],
            [["KeePass2", "Keepassx2"], "\uf084"],  # fa-key
            [["Spotify"], "\uf1bc"],  # fa-spotify
            [["Minecraft"], "\uf1b3 "],  # fa-cubes
            [["obsidian"], "\uf044"], # fa-pencil-square-o # \uf121 fa-code
        ]
        for sub in multi_subs:
            for substr in sub[0]:
                if substr in win_class:
                    return sub[1]

        if (   win_class     == "processing-app-Base" and
               win_instances == "sun-awt-X11-XFramePeer" ):
            return "Arduino"

        return win_class

    def set_ws_attrs(self, workspace):
        """
        """
        uniq_labels = []
        for l in [ win['label'] for win in workspace['windows'] ]:
            if l not in uniq_labels:
                uniq_labels.append(l)

        workspace.update({
            'labels': uniq_labels,
            'urgent': any([ w['urgent'] for w in workspace['windows'] ]),
            'focused': any([ w['focused'] for w in workspace['windows'] ])
        })


if __name__ == "__main__":


    if sys.argv[1] == "daemon":
        # TODO
        pass
    elif sys.argv[1] == "update":
        output = str(Workspaces(sys.argv[2:]))

        f = os.path.join(os.environ['HOME'], "shm/.workspaces.pango")
        with open(f, 'w') as fh:
            fh.write(output)

    elif sys.argv[1] == "py3status-test":
        from py3status.module_test import module_test
        module_test(Py3status)
    else:
        output = [
            "Usage:",
            "  Update ~/shm/.workspaces.pango",
            "    ~$ workspaces.py update [monitors, space-delimited]",
            "    Example:",
            "      ~$ workspaces.py update DVI-I-1-1 DVI-I-2-2 eDP-1",
            "  Test Py3status module",
            "    ~$ workspaces.py py3status-test",
        ]
        print('\n'.join(output))