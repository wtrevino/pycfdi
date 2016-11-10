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

from .utils import SAMPLE_CFDI_DOC

import random


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



def test_command_line_interface():
    assert 0 == 0
