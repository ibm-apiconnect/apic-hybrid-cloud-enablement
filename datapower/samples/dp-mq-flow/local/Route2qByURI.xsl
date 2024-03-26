<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions"
	xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:stat="http://www.tempura.org/Stateful/"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig">
	<xsl:output method="xml" encoding="UTF-8" indent="no" />


	<xsl:template match="/">

		   <xsl:variable name="uriIN" select="dp:variable('var://service/URI')" />  

       <xsl:variable name="inQueue" select="substring-after($uriIN,'/queue/')" />


     <xsl:if test="string-length(normalize-space($inQueue)) > 0">  
     	     
       <xsl:variable name="target" select="concat('dpmq://MQFYRE/?RequestQueue=',$inQueue)" />
       
 		   <xsl:message dp:priority="debug"><xsl:copy-of select="$target"/></xsl:message>        

			 <dp:set-variable name="'var://service/routing-url'" value="$target" /> 
     
     </xsl:if>
      
        
    </xsl:template>

 </xsl:stylesheet>
        

	
