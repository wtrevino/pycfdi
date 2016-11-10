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


SAMPLE_BASE64_CERT = '''
                  MIIEYTCCA0mgAwIBAgIUMjAwMDEwMDAwMDAyMDAwMDE0MzcwDQYJKoZIhvcNAQEF
                  BQAwggFcMRowGAYDVQQDDBFBLkMuIDIgZGUgcHJ1ZWJhczEvMC0GA1UECgwmU2Vy
                  dmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0Fk
                  bWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMSkw
                  JwYJKoZIhvcNAQkBFhphc2lzbmV0QHBydWViYXMuc2F0LmdvYi5teDEmMCQGA1UE
                  CQwdQXYuIEhpZGFsZ28gNzcsIENvbC4gR3VlcnJlcm8xDjAMBgNVBBEMBTA2MzAw
                  MQswCQYDVQQGEwJNWDEZMBcGA1UECAwQRGlzdHJpdG8gRmVkZXJhbDESMBAGA1UE
                  BwwJQ295b2Fjw6FuMTQwMgYJKoZIhvcNAQkCDCVSZXNwb25zYWJsZTogQXJhY2Vs
                  aSBHYW5kYXJhIEJhdXRpc3RhMB4XDTEzMDUwNzE3NDAwN1oXDTE3MDUwNzE3NDAw
                  N1owgdsxKTAnBgNVBAMTIEFDQ0VNIFNFUlZJQ0lPUyBFTVBSRVNBUklBTEVTIFND
                  MSkwJwYDVQQpEyBBQ0NFTSBTRVJWSUNJT1MgRU1QUkVTQVJJQUxFUyBTQzEpMCcG
                  A1UEChMgQUNDRU0gU0VSVklDSU9TIEVNUFJFU0FSSUFMRVMgU0MxJTAjBgNVBC0T
                  HEFBQTAxMDEwMUFBQSAvIEhFR1Q3NjEwMDM0UzIxHjAcBgNVBAUTFSAvIEhFR1Q3
                  NjEwMDNNREZOU1IwODERMA8GA1UECxMIcHJvZHVjdG8wgZ8wDQYJKoZIhvcNAQEB
                  BQADgY0AMIGJAoGBAJ4COACtDKzGDv9V0W3LN508rc2eICyi5g3SsGrJE1Z49cJn
                  gFuR6DgXWUO85Tu/NG3r4aXOvZs6bGG6dEG7Dcb1aC5dkF+yI6PlHKsiTk5ntJ/a
                  ETA/rckVyb9cmeCh4Mqfo0OGxMmsEzxUl7qm3onv2ldmk6pJmSIQGTHzMZYbAgMB
                  AAGjHTAbMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQDAgbAMA0GCSqGSIb3DQEBBQUA
                  A4IBAQDWG+0Soy5vxmclDKOrvyHjAbQGk4BPynbCjOWeFZ5s7HOpw6TSSe56R33n
                  /ZO2CvC4/ICwrNgl+drycfU5ZA5d3TflsO9jgTBsDSq5LDJ9h062IadD8o4Mg5BT
                  b1C2FAiMD16DHwxVgYZvk2wmXQ0mrxLoMu2wiBpbvwoXJlOiociUxXQtlukmjzme
                  Tovu1XTDd50gbztYBHIdjOpAjXmmytwrwNGmWG+D3Jfjhtydy1GSOTtN+hGElYg7
                  1vLNFekJyEkc4pkWORG0xmwRf/rnoSFjHyk/5duRUth6GEvQEfwAlZIn7rsttGzu
                  bLO9QY5BM6P3km98mPt7NnV/SSxo
                  '''
