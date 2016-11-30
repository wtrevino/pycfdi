<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:fn="http://www.w3.org/2005/xpath-functions" 
                xmlns:cfdi="http://www.sat.gob.mx/cfd/3" 
                xmlns:ecc="http://www.sat.gob.mx/ecc" 
                xmlns:psgecfd="http://www.sat.gob.mx/psgecfd" 
                xmlns:donat="http://www.sat.gob.mx/donat" 
                xmlns:divisas="http://www.sat.gob.mx/divisas" 
                xmlns:detallista="http://www.sat.gob.mx/detallista" 
                xmlns:implocal="http://www.sat.gob.mx/implocal" 
                xmlns:terceros="http://www.sat.gob.mx/terceros" 
                xmlns:iedu="http://www.sat.gob.mx/iedu" 
                xmlns:ventavehiculos="http://www.sat.gob.mx/ventavehiculos" 
                xmlns:pfic="http://www.sat.gob.mx/pfic" 
                xmlns:tpe="http://www.sat.gob.mx/TuristaPasajeroExtranjero" 
                xmlns:leyendasFisc="http://www.sat.gob.mx/leyendasFiscales"
                xmlns:nomina12="http://www.sat.gob.mx/nomina12"
                xmlns:notariospublicos="http://www.sat.gob.mx/notariospublicos"
                xmlns:ecb="http://www.sat.gob.mx/ecb" 
                xmlns:spei="http://www.sat.gob.mx/spei" 
                xmlns:registrofiscal="http://www.sat.gob.mx/registrofiscal" 
                xmlns:pagoenespecie="http://www.sat.gob.mx/pagoenespecie" 
                xmlns:consumodecombustibles="http://www.sat.gob.mx/consumodecombustibles" 
                xmlns:valesdedespensa="http://www.sat.gob.mx/valesdedespensa" 
                xmlns:aerolineas="http://www.sat.gob.mx/aerolineas" 
                xmlns:vehiculousado="http://www.sat.gob.mx/vehiculousado" 
                xmlns:servicioparcial="http://www.sat.gob.mx/servicioparcialconstruccion" 
                xmlns:destruccion="http://www.sat.gob.mx/certificadodestruccion" 
                xmlns:decreto="http://www.sat.gob.mx/renovacionysustitucionvehiculos"
                xmlns:ine="http://www.sat.gob.mx/ine"
                xmlns:cce="http://www.sat.gob.mx/ComercioExterior"
                xmlns:obrasarte="http://www.sat.gob.mx/arteantiguedades">
  
  <!-- Con el siguiente método se establece que la salida deberá ser en texto -->
	<!-- <xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/> -->
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- Normalizador de espacios en blanco -->
  <xsl:template name="ManejaEspacios">
    <xsl:param name="s"/>
    <xsl:value-of select="normalize-space(string($s))"/>
  </xsl:template>
  
  <!-- Manejador de datos requeridos -->
  <xsl:template name="Requerido">
    <xsl:param name="valor"/>|<xsl:call-template name="ManejaEspacios">
      <xsl:with-param name="s" select="$valor"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de datos opcionales -->
  <xsl:template name="Opcional">
    <xsl:param name="valor"/>
    <xsl:if test="$valor">|<xsl:call-template name="ManejaEspacios">
        <xsl:with-param name="s" select="$valor"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <xsl:template match="cce:ComercioExterior">
    <!--Manejador de nodos tipo ComercioExterior-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Version" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoOperacion" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ClaveDePedimento" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@CertificadoOrigen" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumCertificadoOrigen" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumeroExportadorConfiable" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Incoterm" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Subdivision" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Observaciones" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TipoCambioUSD" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalUSD" />
    </xsl:call-template>

    <!--  Iniciamos el manejo de los elementos hijo en la secuencia -->
    <xsl:apply-templates select="./cce:Emisor" />
    <xsl:apply-templates select="./cce:Receptor" />
    <xsl:apply-templates select="./cce:Destinatario" />
    <xsl:apply-templates select="./cce:Mercancias" />
  </xsl:template>


  <xsl:template match="cce:Emisor">
    <!--  Iniciamos el tratamiento de los atributos de cce:Emisor-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Curp" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="cce:Receptor">
    <!--  Tratamiento de los atributos de cce:Receptor-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Curp" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumRegIdTrib" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="cce:Destinatario">
    <!--  Tratamiento de los atributos de cce:Destinatario-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumRegIdTrib" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Rfc" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Curp" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Nombre" />
    </xsl:call-template>
    <!--  Manejo de los nodos dependientes -->
    <xsl:apply-templates select="./cce:Domicilio" />
  </xsl:template>


  <xsl:template match="cce:Mercancias">
    <!--  Iniciamos el manejo de los nodos dependientes -->
    <xsl:for-each select="./cce:Mercancia">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="cce:Domicilio">
    <!--  Iniciamos el tratamiento de los atributos de cce:Domicilio-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Calle" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumeroExterior" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumeroInterior" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Colonia" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Localidad" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Referencia" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Municipio" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Estado" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Pais" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CodigoPostal" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="cce:Mercancia">
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NoIdentificacion" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@FraccionArancelaria" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@CantidadAduana" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@UnidadAduana" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ValorUnitarioAduana" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ValorDolares" />
    </xsl:call-template>

    <!--  Manejo de los nodos dependientes -->
    <xsl:for-each select="./cce:DescripcionesEspecificas">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>


  <xsl:template match="cce:DescripcionesEspecificas">
    <!--  Iniciamos el tratamiento de los atributos de cce:descripcionesEspecificas-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Marca" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Modelo" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@SubModelo" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumeroSerie" />
    </xsl:call-template>
  </xsl:template>






  <xsl:template match="ine:INE">
    <!--Manejador de nodos tipo INE-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Version" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoProceso" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TipoComite" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@IdContabilidad" />
    </xsl:call-template>

    <!--  Iniciamos el manejo de los elementos hijo en la secuencia -->
    <xsl:for-each select="./ine:Entidad">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="ine:Entidad">
    <!--Manejador de nodos tipo Entidad-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ClaveEntidad" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Ambito" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de ine:Contabilidad-->
    <xsl:for-each select="./ine:Contabilidad">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia Contabilidad-->
  <xsl:template match="ine:Contabilidad">
    <!--  Iniciamos el manejo de los nodos dependientes -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@IdContabilidad" />
    </xsl:call-template>
  </xsl:template>





  <xsl:template match="servicioparcial:parcialesconstruccion">
    <!-- Manejador de nodos tipo parcialesconstruccion -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumPerLicoAut"/>
    </xsl:call-template>
    <!--   Iniciamos el manejo de los nodos dependientes  -->
    <xsl:apply-templates select="./servicioparcial:Inmueble"/>
  </xsl:template>
  <xsl:template match="servicioparcial:Inmueble">
    <!--
  Iniciamos el tratamiento de los atributos de servicioparcial:Inmueble
    -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Calle"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NoExterior"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NoInterior"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Colonia"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Localidad"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Referencia"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Municipio"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Estado"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CodigoPostal"/>
    </xsl:call-template>
  </xsl:template>
  
  
  

  <!-- Manejador de nodos tipo notariospublicos:NotariosPublicos -->
  <xsl:template match="notariospublicos:NotariosPublicos">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Version"/>
    </xsl:call-template>

    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:apply-templates select="./notariospublicos:DescInmuebles"/>
    <xsl:apply-templates select="./notariospublicos:DatosOperacion"/>
    <xsl:apply-templates select="./notariospublicos:DatosNotario"/>
    <xsl:apply-templates select="./notariospublicos:DatosEnajenante"/>
    <xsl:apply-templates select="./notariospublicos:DatosAdquiriente"/>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DescInmuebles -->
  <xsl:template match="notariospublicos:DescInmuebles">

    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:for-each select="./notariospublicos:DescInmueble">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DescInmueble -->
  <xsl:template match="notariospublicos:DescInmueble">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoInmueble"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Calle"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NoExterior"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NoInterior"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Colonia"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Localidad"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Referencia"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Municipio"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Estado"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Pais"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CodigoPostal"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosOperacion -->
  <xsl:template match="notariospublicos:DatosOperacion">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumInstrumentoNotarial"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@FechaInstNotarial"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@MontoOperacion"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Subtotal"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@IVA"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosNotario -->
  <xsl:template match="notariospublicos:DatosNotario">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CURP"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumNotaria"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@EntidadFederativa"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Adscripcion"/>
    </xsl:call-template>


  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosEnajenante -->
  <xsl:template match="notariospublicos:DatosEnajenante">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CoproSocConyugalE"/>
    </xsl:call-template>

    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:if test="./notariospublicos:DatosUnEnajenante">
      <xsl:apply-templates select="./notariospublicos:DatosUnEnajenante"/>
    </xsl:if>

    <xsl:if test="./notariospublicos:DatosEnajenantesCopSC">
      <xsl:apply-templates select="./notariospublicos:DatosEnajenantesCopSC"/>
    </xsl:if>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosUnEnajenante -->
  <xsl:template match="notariospublicos:DatosUnEnajenante">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Nombre"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ApellidoPaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ApellidoMaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@RFC"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CURP"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosEnajenantesCopSC -->
  <xsl:template match="notariospublicos:DatosEnajenantesCopSC">

    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:for-each select="./notariospublicos:DatosEnajenanteCopSC">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosEnajenanteCopSC -->
  <xsl:template match="notariospublicos:DatosEnajenanteCopSC">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Nombre"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ApellidoPaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ApellidoMaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@RFC"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CURP"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Porcentaje"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosAdquiriente -->
  <xsl:template match="notariospublicos:DatosAdquiriente">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CoproSocConyugalE"/>
    </xsl:call-template>

    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:if test="./notariospublicos:DatosUnAdquiriente">
      <xsl:apply-templates select="./notariospublicos:DatosUnAdquiriente"/>
    </xsl:if>

    <xsl:if test="./notariospublicos:DatosAdquirientesCopSC">
      <xsl:apply-templates select="./notariospublicos:DatosAdquirientesCopSC"/>
    </xsl:if>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosUnAdquiriente -->
  <xsl:template match="notariospublicos:DatosUnAdquiriente">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Nombre"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ApellidoPaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ApellidoMaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@RFC"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@CURP"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosAdquirientesCopSC -->
  <xsl:template match="notariospublicos:DatosAdquirientesCopSC">

    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:for-each select="./notariospublicos:DatosAdquirienteCopSC">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!-- Manejador de nodos tipo notariospublicos:DatosAdquirienteCopSC -->
  <xsl:template match="notariospublicos:DatosAdquirienteCopSC">

    <!-- Iniciamos el tratamiento de los atributos -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Nombre"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ApellidoPaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ApellidoMaterno"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@RFC"/>
    </xsl:call-template>

    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@CURP"/>
    </xsl:call-template>

    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Porcentaje"/>
    </xsl:call-template>

  </xsl:template>




  <!-- Manejador de nodos tipo nomina -->
  <xsl:template match="nomina12:Nomina">
    <!--Manejador de nodos tipo Nomina-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Version" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoNomina" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@FechaPago" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@FechaInicialPago" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@FechaFinalPago" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumDiasPagados" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalPercepciones" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalDeducciones" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalOtrosPagos" />
    </xsl:call-template>

    <!--  Iniciamos el manejo de los elementos hijo en la secuencia -->
    <xsl:for-each select="./nomina12:Emisor">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:for-each select="./nomina12:Receptor">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:for-each select="./nomina12:Percepciones">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:for-each select="./nomina12:Deducciones">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:for-each select="./nomina12:OtrosPagos">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:for-each select="./nomina12:Incapacidades">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <xsl:template match="nomina12:Emisor">
    <!--Manejador de nodos tipo nomina12:Emisor-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Curp" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@RegistroPatronal" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@RfcPatronOrigen" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:EntidadSNCF-->
    <xsl:for-each select="./nomina12:EntidadSNCF">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia EntidadSNCF-->
  <xsl:template match="nomina12:EntidadSNCF">
    <!--  Iniciamos el manejo de los nodos dependientes -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@OrigenRecurso" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@MontoRecursoPropio" />
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="nomina12:Receptor">
    <!--Manejador de nodos tipo nomina12:Receptor-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Curp" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NumSeguridadSocial" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@FechaInicioRelLaboral" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Antigüedad" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoContrato" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Sindicalizado" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TipoJornada" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoRegimen" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumEmpleado" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Departamento" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Puesto" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@RiesgoPuesto" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@PeriodicidadPago" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@Banco" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@CuentaBancaria" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@SalarioBaseCotApor" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@SalarioDiarioIntegrado" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ClaveEntFed" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:SubContratacion-->
    <xsl:for-each select="./nomina12:SubContratacion">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia SubContratacion-->
  <xsl:template match="nomina12:SubContratacion">
    <!--  Iniciamos el manejo de los nodos dependientes -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@RfcLabora" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@PorcentajeTiempo" />
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="nomina12:Percepciones">
    <!--Manejador de nodos tipo nomina12:Percepciones-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalSueldos" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalSeparacionIndemnizacion" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalJubilacionPensionRetiro" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TotalGravado" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TotalExento" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:Percepcion-->
    <xsl:for-each select="./nomina12:Percepcion">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:JubilacionPensionRetiro-->
    <xsl:for-each select="./nomina12:JubilacionPensionRetiro">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:SeparacionIndemnizacion-->
    <xsl:for-each select="./nomina12:SeparacionIndemnizacion">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>
  <!--  Iniciamos el manejo de los elementos hijo en la secuencia Percepcion-->
  <xsl:template match="nomina12:Percepcion">
    <!--Manejador de nodos tipo nomina12:Percepcion-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoPercepcion" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Clave" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Concepto" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ImporteGravado" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ImporteExento" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:AccionesOTitulos-->
    <xsl:for-each select="./nomina12:AccionesOTitulos">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <!--  Iniciamos el tratamiento de los atributos de nomina12:HorasExtra-->
    <xsl:for-each select="./nomina12:HorasExtra">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia AccionesOTitulos-->
  <xsl:template match="nomina12:AccionesOTitulos">
    <!--  Iniciamos el manejo de los nodos dependientes -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ValorMercado" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@PrecioAlOtorgarse" />
    </xsl:call-template>
  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia HorasExtra-->
  <xsl:template match="nomina12:HorasExtra">
    <!--  Iniciamos el manejo de los nodos dependientes -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Dias" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoHoras" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@HorasExtra" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ImportePagado" />
    </xsl:call-template>
  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia JubilacionPensionRetiro-->
  <xsl:template match="nomina12:JubilacionPensionRetiro">
    <!--Manejador de nodos tipo nomina12:JubilacionPensionRetiro-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalUnaExhibicion" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalParcialidad" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@MontoDiario" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@IngresoAcumulable" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@IngresoNoAcumulable" />
    </xsl:call-template>
  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia SeparacionIndemnizacion-->
  <xsl:template match="nomina12:SeparacionIndemnizacion">
    <!--Manejador de nodos tipo nomina12:JubilacionPensionRetiro-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TotalPagado" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumAñosServicio" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@UltimoSueldoMensOrd" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@IngresoAcumulable" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@IngresoNoAcumulable" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="nomina12:Deducciones">
    <!--Manejador de nodos tipo nomina12:Deducciones-->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalOtrasDeducciones" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@TotalImpuestosRetenidos" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:Deduccion-->
    <xsl:for-each select="./nomina12:Deduccion">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia Deduccion-->
  <xsl:template match="nomina12:Deduccion">
    <!--Manejador de nodos tipo nomina12:Deduccion-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoDeduccion" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Clave" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Concepto" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Importe" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="nomina12:OtrosPagos">

    <!--  Iniciamos el tratamiento de los atributos de nomina12:OtroPago-->
    <xsl:for-each select="./nomina12:OtroPago">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia OtroPago-->
  <xsl:template match="nomina12:OtroPago">
    <!--Manejador de nodos tipo nomina12:OtroPago-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoOtroPago" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Clave" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Concepto" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Importe" />
    </xsl:call-template>

    <!--  Iniciamos el tratamiento de los atributos de nomina12:SubsidioAlEmpleo-->
    <xsl:for-each select="./nomina12:SubsidioAlEmpleo">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <!--  Iniciamos el tratamiento de los atributos de nomina12:CompensacionSaldosAFavor-->
    <xsl:for-each select="./nomina12:CompensacionSaldosAFavor">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia SubsidioAlEmpleo-->
  <xsl:template match="nomina12:SubsidioAlEmpleo">
    <!--Manejador de nodos tipo nomina12:SubsidioAlEmpleo-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@SubsidioCausado" />
    </xsl:call-template>
  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia CompensacionSaldosAFavor-->
  <xsl:template match="nomina12:CompensacionSaldosAFavor">
    <!--Manejador de nodos tipo nomina12:CompensacionSaldosAFavor-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@SaldoAFavor" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Año" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@RemanenteSalFav" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="nomina12:Incapacidades">
    <!--  Iniciamos el tratamiento de los atributos de nomina12:Incapacidades-->
    <xsl:for-each select="./nomina12:Incapacidad">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!--  Iniciamos el manejo de los elementos hijo en la secuencia Incapacidad-->
  <xsl:template match="nomina12:Incapacidad">
    <!--Manejador de nodos tipo nomina12:Incapacidad-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@DiasIncapacidad" />
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoIncapacidad" />
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@ImporteMonetario" />
    </xsl:call-template>

  </xsl:template>  
  
  

  <!-- Manejador de nodos tipo ecc:EstadoDeCuentaCombustible -->
  <xsl:template match="ecc:EstadoDeCuentaCombustible">
    <!-- Iniciamos el tratamiento de los atributos de ecc:EstadoDeCuentaCombustible -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@tipoOperacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@numeroDeCuenta"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@subTotal"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@total"/>
    </xsl:call-template>
    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:apply-templates select="./ecc:Conceptos"/>
  </xsl:template>

  <!-- Manejador de nodos tipo ecc:Conceptos -->
  <xsl:template match="ecc:Conceptos">
    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:for-each select="./ecc:ConceptoEstadoDeCuentaCombustible">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- Manejador de nodos tipo ecc:Traslados -->
  <xsl:template match="ecc:Traslados">
    <!-- Iniciamos el manejo de los nodos dependientes -->
    <xsl:for-each select="./ecc:Traslado">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- Manejador de nodos tipo ecc:ConceptoEstadoDeCuentaCombustible -->
  <xsl:template match="ecc:ConceptoEstadoDeCuentaCombustible">
    <!-- Iniciamos el tratamiento de los atributos de ecc:ConceptoEstadoDeCuentaCombustible -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@identificador"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@fecha"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@rfc"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@claveEstacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@cantidad"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@nombreCombustible"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@folioOperacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@valorUnitario"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@importe"/>
    </xsl:call-template>
    <xsl:for-each select="./ecc:Traslados">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- Manejador de nodos tipo ecc:Traslado -->
  <xsl:template match="ecc:Traslado">
    <!-- Iniciamos el tratamiento de los atributos de ecc:Traslado -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@impuesto"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@tasa"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@importe"/>
    </xsl:call-template>
  </xsl:template>



  <!-- Manejador de nodos tipo donat:Donatarias -->
  <xsl:template match="donat:Donatarias">
    <!-- Iniciamos el tratamiento de los atributos de donat:Donatarias -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@noAutorizacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@fechaAutorizacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@leyenda"/>
    </xsl:call-template>
  </xsl:template>


  <!-- Manejador de nodos tipo psgecfd:PrestadoresDeServiciosDeCFD -->
  <xsl:template match="psgecfd:PrestadoresDeServiciosDeCFD">
    <!-- Iniciamos el tratamiento de los atributos de psgecfd:PrestadoresDeServiciosDeCFD -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@nombre"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@rfc"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@noCertificado"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@fechaAutorizacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@noAutorizacion"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de nodos tipo divisas:Divisas -->
  <xsl:template match="divisas:Divisas">
    <!-- Iniciamos el tratamiento de los atributos de divisas:Divisas -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@tipoOperacion"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de nodos tipo detallista -->
  <xsl:template match="detallista:detallista">
    <!-- Iniciamos el tratamiento de los atributos del sector detallista -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@documentStructureVersion"/>
    </xsl:call-template>
    <xsl:for-each select="detallista:orderIdentification/detallista:referenceIdentification">
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="detallista:orderIdentification/detallista:ReferenceDate"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="detallista:buyer/detallista:gln"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="detallista:seller/detallista:gln"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="detallista:seller/detallista:alternatePartyIdentification"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="detallista:totalAmount/detallista:Amount"/>
    </xsl:call-template>
    <xsl:for-each select="detallista:TotalAllowanceCharge/detallista:specialServicesType">
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="detallista:TotalAllowanceCharge/detallista:Amount">
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Manejador de nodos tipo implocal -->
  <xsl:template match="implocal:ImpuestosLocales">
    <!--Iniciamos el tratamiento de los atributos de ImpuestosLocales -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TotaldeRetenciones"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TotaldeTraslados"/>
    </xsl:call-template>
    <xsl:for-each select="implocal:RetencionesLocales">
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@ImpLocRetenido"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@TasadeRetencion"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@Importe"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="implocal:TrasladosLocales">
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@ImpLocTrasladado"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@TasadeTraslado"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@Importe"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Manejador de nodos tipo PorCuentadeTerceros -->
  <xsl:template match="terceros:PorCuentadeTerceros">
    <!--Iniciamos el tratamiento de los atributos del complemento concepto Por cuenta de Terceros -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@rfc"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@nombre"/>
    </xsl:call-template>
    <!--Iniciamos el tratamiento de los atributos de la información fiscal del complemento de terceros -->
    <xsl:for-each select="./terceros:InformacionFiscalTercero">
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@calle"/>
      </xsl:call-template>
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="./@noExterior"/>
      </xsl:call-template>
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="./@noInterior"/>
      </xsl:call-template>
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="./@colonia"/>
      </xsl:call-template>
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="./@localidad"/>
      </xsl:call-template>
      <xsl:call-template name="Opcional">
        <xsl:with-param name="valor" select="./@referencia"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@municipio"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@estado"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@pais"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@codigoPostal"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- Manejo de los atributos de la información aduanera del complemento de terceros -->
    <xsl:for-each select=".//terceros:InformacionAduanera">
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@numero"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@fecha"/>
      </xsl:call-template>
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@aduana"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- Manejo de los atributos de la cuenta predial del complento de terceros -->
    <xsl:for-each select=".//terceros:CuentaPredial">
      <xsl:call-template name="Requerido">
        <xsl:with-param name="valor" select="./@numero"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>



  <!-- Aquí iniciamos el procesamiento de la cadena original con su | inicial y el terminador || -->
	<xsl:template match="/">|<xsl:apply-templates select="/cfdi:Comprobante"/>||</xsl:template>
	<!--  Aquí iniciamos el procesamiento de los datos incluidos en el comprobante -->
	<xsl:template match="cfdi:Comprobante">
		<!-- Iniciamos el tratamiento de los atributos de comprobante -->
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@version"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@fecha"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@tipoDeComprobante"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@formaDePago"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@condicionesDePago"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@subTotal"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@descuento"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@TipoCambio"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@Moneda"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@total"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@metodoDePago"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@LugarExpedicion"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@NumCtaPago"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@FolioFiscalOrig"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@SerieFolioFiscalOrig"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@FechaFolioFiscalOrig"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@MontoFolioFiscalOrig"/>
		</xsl:call-template>
		<!--
			Llamadas para procesar al los sub nodos del comprobante
		-->
		<xsl:apply-templates select="./cfdi:Emisor"/>
		<xsl:apply-templates select="./cfdi:Receptor"/>
		<xsl:apply-templates select="./cfdi:Conceptos"/>
		<xsl:apply-templates select="./cfdi:Impuestos"/>
		<xsl:apply-templates select="./cfdi:Complemento"/>
	</xsl:template>
	<!-- Manejador de nodos tipo Emisor -->
	<xsl:template match="cfdi:Emisor">
		<!-- Iniciamos el tratamiento de los atributos del Emisor -->
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@rfc"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@nombre"/>
		</xsl:call-template>
		<!--
			Llamadas para procesar al los sub nodos del comprobante
		-->
		<xsl:apply-templates select="./cfdi:DomicilioFiscal"/>
		<xsl:if test="./cfdi:ExpedidoEn">
			<xsl:call-template name="Domicilio">
				<xsl:with-param name="Nodo" select="./cfdi:ExpedidoEn"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:for-each select="./cfdi:RegimenFiscal">
			<xsl:call-template name="Requerido">
				<xsl:with-param name="valor" select="./@Regimen"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Manejador de nodos tipo Receptor -->
	<xsl:template match="cfdi:Receptor">
		<!-- Iniciamos el tratamiento de los atributos del Receptor -->
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@rfc"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@nombre"/>
		</xsl:call-template>
		<!--
			Llamadas para procesar al los sub nodos del Receptor
		-->
		<xsl:if test="./cfdi:Domicilio">
			<xsl:call-template name="Domicilio">
				<xsl:with-param name="Nodo" select="./cfdi:Domicilio"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- Manejador de nodos tipo Conceptos -->
	<xsl:template match="cfdi:Conceptos">
		<!-- Llamada para procesar los distintos nodos tipo Concepto -->
		<xsl:for-each select="./cfdi:Concepto">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<!-- Manejador de nodos tipo Impuestos -->
	<xsl:template match="cfdi:Impuestos">
		<xsl:for-each select="./cfdi:Retenciones/cfdi:Retencion">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@totalImpuestosRetenidos"/>
		</xsl:call-template>
		<xsl:for-each select="./cfdi:Traslados/cfdi:Traslado">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@totalImpuestosTrasladados"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Manejador de nodos tipo Retencion -->
	<xsl:template match="cfdi:Retencion">
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@impuesto"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@importe"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Manejador de nodos tipo Traslado -->
	<xsl:template match="cfdi:Traslado">
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@impuesto"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@tasa"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@importe"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Manejador de nodos tipo Complemento -->
	<xsl:template match="cfdi:Complemento">
		<xsl:for-each select="./*">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<!--
		Manejador de nodos tipo Concepto
	-->
	<xsl:template match="cfdi:Concepto">
		<!-- Iniciamos el tratamiento de los atributos del Concepto -->
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@cantidad"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@unidad"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@noIdentificacion"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@descripcion"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@valorUnitario"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@importe"/>
		</xsl:call-template>
		<!--
			Manejo de los distintos sub nodos de información aduanera de forma indistinta 
			a su grado de dependencia
		-->
		<xsl:for-each select=".//cfdi:InformacionAduanera">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		<!-- Llamada al manejador de nodos de Cuenta Predial en caso de existir -->
		<xsl:if test="./cfdi:CuentaPredial">
			<xsl:apply-templates select="./cfdi:CuentaPredial"/>
		</xsl:if>
		<!-- Llamada al manejador de nodos de ComplementoConcepto en caso de existir -->
		<xsl:if test="./cfdi:ComplementoConcepto">
			<xsl:apply-templates select="./cfdi:ComplementoConcepto"/>
		</xsl:if>
	</xsl:template>
	<!-- Manejador de nodos tipo Información Aduanera -->
	<xsl:template match="cfdi:InformacionAduanera">
		<!-- Manejo de los atributos de la información aduanera -->
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@numero"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@fecha"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@aduana"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Manejador de nodos tipo Información CuentaPredial -->
	<xsl:template match="cfdi:CuentaPredial">
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@numero"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Manejador de nodos tipo ComplementoConcepto -->
	<xsl:template match="cfdi:ComplementoConcepto">
		<xsl:for-each select="./*">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<!-- Manejador de nodos tipo Domicilio fiscal -->
	<xsl:template match="cfdi:DomicilioFiscal">
		<!-- Iniciamos el tratamiento de los atributos del Domicilio Fiscal -->
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@calle"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@noExterior"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@noInterior"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@colonia"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@localidad"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="./@referencia"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@municipio"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@estado"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@pais"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="./@codigoPostal"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Manejador de nodos tipo Domicilio -->
	<xsl:template name="Domicilio">
		<xsl:param name="Nodo"/>
		<!-- Iniciamos el tratamiento de los atributos del Domicilio  -->
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@calle"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@noExterior"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@noInterior"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@colonia"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@localidad"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@referencia"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@municipio"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@estado"/>
		</xsl:call-template>
		<xsl:call-template name="Requerido">
			<xsl:with-param name="valor" select="$Nodo/@pais"/>
		</xsl:call-template>
		<xsl:call-template name="Opcional">
			<xsl:with-param name="valor" select="$Nodo/@codigoPostal"/>
		</xsl:call-template>
	</xsl:template>

  <!-- Manejador de nodos tipo iedu -->
  <xsl:template match="iedu:instEducativas">
    <!--Iniciamos el tratamiento de los atributos de instEducativas -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@nombreAlumno"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@CURP"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@nivelEducativo"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@autRVOE"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@rfcPago"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de nodos tipo leyendasFiscales -->
  <xsl:template match="leyendasFisc:LeyendasFiscales">
    <!--Iniciamos el tratamiento de los atributos del complemento LeyendasFiscales -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <!-- Manejo de los atributos de las leyendas Fiscales-->
    <xsl:for-each select="./leyendasFisc:Leyenda">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>
  <!-- Manejador de nodos tipo Información de las leyendas -->
  <xsl:template match="leyendasFisc:Leyenda">
    <!-- Manejo de los atributos de la leyenda -->
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@disposicionFiscal"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@norma"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@textoLeyenda"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de nodos tipo pfic:PFintegranteCoordinado -->
  <xsl:template match="pfic:PFintegranteCoordinado">
    <!-- Iniciamos el tratamiento de los atributos de pfic:PFintegranteCoordinado -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ClaveVehicular"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Placa"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@RFCPF"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de nodos tipo tpe:TuristaPasajeroExtranjero -->
  <xsl:template match="tpe:TuristaPasajeroExtranjero">
    <!--Iniciamos el tratamiento de los atributos de tpe:TuristaPasajeroExtranjero-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@fechadeTransito"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@tipoTransito"/>
    </xsl:call-template>
    <xsl:apply-templates select="./tpe:datosTransito"/>
  </xsl:template>
  <!-- Manejador de nodos tipo datosTransito-->
  <xsl:template match="tpe:datosTransito">
    <!-- Iniciamos el tratamiento de los atributos de los datos de Transito-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Via"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@TipoId"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@NumeroId"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Nacionalidad"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@EmpresaTransporte"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@IdTransporte"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Manejador de nodos tipo VehiculoUsado-->  
    <xsl:template match="vehiculousado:VehiculoUsado">
    <!-- Iniciamos el tratamiento de los atributos de comprobante -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@Version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@montoAdquisicion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@montoEnajenacion"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@claveVehicular"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@marca"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@tipo"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@modelo"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@numeroMotor"/>
    </xsl:call-template>
        <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@numeroSerie"/>
    </xsl:call-template>
        <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@NIV"/>
    </xsl:call-template>
        <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@valor"/>
    </xsl:call-template>
    <!--
			Llamadas para procesar al los sub nodos
		-->
    <xsl:apply-templates select="./vehiculousado:InformacionAduanera"/>
  </xsl:template>
  <!-- Manejador de nodos tipo informacionaduanera -->
  <xsl:template match="vehiculousado:InformacionAduanera">
    <!-- Iniciamos el tratamiento de los atributos del Emisor -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@numero"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@fecha"/>
    </xsl:call-template>
        <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@aduana"/>
    </xsl:call-template>
    </xsl:template>  

	
	
  <!-- Manejador de nodos tipo VentaVehiculos-->
  <xsl:template match="ventavehiculos:VentaVehiculos">
    <!--Iniciamos el tratamiento de los atributos del complemento concepto VentaVehiculos-->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@version"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@ClaveVehicular"/>
    </xsl:call-template>
    <!-- Manejo de los atributos de la información aduanera del complemento de terceros -->
    <xsl:for-each select=".//ventavehiculos:InformacionAduanera">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>
  <!-- Manejador de nodos tipo Información Aduanera -->
  <xsl:template match="ventavehiculos:InformacionAduanera">
    <!-- Manejo de los atributos de la información aduanera -->
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@numero"/>
    </xsl:call-template>
    <xsl:call-template name="Requerido">
      <xsl:with-param name="valor" select="./@fecha"/>
    </xsl:call-template>
    <xsl:call-template name="Opcional">
      <xsl:with-param name="valor" select="./@aduana"/>
    </xsl:call-template>
  </xsl:template>

  
  
  
  
</xsl:stylesheet>
