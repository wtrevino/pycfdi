# -*- coding: utf-8 -*-

from __future__ import absolute_import
from xml.etree.ElementTree import tostring
from xml.dom import minidom

from .validator import CfdiValidator
from .schema import SchemaConstructor
from .xml_utils import CfdiNode, XmlBuilder

import logging
import os
import subprocess
import sys


logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


class CfdiDocumentNotValid(Exception):
    pass


class InvalidCertificateError(Exception):
    pass


class InvalidEncodedCertificateError(Exception):
    pass


class Cfdi(object):
    '''
    '''

    def __init__(self, document={}, version='3.2', cer_filepath=None, pem_filepath=None):
        self.document = document
        self.version = version
        self.cer_filepath = cer_filepath
        self.pem_filepath = pem_filepath

    def _get_validator(self):
        validator = CfdiValidator()
        schema = SchemaConstructor.get_schema(self.version)
        validator.validate(self.document, schema)
        return validator

    def is_valid(self):
        validator = self._get_validator()
        self.errors, self.normalized = validator.errors, validator.normalized(self.document)
        return not bool(self.errors)

    def _as_cfdi_node(self):
        if self.is_valid():
            return CfdiNode(**self.normalized)
        else:
            log.exception("CFDI Document not valid. Errors: \"{}\".".format(self.errors))
            raise CfdiDocumentNotValid

    def _get_base64_certificate(self):
        if not self.cer_filepath or not os.path.isfile(self.cer_filepath):
            log.exception("Certificate (.cer) file does not exist or is not set.")
            raise InvalidCertificateError

        command = 'openssl enc -base64 -in "{}"'.format(self.cer_filepath)
        output = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        output = output.stdout.read()
        output = ''.join([line.decode() for line in output.split()])
        return output

    def as_etree_node(self):
        Comprobante = self._as_cfdi_node().Comprobante
        xml_builder = XmlBuilder(Comprobante)
        version = self.version.replace('.', '_')
        builder_func = getattr(xml_builder, 'get_cfdi_{}'.format(version))
        return builder_func()

    def as_xml(self, pretty_print=False):
        comprobante_node = self.as_etree_node()
        xml_string = '<?xml version="1.0" encoding="utf-8"?>'
        xml_string += tostring(comprobante_node, encoding='utf-8').decode('utf-8')
        if pretty_print:
            xml_string = minidom.parseString(xml_string)
            xml_string = xml_string.toprettyxml(indent=' ', encoding='utf-8').decode('utf-8')
        return xml_string
