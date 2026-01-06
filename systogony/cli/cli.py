"""


"""
import re
import sys

from subprocess import Popen, PIPE

from declib import DeclibCli


class CliInterface(DeclibCli):

    def __init__(self, config):

        super().__init__(config)


    def extra_arg_checks(self, args):
        """
        CLI arg checks specific to Systogony

        Returns modified args and handler

        """
        args, op_name, handler = self._arg_check_env_name(args)

        return args, op_name, handler

    def _arg_check_env_name(self, args):
        """
        If the first arg matches an environment name,
        update config with the env config, then set
        handler to rerun this stage

        Returns modified args and handler

        """
        op_name, handler = None, None
        if args[0] in self.config['environments']:
            env_name = args.pop(0)
            self.log.debug(f"Recognized environment name ({env_name})")
            self.config.update(self.config['environments'][env_name])
            self.config['env_name'] = env_name
            handler = self.__class__(self.config).handle_args
            op_name = "environment"

        return args, op_name, handler

