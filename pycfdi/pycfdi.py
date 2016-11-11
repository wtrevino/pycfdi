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


class InvalidCerPemError(Exception):
    pass


class Cfdi(object):
    '''
    '''

    def __init__(self, document={}, version='3.2', cer_filepath=None, cerpem_filepath=None, keypem_filepath=None):
        self.document = document
        self.version = version
        self.cer_filepath = cer_filepath
        self.cerpem_filepath = cerpem_filepath
        self.keypem_filepath = keypem_filepath

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

    def _get_serial(self):
        if not self.cerpem_filepath or not os.path.isfile(self.cerpem_filepath):
            err_message = "Certificate (usually a .cer.pem file) does not exist or it has not been set."
            log.exception(err_message)
            raise InvalidCerPemError

        command = 'openssl x509 -in "{}" -serial -noout'.format(self.cerpem_filepath)
        output = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        output = output.stdout.read().decode()
        output = output.replace('serial=', '').strip()
        output = zip(*(iter(output), ) * 2)
        return ''.join([i[1] for i in output])

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
        xml_string = self.as_xml(pretty_print=True)
        dom = etree.fromstring(bytes(xml_string, encoding='utf-8'))
        xslt = etree.parse(CADENA_ORIGINAL_3_2_PATH)
        transform = etree.XSLT(xslt)
        return transform(dom)

    def _get_stamp_3_2(self):
        if not self.keypem_filepath or not os.path.isfile(self.keypem_filepath):
            err_message = "Private key (usually a .key.pem file) does not exist or it has not been set."
            log.exception(err_message)
            raise InvalidKeyPemError

        cadena_original, cadena_original_path = tempfile.mkstemp()
        os.write(cadena_original, self._get_cadena_original())
        command = 'cat "{cadena_original_path}" | openssl dgst -sha1 -sign "{keypem_filepath}" | openssl enc -base64 -A'
        command = command.format(cadena_original_path=cadena_original_path, keypem_filepath=self.keypem_filepath)
        output = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        output = output.stdout.read()
        #from ipdb import set_trace;set_trace()
        os.remove(cadena_original_path)
        return output

    def as_etree_node(self):
        Comprobante = self._as_cfdi_node().Comprobante
        xml_builder = XmlBuilder(Comprobante)
        version = self.version.replace('.', '_')
        builder_func = getattr(xml_builder, 'get_cfdi_{}'.format(version))
        return builder_func()

    def as_xml(self, declare_encoding=True, pretty_print=False, stamp=False):
        if stamp:
            self.stamp()
        comprobante_node = self.as_etree_node()
        xml_string = '<?xml version="1.0" encoding="utf-8"?>' if declare_encoding else ''
        xml_string += tostring(comprobante_node, encoding='utf-8').decode('utf-8')
        if pretty_print:
            xml_string = minidom.parseString(xml_string)
            xml_string = xml_string.toprettyxml(indent=' ', encoding='utf-8').decode('utf-8')
        return xml_string

    def stamp(self, pretty_print=False):
        self.document['Comprobante']['noCertificado'] = self._get_serial()
        self.document['Comprobante']['certificado'] = self._get_base64_certificate()
        version = self.version.replace('.', '_')
        sello_func = getattr(self, '_get_stamp_{}'.format(version))
        sello = sello_func()
        self.document['Comprobante']['sello'] = sello.decode()
