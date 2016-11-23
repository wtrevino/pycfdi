#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
test_pycfdi
----------------------------------

Tests for `pycfdi` module.
"""

import pytest

from contextlib import contextmanager
from click.testing import CliRunner

from pycfdi import pycfdi
from pycfdi import cli

from .utils import SAMPLE_CFDI_DOC, SAMPLE_BASE64_CERT

import os
import random
import sys

if sys.version.startswith('2.7'):
    reload(sys)
    sys.setdefaultencoding('utf8')

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))


@pytest.fixture
def response():
    """Sample pytest fixture.
    See more at: http://doc.pytest.org/en/latest/fixture.html
    """
    # import requests
    # return requests.get('https://github.com/audreyr/cookiecutter-pypackage')

def test_valid_cfdi_3_2(response):
    '''
        Assert a cfdi doc is valid
    '''
    cfdi = pycfdi.Cfdi(SAMPLE_CFDI_DOC, version='3.2')
    assert cfdi.is_valid() is True, 'CFDI should be valid'

def test_invalid_cfdi_3_2(response):
    '''
        Assert some cfdis are invalid
    '''
    cfdi = pycfdi.Cfdi({}, version='3.2')
    assert cfdi.is_valid() is False, 'CFDI should be invalid'
    assert cfdi.errors == {'Comprobante': ['required field']}

    cfdi = pycfdi.Cfdi({'Comprobante': {}}, version='3.2')
    assert cfdi.is_valid() is False, 'CFDI should be invalid'
    assert cfdi.errors == {
                'Comprobante': [
                    {
                        'Conceptos': ['required field'],
                        'Emisor': ['required field'],
                        'LugarExpedicion': ['required field'],
                        'Receptor': ['required field'],
                        'fecha': ['required field'],
                        'formaDePago': ['required field'],
                        'metodoDePago': ['required field'],
                        'subTotal': ['required field'],
                        'tipoDeComprobante': ['required field'],
                        'total': ['required field']
                    }
                ]
            }

def test_certificate_not_set():
    '''
        Assert a certificate is not set
    '''
    cfdi = pycfdi.Cfdi({})
    with pytest.raises(pycfdi.InvalidCertificateError) as excinfo:
        cfdi._get_base64_certificate()

def test_certificate_invalid():
    '''
        Assert a certificate is not a valid file
    '''
    cfdi = pycfdi.Cfdi({}, cer_filepath='/a/fake/path/{}.cer'.format(random.randint(1, 1000)))
    with pytest.raises(pycfdi.InvalidCertificateError) as excinfo:
        cfdi._get_base64_certificate()

def test_certificate_valid():
    '''
        Assert a certificate valid and correct
    '''
    base64_cert = ''.join(SAMPLE_BASE64_CERT.split())
    cer_filepath = os.path.join(__location__, 'sample_data/certificates/AAA010101AAA.cer')
    cfdi = pycfdi.Cfdi(SAMPLE_CFDI_DOC, cer_filepath=cer_filepath)
    assert cfdi._get_base64_certificate() == base64_cert, 'Certificate should be invalid'

def test_xml_generation():
    cfdi = pycfdi.Cfdi(SAMPLE_CFDI_DOC)
    expected_xml = '<?xml version="1.0" encoding="utf-8"?>' \
                '<cfdi:Comprobante LugarExpedicion="México DF" certificado="" fecha="2015-02-18T11:49:20"' \
                ' folio="123" formaDePago="Pago único" metodoDePago="01" noCertificado="" sello="" subTot' \
                'al="300.0" tipoDeComprobante="ingreso" total="116.0" version="3.2" xmlns:cfdi="http://ww' \
                'w.sat.gob.mx/cfd/3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLoca' \
                'tion="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd"' \
                '><cfdi:Emisor nombre="John Doe" rfc="AAA010101AAA"><cfdi:DomicilioFiscal calle="Calle 20' \
                '" codigoPostal="58010" colonia="Pinos" estado="Morelos" localidad="Cuernavaca" municipio' \
                '="Cuernavaca" noInterior="12" pais="México" /><cfdi:ExpedidoEn calle="Calle 20" codigoPo' \
                'stal="58010" colonia="Pinos" estado="Morelos" localidad="Cuernavaca" municipio="Cuernava' \
                'ca" noInterior="12" pais="México" /><cfdi:RegimenFiscal Regimen="Pruebas Fiscales" /><cf' \
                'di:RegimenFiscal Regimen="Persona Moral" /></cfdi:Emisor><cfdi:Receptor nombre="Público ' \
                'en General" rfc="XAXX010101000"><cfdi:Domicilio calle="Calle 20" noInterior="12" pais="M' \
                'éxico" /></cfdi:Receptor><cfdi:Conceptos><cfdi:Concepto cantidad="1.0" descripcion="AAA"' \
                ' importe="100.0" noIdentificacion="12B" unidad="PZA" valorUnitario="100.0" /><cfdi:Conce' \
                'pto cantidad="1.0" descripcion="BBB" importe="100.0" noIdentificacion="12B" unidad="PZA"' \
                ' valorUnitario="100.0"><cfdi:CuentaPredial numero="12345" /></cfdi:Concepto><cfdi:Concep' \
                'to cantidad="1.0" descripcion="CCC" importe="100.0" noIdentificacion="12B" unidad="PZA" ' \
                'valorUnitario="100.0" /></cfdi:Conceptos><cfdi:Impuestos totalImpuestosTrasladados="16.0' \
                '"><cfdi:Retenciones><cfdi:Retencion importe="10.0" impuesto="ISR" /></cfdi:Retenciones><' \
                'cfdi:Traslados><cfdi:Traslado importe="16.0" impuesto="IVA" tasa="16.0" /></cfdi:Traslad' \
                'os></cfdi:Impuestos></cfdi:Comprobante>'
    assert cfdi.as_xml() == expected_xml

def test_xml_generation_with_stamp():
    pass

def test_command_line_interface():
    pass




