"""

"""
import json
import logging
import os
import socket

from collections import defaultdict
from functools import cached_property

from jinja2 import Template

from .api import ApiInterface

from ..environment import Environment


class TerraformApi(ApiInterface):

    @property
    def template_data(self):
        """


        """
        cache = self.get_cache('terraform_template_data')
        if cache:
            return cache

        env = Environment(self.config)

        tmpl_vars = {'linode_systems': {}}
        tmpl_vars.update(env.config)
        tmpl_vars.update(env.vars)

        for host in env.hosts.values():
            if host.vars.get('platform') not in ['linode']:
                continue
            hvars = {'name': host.name}
            hvars.update(env.config)
            hvars.update(env.vars)
            hvars.update(host.vars)
            tmpl_vars['linode_systems'][host.name] = hvars


        self.write_cache(tmpl_vars, 'terraform_template_data')

        return tmpl_vars


    def generate(self):

        os.makedirs(self.config['tf_env_dir'], exist_ok=True)

        env = Environment(self.config)
        template_env = (
            env.vars.get('template_env')
            or self.config['env_name']
        )
        tf_env_template_dir = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            "../../terraform/templates",
            template_env
        ))

        self.log.debug(f"Attempting to load {tf_env_template_dir}")

        try:
            tmpl_files = os.listdir(tf_env_template_dir)
        except FileNotFoundError:
            NoSuchEnvironmentError(
                f"No terraform env template at {tf_env_template_dir}"
            )
            sys.exit(1)



        # tmpl_vars = {
        #     'authorized_key_name':
        #     'env_name'
        #     'cloud_hosts': {

        #     'keepass_db_path'
        # }
        #         [ {
        #             'name': host.name,
        #             'platform': "linode",
        #             'image': host.spec.get('image') or env.vars.get('linode_image'),
        #             'instance_type': host.spec.get('instance_type') or env.vars.get('linode')
        #             'region'
        #         }
        #             for host in env.hosts.values()
        #             if host.
        #         ]

        # tmpl_vars = self.template_data
        # tmpl_vars.update(self.config)
        # #tmpl_vars.update()

        for fname in tmpl_files:
            if os.path.splitext(fname)[1] not in [".tf", ".tfvars"]:
                continue
            src_path = os.path.join(tf_env_template_dir, fname)
            dest_path = os.path.join(self.config['tf_env_dir'], fname)
            with open(src_path) as fh:
                tmpl = Template(fh.read())



            # data = {
            #     'authorized_key_name':
            #     'env_name'
            #     'cloud_hosts': {
            #         [ {
            #             'name': host.name,
            #             'platform': "linode",
            #             'image': host.spec.get('image') or env.vars.get('linode_image'),
            #             'instance_type': host.spec.get('instance_type') or env.vars.get('linode')
            #             'region'
            #         }
            #             for host in env.hosts.values()
            #             if host.
            #         ]
            #     'keepass_db_path'

            out = tmpl.render(self.template_data)

            with open(dest_path, 'w') as fh:
                fh.write(out)
