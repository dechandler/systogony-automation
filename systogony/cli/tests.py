"""


"""
import json
import os
import socket
import sys


from .cli import CliInterface

from ..api import TestsApi


class TestsCli(CliInterface):

    def __init__(self, config):
        """
        In the main run of systogony, config is a custom class that
        gives a quasai-dict interface, but a normal dict can be passed
        in here. The following keys are needed:
        - blueprint_path (str)
        - environments (dict of dicts)
        - default_env (str)

        """
        super().__init__(config)

        self.operations = {
            'all': {
                'handler': self.all_tests
            }
        }
        self.no_args_operation = 'all'
        self.no_matching_args_operation = 'help'

