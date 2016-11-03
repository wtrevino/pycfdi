===============================
pycfdi
===============================

A python module to create, manipulate and validate CFDI documents.


* VERY much in alpha. Not intended for production use (yet). Work in progress.

* Free software: MIT license

* As of now, pycfdi is only useful for CFDI validation.


Usage:
--------
.. code-block:: python

    from pycfdi import Cfdi

    cfdi_doc = {
        'Comprobante': {
            'folio': 123,
            'fecha': '2015-02-18T11:49:20',
            'formaDePago': 'PAGO UNICO',
            'subTotal': 100.00,
            'total': 116.00,
            'tipoDeComprobante': 'ingreso',
            'LugarExpedicion': 'México DF',
            'metodoDePago': '01',

            'Emisor': {
                'nombre': 'John Doe',
                'rfc': 'AAA010101AAA',
                'RegimenFiscal': 'Pruebas Fiscales',
                'ExpedidoEn': {
                    'calle': 'Calle 20',
                    'noInterior': '12',
                    'localidad': 'Cuernavaca',
                    'colonia': 'Pinos',
                    'municipio': 'Cuernavaca',
                    'estado': 'Morelos',
                    'codigoPostal': '58010',
                    'pais': 'México',
                },
            },
            'Receptor': {
                'nombre': 'Público en General',
                'rfc': 'XAXX010101000',
            },
            'Conceptos': [
                {
                    'cantidad': '1',
                    'unidad': 'PZA',
                    'noIdentificacion': '12B',
                    'descripcion': 'a totes magotes',
                    'importe': 100,
                    'valorUnitario': 100,
                },
            ],
            'Impuestos': {
                'Traslados': [
                    {
                        'impuesto': 'IVA',
                        'tasa': 16.0,
                        'importe': 16.0,
                    }
                ],
                'totalImpuestosTrasladados': 16.0,
            }
        }
    }

    cfdi = Cfdi(cfdi_doc)
    cfdi.validate()
    >>> True
