# -*- coding: utf-8 -*-

from __future__ import absolute_import
from xml.etree.ElementTree import Element, tostring
from xml.dom import minidom

from .validator import CfdiValidator
from .schema import SchemaConstructor

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

    def __init__(self, document={}, version='3.2', *args, **kwargs):
        self.document = document
        self.version = version

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

    def as_xml(self, pretty_print=False):
        Comprobante = self._as_node_object().Comprobante
        xml_schema = {
            'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
            'xmlns:cfdi': 'http://www.sat.gob.mx/cfd/3',
            'xsi:schemaLocation': 'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd',
        }

        # - Comprobante
        comprobante_node = Comprobante.as_etree_node(extra_attrs=xml_schema)

        # -- Emisor
        Emisor = Comprobante.Emisor
        emisor_node = Emisor.as_etree_node()
        if hasattr(Emisor, 'DomicilioFiscal'):
            domicilio_node = Emisor.DomicilioFiscal.as_etree_node()
            emisor_node.append(domicilio_node)
        expedidoen_node = Emisor.ExpedidoEn.as_etree_node()
        emisor_node.append(expedidoen_node)
        for regimen in Emisor.RegimenFiscal:
            regimen_node = Element('cfdi:RegimenFiscal')
            regimen_node.set('Regimen', regimen.Regimen)
            emisor_node.append(regimen_node)
        comprobante_node.append(emisor_node)

        # -- Receptor
        Receptor = Comprobante.Receptor
        receptor_node = Receptor.as_etree_node()
        if hasattr(Receptor, 'Domicilio'):
            domicilio_node = Receptor.Domicilio.as_etree_node()
            receptor_node.append(domicilio_node)
        comprobante_node.append(receptor_node)

        # -- Conceptos
        conceptos_node = Element('cfdi:Conceptos')
        for Concepto in Comprobante.Conceptos:
            concepto_node = Concepto.as_etree_node()
            concepto_node.tag = 'cfdi:Concepto'
            conceptos_node.append(concepto_node)
        comprobante_node.append(conceptos_node)

        # -- Impuestos
        Impuestos = Comprobante.Impuestos
        impuestos_node = Impuestos.as_etree_node()

        # --- Retenciones
        if hasattr(Impuestos, 'Retenciones'):
            Retenciones = Impuestos.Retenciones
            retenciones_node = Element('cfdi:Retenciones')
            for Retencion in Retenciones:
                retencion_node = Retencion.as_etree_node()
                retencion_node.tag = 'cfdi:Retencion'
                retenciones_node.append(retencion_node)
            impuestos_node.append(retenciones_node)

        # --- Traslados
        if hasattr(Impuestos, 'Traslados'):
            Traslados = Impuestos.Traslados
            traslados_nodes = Element('cfdi:Traslados')
            for Traslado in Traslados:
                traslado_node = Traslado.as_etree_node()
                traslado_node.tag = 'cfdi:Traslado'
                traslados_nodes.append(traslado_node)
            impuestos_node.append(traslados_nodes)

        comprobante_node.append(impuestos_node)
        xml_string = "<?xml version='1.0' encoding='UTF-8'?>"
        xml_string += tostring(comprobante_node).decode('utf-8')

        if pretty_print:
            xml_string = minidom.parseString(xml_string).toprettyxml(indent=' ')

        return xml_string
