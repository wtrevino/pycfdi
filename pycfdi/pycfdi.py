# -*- coding: utf-8 -*-

from __future__ import absolute_import

import tenjin
from tenjin.helpers import to_str, escape
from xml.etree.ElementTree import ElementTree, Element, tostring
from xml.dom import minidom

from .validator import CfdiValidator
from .schema import SchemaConstructor

from io import BytesIO
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

    def __init__(self, document={}, version='3.2', *args, **kwargs):
        self.document = document
        self.version = version

    def _get_validator(self):
        validator = CfdiValidator()
        schema = SchemaConstructor.get_schema(self.version)
        validator.validate(self.document, schema)
        return validator

    def is_valid(self):
        validator =self._get_validator()
        self.errors, self.normalized_document = validator.errors, validator.normalized
        return not bool(self.errors)

    def _as_node_object(self):
        if self.is_valid():
            return CfdiNode(**self.normalized_document)
        else:
            log.exception("CFDI Document not valid. Errors: \"{}\".".format(self.errors))
            raise CfdiDocumentNotValid

    def as_xml(self, pretty_print=True):
        Comprobante = self._as_node_object().Comprobante
        xml_schema = {
            'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns:cfdi': 'http://www.sat.gob.mx/cfd/3',
            'xsi:schemaLocation': 'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd',
        }
        comprobante_node = Comprobante.as_etree_node(extra_attrs=xml_schema)
        emisor_node = Comprobante.Emisor.as_etree_node()

        if hasattr(Comprobante.Emisor, 'DomicilioFiscal'):
            domicilio_node = Comprobante.Emisor.DomicilioFiscal.as_etree_node()
            emisor_node.append(domicilio_node)
        comprobante_node.append(emisor_node)

        expedidoen_node = Comprobante.Emisor.ExpedidoEn.as_etree_node()
        comprobante_node.append(expedidoen_node)

        tree = ElementTree(comprobante_node)
        f = BytesIO()
        tree.write(f, encoding='utf-8', xml_declaration=True)
        xml_string = f.getvalue().decode('utf-8')
        if pretty_print:
            xml_string = minidom.parseString(xml_string).toprettyxml(indent=' ')

        return xml_string
