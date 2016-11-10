# -*- coding: utf-8 -*-

from __future__ import absolute_import
from lxml import etree
from xml.etree.ElementTree import tostring
from xml.dom import minidom

from .validator import CfdiValidator
from .schema import SchemaConstructor
from .xml_utils import CfdiNode, XmlBuilder, CADENA_ORIGINAL_3_2_PATH

import logging
import os
import subprocess
import sys
import tempfile


logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


class CfdiDocumentNotValid(Exception):
    pass


class InvalidCertificateError(Exception):
    pass


class InvalidKeyPemError(Exception):
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
            err_message = "CFDI Document not valid."
            log.exception(err_message)
            raise CfdiDocumentNotValid

    def _get_base64_certificate(self):
        if not self.cer_filepath or not os.path.isfile(self.cer_filepath):
            err_message = "Certificate (usually a .cer file) does not exist or it has not been set."
            log.exception(err_message)
            raise InvalidCertificateError

        command = 'openssl enc -base64 -in "{}"'.format(self.cer_filepath)
        output = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        output = output.stdout.read()
        output = ''.join([line.decode() for line in output.split()]).strip()
        return output

    def _get_cadena_original(self):
        xml_string = self.as_xml(declare_encoding=False)
        dom = etree.fromstring(xml_string)
        xslt = etree.parse(CADENA_ORIGINAL_3_2_PATH)
        transform = etree.XSLT(xslt)
        return transform(dom)

    def _get_stamp_3_2(self):
        if not self.pem_filepath or not os.path.isfile(self.pem_filepath):
            err_message = "Private key (usually a .pem or .key.pem file) does not exist or it has not been set."
            log.exception(err_message)
            raise InvalidKeyPemError

        cadena_original, cadena_original_path = tempfile.mkstemp()
        os.write(cadena_original, self._get_cadena_original())
        command = 'cat "{cadena_original_path}" | openssl dgst -sha1 -sign "{pem_filepath}" | openssl enc -base64 -A'
        command = command.format(cadena_original_path=cadena_original_path, pem_filepath=self.pem_filepath)
        output = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        output = output.stdout.read()
        os.remove(cadena_original_path)

        return output

    def as_etree_node(self):
        Comprobante = self._as_cfdi_node().Comprobante
        xml_builder = XmlBuilder(Comprobante)
        version = self.version.replace('.', '_')
        builder_func = getattr(xml_builder, 'get_cfdi_{}'.format(version))
        return builder_func()

    def as_xml(self, declare_encoding=True, pretty_print=False):
        comprobante_node = self.as_etree_node()
        xml_string = '<?xml version="1.0" encoding="utf-8"?>' if declare_encoding else ''
        xml_string += tostring(comprobante_node, encoding='utf-8').decode('utf-8')
        if pretty_print:
            xml_string = minidom.parseString(xml_string)
            xml_string = xml_string.toprettyxml(indent=' ', encoding='utf-8').decode('utf-8')
        return xml_string
