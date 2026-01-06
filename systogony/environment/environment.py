
import json
import logging
import os

from functools import cached_property

import yaml

from .query import ResourceShorthandQuery
from .blueprint import Blueprint

from ..resource import Acl

# from ..exceptions import (
#     # BlueprintLoaderError,
#     # NonMatchingPathSignal,
#     # MissingServiceError,
#     # NotReadySignal
# )


log = logging.getLogger("systogony")


class Environment:

    def __init__(self, config):

        self.config = config

        self.query = ResourceShorthandQuery(self)

        (
            self.names,
            self.hosts, self.host_groups,
            self.networks, self.interfaces,
            self.services, self.service_instances,
            self.acls,
        ) = {}, {}, {}, {}, {}, {}, {}, {}

        self.blueprint = Blueprint(self)
        self.blueprint.populate_env_hosts()
        self.blueprint.populate_env_networks()
        self.blueprint.populate_env_interfaces()
        self.blueprint.populate_env_services()
        self.blueprint.populate_env_service_instances()
        self.blueprint.populate_env_acls()

        self.vars = self.blueprint['vars']



    @property
    def resources(self):

        return {
            **self.networks,
            **self.hosts,
            **self.interfaces,
            **self.services,
            **self.service_instances,
            **self.acls
        }

    @property
    def introspect(self):

        return {
            'networks': [ r.introspect for r in self.networks.values() ],
            'hosts': [ r.introspect for r in self.hosts.values() ],
            'interfaces': [ r.introspect for r in self.interfaces.values() ],
            'services': [ r.introspect for r in self.services.values() ],
            'service_instances': [ r.introspect for r in self.service_instances.values() ],
            'acls': [ r.introspect for r in self.acls.values() ],
        }

    def register(self, resource):

        if resource.name not in self.names:
            self.names[resource.name] = []
        self.names[resource.name].append(resource)
        #self.resources[resource.fqn] = resource
        registries = {
            'host': self.hosts,
            'interface': self.interfaces,
            'network': self.networks,
            'service': self.services,
            'service_instance': self.service_instances,
            'acl': self.acls
        }
        registries[resource.resource_type][resource.fqn] = resource


    def gen_acl(self, origin, acl_spec, sources, destinations):
        """


        Called from Resource._gen_acls_by_spec_type

        """
        Acl(self, origin, acl_spec, sources, destinations)
