# -*- coding: utf-8 -*-

from __future__ import absolute_import

import tenjin
from tenjin.helpers import to_str, escape

from .validator import CfdiValidator
from .schema import SchemaConstructor

from collections import namedtuple
import json
import logging
import os
import sys

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


class CfdiDocumentNotValid(Exception):
    pass


class CfdiNode:
    '''
    '''
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)
        for k, v in self.__dict__.items():
            if isinstance(v, dict):
                setattr(self, k, CfdiNode(**v))
            if isinstance(v, list):
                setattr(self, k, [CfdiNode(**i) for i in v])

    @staticmethod
    def _as_dict(obj):
        if not hasattr(obj, '__dict__'):
            return obj
        result = {}
        for k, v in obj.__dict__.items():
            if k.startswith('_'):
                continue
            element = []
            if isinstance(v, list):
                for item in v:
                    element.append(CfdiNode._as_dict(item))
            else:
                element = CfdiNode._as_dict(v)
            result[k] = element
        return result

    def as_dict(self):
        return CfdiNode._as_dict(self)

    def get_attr(self, attr):
        if hasattr(self, attr):
            return ' {}="{}"'.format(attr, getattr(self, attr))
        return ''

    def print_attributes(self):
        output = ''
        for k, v in self.as_dict().items():
            if type(v) not in (dict, list):
                output += '{}="{}" '.format(k, v)
        return output.strip()


class Cfdi(object):
    '''
    '''

    def __init__(self, document={}, version='3.2', *args, **kwargs):
        self.document = document
        self.version = version
        self.schema = SchemaConstructor.get_schema(self.version)
        self.validator = CfdiValidator()

    def _validate(self):
        self.validator.validate(self.document, self.schema)
        normalized_document = self.validator.normalized(self.document, self.schema)
        return self.validator.errors, normalized_document

    def is_valid(self):
        self.errors, self.normalized_document = self._validate()
        return not bool(self.errors)

    def _as_node_object(self):
        if self.is_valid():
            return CfdiNode(**self.normalized_document)
        else:
            log.exception("CFDI Document not valid. Errors: \"{}\".".format(self.errors))
            raise CfdiDocumentNotValid

    def as_xml(self):
        root_node = self._as_node_object()
        context = {'Comprobante': root_node.Comprobante}
        engine = tenjin.Engine()
        path = os.path.dirname(__file__)
        template_name = 'templates/cfdi_{}.xml.tpl'.format(self.version.replace('.', '_'))
        template_path = os.path.join(path, template_name)
        return engine.render(template_path, context)
