"""

"""
import json
import os
import socket

from collections import defaultdict
from functools import cached_property

from .api import ApiInterface

from ..environment import Environment


class IntrospectionApi(ApiInterface):

    def __init__(self, config, partials=None):

        if not partials:
            partials = []

        self.partials = partials

        super().__init__(config)

        self.env = Environment(self.config)


    @property
    def introspection(self):

        out = {}
        for partial in self.partials:
            out[partial] = self.__getattribute__(partial)

        return out

    @property
    def networks(self):
        networks = []
        for net in self.env.networks.values():
            networks.append(net.introspect)
        return networks

    @property
    def hosts(self):
        hosts = []
        for host in self.env.hosts.values():
            hosts.append(host.introspect)
        return hosts


    @property
    def interfaces(self):
        interfaces = []
        for iface in self.env.interfaces.values():
            interfaces.append(iface.introspect)
        return interfaces
     

    @property
    def services(self):
        services = []
        for svc in self.env.services.values():
            services.append(svc.introspect)
        return services

    @property
    def service_instances(self):
        service_instances = []
        for inst in self.env.service_instances.values():
            service_instances.append(inst.introspect)
        return service_instances


    @property
    def acls(self):
        acls = []
        for acl in self.env.acls.values():
            acls.append(acl.introspect)
        return acls
