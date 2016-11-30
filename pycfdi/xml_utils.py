# -*- coding: utf-8 -*-

from __future__ import absolute_import
from xml.etree.ElementTree import Element

import os

try:
    unicode = unicode
except NameError:
    str = str
    unicode = str
    basestring = (str, bytes)
else:
    str = str
    unicode = unicode
    basestring = basestring

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))

CADENA_ORIGINAL_3_2_PATH = os.path.join(__location__, 'assets/cadenaoriginal_3_2.xslt')
CADENA_ORIGINAL_3_2_NOMINA_1_2_PATH = os.path.join(__location__, 'assets/cadenaoriginal_3_2_nomina_1_2.xslt')


class CfdiNode(object):

    def __init__(self, tag='', **kwargs):
        self.__dict__.update(kwargs)
        self.__namespace__ = kwargs.get('_namespace', 'cfdi')
        self.__tag__ = kwargs.get('_tag', tag)
        self.__order__ = int(kwargs.get('_order', 0))
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

    def get_children(self):
        children = {}
        for k, v in self.as_dict().items():
            if k.startswith('as_'):
                continue
            if k.startswith('get_'):
                continue
            if k.startswith('print_'):
                continue
            if type(v) not in (dict, list):
                continue

            children[k] = v
        return children


    @staticmethod
    def _as_etree_node(obj, extra_attrs={}):
        if not hasattr(obj, '__dict__'):
            return obj
        tag = '{}:{}'.format(obj.__namespace__, obj.__tag__)
        attributes = obj.get_attributes()
        attributes.update(extra_attrs)
        children = obj.get_children()
        element = Element(tag)
        for k, v in attributes.items():
            value = '{}'.format(v)
            element.set(k, value)
        for k, v in children.items():
            if isinstance(v, list):
                v = sorted(v, key=lambda k: k.get('_order', 0))
                items = getattr(obj, k)
                for item in items:
                    element.append(obj._as_etree_node(item))
            else:
                child = getattr(obj, k)
                element.append(obj._as_etree_node(child))

        return element

    def as_etree_node_recursive(self, extra_attrs={}):
        return self._as_etree_node(self)

    def as_etree_node(self, extra_attrs={}):
        tag = '{}:{}'.format(self.__namespace__, self.__tag__)
        attributes = self.get_attributes()
        attributes.update(extra_attrs)
        element = Element(tag)
        for k, v in attributes.items():
            value = unicode('{}').format(v)
            element.set(k, value)
        return element


