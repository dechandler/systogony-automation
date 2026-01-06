"""



"""
import os
import re
import sys


from .cli import CliInterface

from ..api import TerraformApi

from ..exceptions import NoSuchEnvironmentError


class TerraformCli(CliInterface):


    def __init__(self, config):
        """
        In the main run of systogony, config is a custom class that
        gives a quasai-dict interface, but a normal dict can be passed
        in here. The following keys are needed:
        - tf_env_dir (str)
        - environments (dict of dicts)
        - default_env (str)

        """
        super().__init__(config)


        self.operations = {
            'generate': {
                'handler': self.generate,
                'help': "Generate terraform environment"
            },
            'init': {
                'handler': self.init,
                'help': "Run `terraform init` in the tfenv directory"
            },
            'plan': {
                'handler': self.plan,
                'help': "Run `terraform plan` in the tfenv directory"
            },
            'apply': {
                'handler': self.apply,
                'help': "Run `terraform apply` in the tfenv directory"
            },
            'destroy': {
                'handler': self.destroy,
                'help': "Run `terraform destroy` in the tfenv directory"
            }

        }
        self.no_args_operation = 'help'
        self.no_matching_args_operation = 'run'

    def _generic_tf_operation(self, operation, args):

        cmd = ["terraform", operation]
        cmd.extend(args)

        self.run_command(cmd, self.config['tf_env_dir'])


    def generate(self, args):
        api = TerraformApi(self.config)
        api.generate()


    def init(self, args):
        self._generic_tf_operation("init", args)

        
    def plan(self, args):
        self._generic_tf_operation("plan", args)


    def apply(self, args):
        self._generic_tf_operation("apply", args)

        
    def destroy(self, args):
        self._generic_tf_operation("destroy", args)
