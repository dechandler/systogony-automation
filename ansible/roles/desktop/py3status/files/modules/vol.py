#!/usr/bin/env python3

class Py3status:

    cache_timeout = 1
    device = "pulse"
    increment = 5
    _sink_num = None


    def main(self):

        cmd = f"pactl get-sink-mute {self.sink_num}"
        mute_raw = self.py3.command_output(cmd).split()[1]
        if mute_raw == "yes":
            return {
                'full_text':  "MUTE",
                'cache_timeout': self.cache_timeout
            }

        return {
            'full_text':  f"♪{self._get_vol()}",
            'cache_timeout': self.cache_timeout
        }

    @property
    def sink_num(self):

        if self._sink_num:
            return self._sink_num

        cmd = "pactl get-default-sink"
        sink_id = self.py3.command_output(cmd)

        cmd = "pactl list short sinks"
        lines = self.py3.command_output(cmd).splitlines()

        sinks = [ l.split() for l in lines ]

        try:
            self._sink_num = [
                sink[0]
                for sink in sinks
                if sink[1] == sink_id
            ][0]
        except IndexError:
            self._sink_num = "0"

        return self._sink_num

    def _is_muted(self):

        cmd = f"pactl get-sink-mute {self.sink_num}"
        mute_raw = self.py3.command_output(cmd).split()[1]

    def _get_vol(self):

        cmd = f"pactl get-sink-volume {self.sink_num}"
        vol_raw = self.py3.command_output(cmd).split()
        return vol_raw[4]

    def _toggle_mute(self):

        cmd = f"pactl set-sink-mute {self.sink_num} toggle"
        self.py3.command_run(cmd)


    def _set_volume(self, set_str):

        cmd = f"pactl set-sink-volume {self.sink_num} {set_str}"
        self.py3.command_run(cmd)


    def on_click(self, event):

        button = event['button']

        if button == 1:
            self._toggle_mute()
            #self.py3.command_run("amixer -D {} sset Master toggle".format(self.device))
        elif button == 3:
            self.py3.command_run("pavucontrol")
        elif button == 4:
            self._set_volume(f"+{self.increment}%")
            #self.py3.command_run("amixer -D {} sset Master {}%+ unmute".format(self.device, self.increment))
        elif button == 5:
            self._set_volume(f"-{self.increment}%")
            #self.py3.command_run("amixer -D {} sset Master {}%- unmute".format(self.device, self.increment))


if __name__ == "__main__":
    from py3status.module_test import module_test
    module_test(Py3status)
