# -*- coding: utf-8 -*-

from __future__ import absolute_import
from xml.etree.ElementTree import Element


class XmlBuilder(object):
    '''
    '''
    def __init__(self, root_node):
        self.root_node = root_node


    def get_cfdi_3_2(self):
        xml_schemas = {
            'xmlns:xsi': [
                'http://www.w3.org/2001/XMLSchema-instance',
            ],
            'xmlns:cfdi': [
                'http://www.sat.gob.mx/cfd/3'
            ],
            'xsi:schemaLocation': [
                'http://www.sat.gob.mx/cfd/3',
                'http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd',
            ],
        }

        # - Comprobante
        comprobante_extra_attrs = {'certificado': '', 'sello': ''}
        comprobante_node = self.root_node.as_etree_node(extra_attrs=comprobante_extra_attrs)

        # -- Emisor
        Emisor = self.root_node.Emisor
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
        Receptor = self.root_node.Receptor
        receptor_node = Receptor.as_etree_node()
        if hasattr(Receptor, 'Domicilio'):
            domicilio_node = Receptor.Domicilio.as_etree_node()
            receptor_node.append(domicilio_node)
        comprobante_node.append(receptor_node)

        # -- Conceptos
        conceptos_node = Element('cfdi:Conceptos')
        for Concepto in self.root_node.Conceptos:
            concepto_node = Concepto.as_etree_node()
            concepto_node.tag = 'cfdi:Concepto'
            if hasattr(Concepto, 'CuentaPredial'):
                CuentaPredial = Concepto.CuentaPredial
                cuenta_predial_node = CuentaPredial.as_etree_node()
                concepto_node.append(cuenta_predial_node)
            conceptos_node.append(concepto_node)
        comprobante_node.append(conceptos_node)

        # -- Impuestos
        Impuestos = self.root_node.Impuestos
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


        # Add schemas
        for k, v in xml_schemas.items():
            comprobante_node.set(k, ' '.join(v))

        return comprobante_node
