"""


"""
import json
import logging
import os
import socket
import sys


from .cli import CliInterface

from ..api import AnsibleApi, TerraformApi


log = logging.getLogger("systogony")


class PrintCli(CliInterface):

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
            'ansible': {
                'aliases': [
                    'a', 'ans', 'abl',
                    '-l', '--list',
                    'inv', 'inventory'
                ],
                'handler': self.ansible_inventory
            },
            'terraform': {
                'aliases': ['tf'],
                'handler': self.terraform_data
            }
        }
        self.no_args_operation = 'ansible'
        self.no_matching_args_operation = 'help'


    def ansible_inventory(self, args):

        api = AnsibleApi(self.config)
        print(json.dumps(api.inventory, indent=4))

    def terraform_data(self, args):

        api = TerraformApi(self.config)
        print(json.dumps(api.template_data, indent=4))
