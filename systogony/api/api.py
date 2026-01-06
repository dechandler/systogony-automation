"""

"""
import json
import logging
import os
import socket

from collections import defaultdict
from functools import cached_property

from declib import DeclibApi

from ..environment import Environment


class ApiInterface(DeclibApi):

    def __init__(self, config):

        super().__init__(config)


    def get_cache(self, structure):

        if self.config['force_cache_regen'] or not self.config['use_cache']:
            self.log.debug(f"Skipping cache load, as configured")
            return None

        cache_path = os.path.join(
            self.config['blueprint_path'], f".cache-{structure}.json"
        )
        if not os.path.exists(cache_path):
            self.log.debug(f"No cache for {structure}, generating new")
            return False

        cache_timestamp = os.path.getmtime(cache_path)
        for root, dirs, files in os.walk(self.config['blueprint_path']):
            for fname in files:
                path = os.path.join(root, fname)
                if os.path.getmtime(path) > cache_timestamp:
                    self.log.debug(
                        f"Updated blueprint {fname}, "
                        + f"regenerating {structure} cache"
                    )
                    return False

        with open(cache_path) as fh:
            cache = fh.read()
        try:
            cache = json.loads(cache)
            self.log.info("No updates to blueprint, using cache")
        except json.decoder.JSONDecodeError:
            self.log.info("Cache failed to load, regenerating")
            return False

    def write_cache(self, data, structure):

        if not self.config['use_cache']:
            return None

        cache_path = os.path.join(
            self.config['blueprint_path'], f".cache-{structure}.json"
        )
        try:
            with open(cache_path, 'w') as fh:
                json.dump(data, fh, indent=4)
        except:
            return False

        self.log.info(f"Cache written to {cache_path}")
