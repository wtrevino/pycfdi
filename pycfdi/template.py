import tenjin
from tenjin.helpers import to_str, escape


class XmlRenderer(object):

    @classmethod
    def get_Traslado_template(self, data, cfdi_version):
        template_string = '<cfdi:Traslado importe="$importe" tasa="$tasa" impuesto="$impuesto"/>'
        template = Template(template_string)
        return template.substitute(importe=data.importe, tasa=data.tasa, impuesto=data.impuesto)


    @classmethod
    def get_xml(self, node, cfdi_version):
        self.root_node = node
        _versions = {
            '3.2'
        }



'''
<?xml version="1.0" encoding="UTF-8"?>
<cfdi:Comprobante $NumCtaPago LugarExpedicion=$LugarExpedicion metodoDePago=$metodoDePago tipoDeComprobante=$tipoDeComprobante total="40600.00" Moneda="Pesos"
    $descuento subTotal=$subTotal certificado="" noCertificado="" formaDePago=$formaDePago sello="" fecha="$fecha" folio="$folio" $serie version="3.2" xsi:schemaLocation="">
    <cfdi:Emisor nombre="Empresa de Pruebas SA" rfc="AAA010101AAA">
        <cfdi:DomicilioFiscal codigoPostal="64000" pais="México" estado="Nuevo León"
            municipio="Monterrey" colonia="Fracc. San Pedro" noExterior="1452" calle="Encinos"/>
        <cfdi:RegimenFiscal Regimen="Regimen General de Ley Personas Morales de Prueba"/>
    </cfdi:Emisor>
    <cfdi:Receptor nombre="Exportadora de Ganado HOLSTEIN S.A." rfc="E&amp;Ñ831019M53">
        <cfdi:Domicilio codigoPostal="99170" pais="México" estado="Zacatecas" municipio="Zacatecas"
            localidad="Ejido La Siembra" colonia="Ejido La Siembra" noExterior="102"
            calle="Av. Principal"/>
    </cfdi:Receptor>
    <cfdi:Conceptos>
        <cfdi:Concepto importe="35000.00" valorUnitario="35000.00"
            descripcion="Módulo de embarque serie A-6743-Ñ" unidad="LTE" cantidad="1"/>
    </cfdi:Conceptos>
    <cfdi:Impuestos totalImpuestosTrasladados="5600.00" totalImpuestosRetenidos="0.00">
        <cfdi:Retenciones>
            <cfdi:Retencion importe="0.00" impuesto="ISR"/>
            <cfdi:Retencion importe="0.00" impuesto="IVA"/>
        </cfdi:Retenciones>
        <cfdi:Traslados>
            <cfdi:Traslado importe="5600.00" tasa="16.00" impuesto="IVA"/>
        </cfdi:Traslados>
    </cfdi:Impuestos>
</cfdi:Comprobante>
'''
