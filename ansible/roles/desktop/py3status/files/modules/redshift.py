#!/usr/bin/env python3

#from utils import bounds

bounds = lambda val, mn, mx: mx if val > mx else mn if val < mn else val


class Py3status:

    cache_timeout = 1
    increment = 55

    initial_temp = 3700

    threshold_temp = 5000
    daylight_temp = 6000
    night_temp = 3700

    max_temp = 6500
    min_temp = 1000

    def __init__(self):
        self.temp = self.initial_temp
        self._wm = None


    @property
    def wm(self):

        if self._wm:
            return self._wm

        return "sway"


    def post_config_hook(self):

        self._set_temp(self.initial_temp)

    def main(self):

        percent = int((self.temp - 1000) / 55)
        return {
            'full_text':  "☀{}%".format(percent),
            'cache_timeout': self.cache_timeout,
            'color': self._get_color()
        }

    def on_click(self, event):

        button = event['button']

        if button == 1:
            if self.temp < self.threshold_temp:
                self._set_temp(self.daylight_temp)
            else:
                self._set_temp(self.night_temp)
        elif button == 4:
            self._set_temp(self.temp + self.increment)
        elif button == 5:
            self._set_temp(self.temp - self.increment)

    def _set_temp(self, temp):

        temp = bounds(temp, self.min_temp, self.max_temp)
        if self.wm == "sway":
            self.py3.command_run("busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q {}".format(temp))
        elif self.wm == "i3":
            self.py3.command_run("redshift -P -O {}".format(temp))
        self.temp = temp


    def _get_color(self):

        r = 255

        if self.temp > 5500:
            g = 255
            b = bounds(int((self.temp - 5500) / 4), 0, 255)
        else:
            b = 0
            g = bounds(int((self.temp - 3700) / 7), 0, 255)

        return "#{:02x}{:02x}{:02x}".format(r, g, b)


if __name__ == "__main__":
    from py3status.module_test import module_test
    module_test(Py3status)