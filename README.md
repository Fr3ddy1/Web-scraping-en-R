# Web-scraping-en-R

Este script permite extraer información ó un documento a partir desde una página Web

Extraer información a partir de una página Web
----------------------------------------------

### Extraer precio Dolar Dicom

Para este ejemplo se extraerá el precio actual de Dolar Oficial Dicom,
el cual se encuentra en la página del BCV. La librería para lograr este
fin es "rvest",

    #cargo librería a usar
    library(rvest)

    ## Warning: package 'rvest' was built under R version 3.5.2

    ## Loading required package: xml2

Una vez cargada la librería, le indico a la función "read\_html" la
página Web que se quiere explorar,

    #ingreso página web a anañizar
    webpage <- read_html("http://www.bcv.org.ve")

Luego de esto, usando la función "html\_nodes" es posible extraer del
código html de la página los contenedores donde se encuentra la
información deseada,

    #obtengo precio compra 
    results <- webpage %>% html_nodes("div")

Una vez ubicada la información la extraemos y la guardamos en la
variable "b",

    #selecciono la tasa de Cambio $/BsS
    b <- as.character(xml_child(xml_child(xml_child(results[[70]], 7), 1), 1))
    b

    ## [1] "<div class=\"row recuadrotsmc\">\n\t\t\t<div class=\"col-sm-6 col-xs-6\">\n  \t\t\t<img src=\"/sites/default/files/dollar-04.png\" class=\"icono_bss_blanco\"><span> Bs/USD</span>\t </div>\n                          <div class=\"col-sm-6 col-xs-6\">\n<strong> 23.675,60 </strong> </div>\n\t        </div>"

Como se puede apreciar la información deseada se encuentra en dicha
variable, pero con mucha mas información, por tal motivo es necesario
extraer sólo el valor numérico de la tasa deseada. Para ello primero
ubico la palabra "strong" para así conocer la ubicación de la misma con
respecto a la cadena de caracteres que se encuentra en la variable "b",

    #extraigo información importante
    b1 <- regexpr('strong', b)[1]
    b1

    ## [1] 231

Una vez conocida esta posición, usando la función "substr" del paquete
base, es posible extraer el precio deseado. Es importante señalar que en
este caso los valores "8" y "16" son los espacios necesarios para que el
valor de la tasa sea extraida de manera satisfactoria.

    b2 <- substr(b, b1+8, b1+16)
    b2

    ## [1] "23.675,60"

Luego de estraer la tasa, a la misma se le debe hacer una trasnformación
pues es necesario cambiar la "," por el ".", para así obtener un valor
numérico que reconozca R. Para ello primero se debe eliminar el "." que
se utiliza como separador de miles, este caracter se reemplaza por el
caracter vacio "". Despues de esto la "," se reemplaza por el ".".

    b3 <- gsub("\\.", "",b2)
    b3

    ## [1] "23675,60"

    b4 <- gsub(",", ".",b3)
    b4

    ## [1] "23675.60"

Finalmente obtengo el valor numérico de la tasa que deseo conocer,

    b5 <- as.numeric(b4)
    b5

    ## [1] 23675.6

### Extraer precio Dolar Airtm

Para realizar esta extracción el procedimiento es similar al explicado
anteriormente, primero se debe pasarle a la función "read\_html" la
página web a revisar, luego se ubica la información a extraer,
finalmente se extrae la información y se convierte en un valor numérico,

    #Extraigo precio Airtm

    #modifico página web donde se realizará la busqueda
    webpage <- read_html("https://rates.airtm.io")

    #obtengo precio compra 
    a <- xml_attrs(xml_child(xml_child(webpage, 1), 4))[["content"]]

    #extraigo información importante
    a1 <- regexpr('T.C:', a)[1]
    a1

    ## [1] 18

    a2 <- as.numeric(substr(a, a1+5, a1+12))

    #imprimo tasa de compra del $/BsS
    a2

    ## [1] 20763.03

Es importante señalar que los valores extraidos fueron transformados a
número con el fin de realizar operaciones con los mismos. De hecho este
proceso se puede repetir cada hora y así crear un histórico a partir del
cual se puede generar brechas y gráficos que pueden resultar muy
interesantes e informativos.



