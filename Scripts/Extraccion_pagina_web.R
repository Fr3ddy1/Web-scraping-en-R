#Forma de extraer en tiempo real datos de dolar Dicom y dolar Airtm
#a partir de la página de una página web
#Extraigo precio Dicom
#cargo librería a usar
library(rvest)

#ingreso página web a anañizar
webpage <- read_html("http://www.bcv.org.ve")

#obtengo precio compra 
results <- webpage %>% html_nodes("div")

#selecciono la tasa de Cambio $/BsS
b <- as.character(xml_child(xml_child(xml_child(results[[70]], 7), 1), 1))
b

#extraigo información importante
b1 <- regexpr('strong', b)[1]
b2 <- substr(b, b1+8, b1+16)
b3 <- gsub("\\.", "",b2)
b4 <- gsub(",", ".",b3)
b5 <- as.numeric(b4)

#imprimo precio del Dolar en tiempo real
b5

#Extraigo precio Airtm

#modifico página web donde se realizará la busqueda
webpage <- read_html("https://rates.airtm.io")

#obtengo precio compra 
a <- xml_attrs(xml_child(xml_child(webpage, 1), 4))[["content"]]

#extraigo información importante
a1 <- regexpr('T.C:', a)[1]
a2 <- as.numeric(substr(a, a1+5, a1+12))

#imprimo tasa de compra del $/BsS
a2

#Extraigo precio Dolar Today

#modifico página web donde se realizará la busqueda
webpage <- read_html("https://dolartoday.com/")

#obtengo precio compra 
#a <- xml_attrs(xml_child(xml_child(webpage, 1), 4))[["content"]]
a <- (xml_child(xml_child(webpage, 1), 15))

#extraigo información importante
a1 <- regexpr('Bs.', a)[1]
a1
a2 <- as.numeric(gsub(",", ".",substr(a, a1+4, a1+11)))

#imprimo tasa de compra del $/BsS
a2

     