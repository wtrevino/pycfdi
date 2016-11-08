# -*- coding: utf-8 -*-

from __future__ import absolute_import
from xml.etree.ElementTree import Element, tostring
from xml.dom import minidom

from .validator import CfdiValidator
from .schema import SchemaConstructor
from .xml import XmlBuilder

import logging
import sys


logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


class CfdiDocumentNotValid(Exception):
    pass


class CfdiNode:
    '''
    '''
    def __init__(self, tag='', **kwargs):
        self.__dict__.update(kwargs)
        self.__namespace__ = kwargs.get('_namespace', 'cfdi')
        self.__tag__ = tag
        for k, v in self.__dict__.items():
            if isinstance(v, dict):
                setattr(self, k, CfdiNode(tag=k, **v))
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

    def get_attributes(self):
        attributes = {}
        for k, v in self.as_dict().items():
            if k.startswith('_'):
                continue
            if type(v) in (dict, list):
                continue
            attributes[k] = v
        return attributes

    def as_etree_node(self, extra_attrs={}):
        tag = '{}:{}'.format(self.__namespace__, self.__tag__)
        attributes = self.get_attributes()
        attributes.update(extra_attrs)
        element = Element(tag)
        for k, v in attributes.items():
            value = '{}'.format(v)
            element.set(k, value)
        return element


class Cfdi(object):
    '''
    '''

    def __init__(self, document={}, version='3.2', key_path=None, cer_path=None, key_pem_path=None):
        self.document = document
        self.version = version
        self.key_path = key_path
        self.cer_path = key_path
        self.key_pem_path = key_pem_path

    def _get_validator(self):
        validator = CfdiValidator()
        schema = SchemaConstructor.get_schema(self.version)
        validator.validate(self.document, schema)
        return validator

    def is_valid(self):
        validator = self._get_validator()
        self.errors, self.normalized = validator.errors, validator.normalized(self.document)
        return not bool(self.errors)

    def _as_node_object(self):
        if self.is_valid():
            return CfdiNode(**self.normalized)
        else:
            log.exception("CFDI Document not valid. Errors: \"{}\".".format(self.errors))
            raise CfdiDocumentNotValid

    def as_etree_node(self):
        root_node = self._as_node_object().Comprobante
        etree_builder = EtreeBuilder(root_node, self.version)
        return etree_builder.build()

    def as_xml(self, pretty_print=False):
        Comprobante = self._as_node_object().Comprobante
        xml_builder = XmlBuilder(Comprobante)
        version = self.version.replace('.', '_')
        builder_func = getattr(xml_builder, 'get_cfdi_{}'.format(version))
        comprobante_node = builder_func()

        xml_string = '<?xml version="1.0" encoding="utf-8"?>'
        xml_string += tostring(comprobante_node, encoding='utf-8').decode('utf-8')

        if pretty_print:
            xml_string = minidom.parseString(xml_string)
            xml_string = xml_string.toprettyxml(indent=' ', encoding='utf-8').decode('utf-8')

        return xml_string