class XmlBuilder(object):
    '''
    '''
    def __init__(self, root_node):
        self.root_node = root_node


    def get_cfdi_3_2(self):
        xml_schema_data = {
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
        comprobante_node = self.root_node.as_etree_node()

        # Add schema data
        for k, v in xml_schema_data.items():
            comprobante_node.set(k, ' '.join(v))

        # -- Emisor
        Emisor = self.root_node.Emisor
        emisor_node = Emisor.as_etree_node()
        if hasattr(Emisor, 'DomicilioFiscal'):
            domicilio_node = Emisor.DomicilioFiscal.as_etree_node()
            emisor_node.append(domicilio_node)
        expedidoen_node = Emisor.ExpedidoEn.as_etree_node()
        emisor_node.append(expedidoen_node)
        for RegimenFiscal in Emisor.RegimenFiscal:
            regimen_node = RegimenFiscal.as_etree_node_recursive()
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
                retenciones_node.append(retencion_node)
            impuestos_node.append(retenciones_node)

        # --- Traslados
        if hasattr(Impuestos, 'Traslados'):
            Traslados = Impuestos.Traslados
            traslados_nodes = Element('cfdi:Traslados')
            for Traslado in Traslados:
                traslado_node = Traslado.as_etree_node()
                traslados_nodes.append(traslado_node)
            impuestos_node.append(traslados_nodes)

        comprobante_node.append(impuestos_node)

        # -- Complemento
        if hasattr(self.root_node, 'Complemento'):
            Complemento = self.root_node.Complemento
            complemento_node = Complemento.as_etree_node()

            # --- Impuestos locales
            implocales_version = None
            has_implocales = hasattr(Complemento, 'ImpuestosLocales')
            if has_implocales:
                implocales_version = Complemento.ImpuestosLocales.version

            # ----- Impuestos locales 1.0
            if has_implocales and implocales_version == '1.0':
                ImpuestosLocales = Complemento.ImpuestosLocales
                implocales_node = ImpuestosLocales.as_etree_node()
                implocales_node.set('xmlns:implocal', 'http://www.sat.gob.mx/implocal')
                implocales_node.set('xsi:schemaLocation', 'http://www.sat.gob.mx/implocal http://www.sat.gob.mx/sitio_internet/cfd/implocal/implocal.xsd')

                if hasattr(ImpuestosLocales, 'traslados'):
                    for traslado in ImpuestosLocales.traslados:
                        implocales_node.append(traslado.as_etree_node())

                if hasattr(ImpuestosLocales, 'retenciones'):
                    for retencion in ImpuestosLocales.retenciones:
                        implocales_node.append(retencion.as_etree_node())

                complemento_node.append(implocales_node)

            # --- Donatarias
            donatarias_version = None
            has_donatarias = hasattr(Complemento, 'Donatarias')
            if has_donatarias:
                donatarias_version = Complemento.Donatarias.version

            # ---- Donatarias 1.1
            if has_donatarias and donatarias_version == '1.1':
                Donatarias = Complemento.Donatarias
                donatarias_node = Donatarias.as_etree_node()
                donatarias_node.set('xmlns:donat', 'http://www.sat.gob.mx/donat')
                donatarias_node.set('xsi:schemaLocation', 'http://www.sat.gob.mx/donat http://www.sat.gob.mx/sitio_internet/cfd/donat/donat11.xsd')
                complemento_node.append(donatarias_node)

            # --- Complemento vehiculo
            vehiculousado_version = None
            has_vehiculousado = hasattr(Complemento, 'VehiculoUsado')
            if has_vehiculousado:
                vehiculousado_version = Complemento.VehiculoUsado.Version

            # ---- Complemento vehiculo 1.0
            if has_vehiculousado and vehiculousado_version == '1.0':
                VehiculoUsado = Complemento.VehiculoUsado
                vehiculousado_node = VehiculoUsado.as_etree_node()
                vehiculousado_node.set('xmlns:vehiculousado', 'http://www.sat.gob.mx/vehiculousado')
                vehiculousado_node.set('xsi:schemaLocation', 'http://www.sat.gob.mx/vehiculousado http://www.sat.gob.mx/sitio_internet/cfd/vehiculousado/vehiculousado.xsd')
                complemento_node.append(vehiculousado_node)

            # --- Servicios parciales constr.
            serviciosparciales_version = None
            has_serviciosparciales = hasattr(Complemento, 'parcialesconstruccion')
            if has_serviciosparciales:
                serviciosparciales_version = Complemento.parcialesconstruccion.Version

            # ---- Servicios parciales constr. 1.0
            if has_serviciosparciales and serviciosparciales_version == '1.0':
                parcialesconstruccion = Complemento.parcialesconstruccion
                parcialesconstruccion_node = parcialesconstruccion.as_etree_node()
                parcialesconstruccion_node.set('xmlns:servicioparcial', 'http://www.sat.gob.mx/servicioparcialconstruccion')
                parcialesconstruccion_node.set('xsi:schemaLocation', 'http://www.sat.gob.mx/servicioparcialconstruccion http://www.sat.gob.mx/sitio_internet/cfd/servicioparcialconstruccion/servicioparcialconstruccion.xsd')
                if hasattr(parcialesconstruccion, 'servicios'):
                    for servicio in parcialesconstruccion.servicios:
                        parcialesconstruccion_node.append(servicio.as_etree_node())
                complemento_node.append(parcialesconstruccion_node)

            # Declarar divisas - TODO
            # Complemento INE - TODO

            # --- Nomina
            nomina_version = None
            has_nomina = hasattr(Complemento, 'Nomina')
            if has_nomina:
                nomina_version = Complemento.Nomina.Version

            # ---- Nomina 1.1
            if has_nomina and nomina_version == '1.1':
                Nomina = Complemento.Nomina
                nomina_node = Nomina.as_etree_node()
                nomina_node.set('xmlns:nomina', 'http://www.sat.gob.mx/nomina')
                nomina_node.set('xsi:schemaLocation', 'http://www.sat.gob.mx/nomina http://www.sat.gob.mx/sitio_internet/cfd/nomina/nomina11.xsd')
                if hasattr(Nomina, 'Percepciones'):
                    Percepciones = Nomina.Percepciones
                    percepciones_node = Percepciones.as_etree_node_recursive()
                    nomina_node.append(percepciones_node)
                if hasattr(Nomina, 'Deducciones'):
                    Deducciones = Nomina.Deducciones
                    deducciones_node = Deducciones.as_etree_node_recursive()
                    nomina_node.append(deducciones_node)
                complemento_node.append(nomina_node)

            # ---- Nomina 1.2 - TODO

            if len(complemento_node.getchildren()) > 0:
                comprobante_node.append(complemento_node)

        return comprobante_node
