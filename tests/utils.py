# -*- coding: utf-8 -*-


SAMPLE_CFDI_DOC = {

    'Comprobante': {
        'folio': 123,
        'fecha': '2015-02-18T11:49:20',
        'formaDePago': 'Pago único',
        'subTotal': '300.00',
        'total': 116.00,
        'tipoDeComprobante': 'ingreso',
        'LugarExpedicion': 'México DF',
        'metodoDePago': '01',

        'Emisor': {
            'nombre': 'John Doe',
            'rfc': 'AAA010101AAA',
            'RegimenFiscal': ['Pruebas Fiscales', 'Persona Moral', ],
            'DomicilioFiscal': {
                'calle': 'Calle 20',
                'noInterior': '12',
                'localidad': 'Cuernavaca',
                'colonia': 'Pinos',
                'municipio': 'Cuernavaca',
                'estado': 'Morelos',
                'codigoPostal': '58010',
                'pais': 'México',
            },
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
            'Domicilio': {
                'calle': 'Calle 20',
                'noInterior': '12',
                'pais': 'México',
            }
        },

        'Conceptos': [
            {
                'cantidad': '1',
                'unidad': 'PZA',
                'noIdentificacion': '12B',
                'descripcion': 'AAA',
                'importe': 100,
                'valorUnitario': 100,
            },
            {
                'cantidad': '1',
                'unidad': 'PZA',
                'noIdentificacion': '12B',
                'descripcion': 'BBB',
                'importe': 100,
                'valorUnitario': 100,
                'CuentaPredial': {
                    'numero': 12345,
                }
            },
            {
                'cantidad': '1',
                'unidad': 'PZA',
                'noIdentificacion': '12B',
                'descripcion': 'CCC',
                'importe': 100,
                'valorUnitario': 100,
            },
        ],

        'Impuestos': {
            'Retenciones': [
                {
                    'impuesto': 'ISR',
                    'importe': 10.0,
                }
            ],
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
