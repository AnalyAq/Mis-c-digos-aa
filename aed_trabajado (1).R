#Establecemosnuestro directorio de trabajo
setwd("C:/Users/USER/OneDrive/UNALM/MATERIAL/6_CICLO/Técnicas Estadísticas/costa_sur/estaciones")

#Importamos nuestro archivo de estación
data <- read.table("puntacoles.txt",na.strings = -99.9)

#Que tipo de objeto tengo?
class(data)

#Visualizamos lo primeros datos
head(data,10)
tail(data,10)

#Establecemos los nombres de columnas   
colnames(data) <- c("Año","Mes","Dia","Pp","Tmax","Tmin")

###Funciones importantes:

#¿Que columnas tengo?
str(data)

#Dimensiones
dim(data)

length(data$Pp)


#Creamos vector de fecha
data$Fecha <- as.Date(paste0(data$Año,"-",data$Mes,"-",data$Dia))

class(paste0(data$Año,"-",data$Mes,"-",data$Dia))

#Tipo de objeto
class(data$Fecha)
data
head(data)

###Estadísticos básicos

#Cantidad de NAs de cada columna
sum(data$Pp)
sum(data$Pp,na.rm=T)

sum(is.na(data$Pp))
sum(is.na(data$Tmax))
sum(is.na(data$Tmin))

#Mínimo
min(data$Pp,na.rm=T)
#Máximo
max(data$Pp,na.rm=T)

#Rango
range(data$Pp,na.rm=T)

max(data$Pp,na.rm=T) - min(data$Pp,na.rm=T)

#media
mean(data$Pp,na.rm=T)

#mediana
median(data$Pp,na.rm=T)

#Cuartiles
quantile(data$Pp,na.rm=T, c(0.25,0.5,0.75))

#Rango intercuartilico  Q3-Q1
IQR(data$Pp,na.rm=T)

#Desviación estándar
sd(data$Pp,na.rm=T)

#Varianza
var(data$Pp,na.rm=T)

sd(data$Pp,na.rm=T)^2

#Resumen estadístico
summary(data)

#¿Quieres aun más estadísticos?

#install.packages("hydroTSM")
library(hydroTSM)

smry(data[,4:6])

hist(data$Tmin)

write.table(smry(data[,4:6]),"est_503.csv",row.names = F)

#pue ser write.csv

#cv = sd / mean
#skewness (sesgo o asimetria) -> medida de la simetría de la distribución de los datos
#+ = distribución tiene una cola más larga hacia la derecha (asimetría positiva
#- = cola más larga hacia la izquierda (asimetría negativa)
#~0 = distribucion mas simetrica (normal)

#kurtosis -> describe las características de las colas de una distribución en relación con una distribución normal
#+ Kurtosis: Los datos tienen más valores extremos
#- Kurtosis: Los datoos estan mas repartidos

#######Graficado

####Métodos de ploteo

###1) Grafico con R base
plot(data$Fecha,data$Pp,type="p",pch=16,col="green",main="Precipitacion Estación ILO",xlab="Fecha",ylab="Precipitación")

barplot(data$Pp, names.arg = data$Fecha, main = "Precipitación Estación PUNTACOLES", 
        xlab = "Fecha", ylab = "Precipitación", col = "blue", border = "blue")

plot(data$Fecha,data$Tmax,type="l",col="red",main="Temperatura máxima Estación .............",xlab="Fecha",ylab="Temperatura")
plot(data$Fecha,data$Tmin,type="l",col="blue",main="Temperatura mínima Estación .............",xlab="Fecha",ylab="Temperatura")


###2) Grafico con Ggplot2 (Recomendable)
#install.packages("ggplot2")
library(ggplot2)

###Grafico
ggplot(data,aes(x=Fecha,y=Pp))+
  geom_point(col="blue")+ggtitle("Precipitación Estación ........")




# se guarda la grafica en una variable

g1 <- ggplot(data,aes(x=Fecha,y=Pp))+
  geom_point(col="green")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  xlab("Fecha")+ylab("Precipitación (mm)")+theme_bw()+ggtitle("Precipitación Estación PUNTACOLES")

g2 <- ggplot(data,aes(x=Fecha,y=Tmax))+
  geom_line(col="red")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  xlab("Fecha")+ylab("Temperatura máx (°C)")+theme_bw()+ggtitle("Temperatura Máxima Estación PUNTACOLES")

g3 <- ggplot(data,aes(x=Fecha,y=Tmin))+
  geom_line(col="blue")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  xlab("Fecha")+ylab("Temperatura mín (°C)")+theme_bw()+ggtitle("Temperatura Mínima Estación PUNTACOLES")


#Gráficos interactivos
#install.packages("plotly")
library(plotly)
ggplotly(g1)
ggplotly(g2)
ggplotly(g3) 

subplot(g1,g2,g3)


#install.packages("tidyr")
#install.packages("dplyr")
library(tidyr)
library(dplyr)
#install.packages("reshape2")
library(reshape2)
# Asegúrate de cargar los datos primero
library(ggplot2)
head(data)
# Transformar los datos de ancho a largo usando melt
# Reorganiza el dataframe en función a una o más columnas establecidas
# En este caso se tendrá 1 Columna de fecha,otra de nombre de variable y otra con los valores de las variables
datos_melted <- melt(data, id.vars = c("Fecha"), measure.vars = c("Tmax", "Tmin", "Pp"))

head(datos_melted,15)


# Crear un gráfico separado para cada variable
grafico <- ggplot(data = datos_melted, aes(x = Fecha, y = value, color = variable)) +
  geom_line(data = subset(datos_melted, variable == c("Tmax", "Tmin")), linewidth = 0.8) +  
  geom_point(data = subset(datos_melted, variable == "Pp"), size = 2) +
  labs(x = "Fecha", y = "") +
  scale_x_date(date_labels = "%Y", date_breaks = "3 year")+
  facet_wrap(~ variable, scales = "free_y", nrow = 3) +  # Separar uno debajo del otro
  theme_bw() +
  theme(legend.position = "none")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"),  strip.text = element_text(color = "black", face = "bold"),strip.background = element_rect(fill="white",color=NA))+
  theme(axis.title = element_text(face = "bold"))+ggtitle("Serie temporal diaria Estación ILO")+
  scale_color_manual(values = c("red", "blue", "green"))

# Mostrar el gráfico
grafico

library(plotly)
ggplotly(grafico)

#Exportar
ggsave(plot=grafico,file="st_puntacoles.png", width = 9, height = 8)




############################ Medias mensuales

###########Cálculo de medias de temperatura y acumulados de pp mensuales

#Función para aplicar suma a un objeto, si todo es NA o hay mas de 5 NA que el resultado sea NA
sum_na <- function(x) {if (all(is.na(x)) == TRUE | sum(is.na(x)) >5) {NA} else {sum(x, na.rm = TRUE)}}

mean_na <- function(x) {if (all(is.na(x)) == TRUE | sum(is.na(x)) >5) {NA} else {mean(x, na.rm = TRUE)}}


sum_na(c(1,3,NA,NA,NA,NA,NA))

sum(c(1,2,45,NA), na.rm = T)
sum(c(NA,NA,NA),na.rm = T)

###############No olvidar para Temperaturas se trabaja con medias, mientras que precipitación acumulados.

#Método 1

#Paquete xts. Trabajando con series de tiempo
#install.packages('xts')
library(xts)

#Transformando columna a fecha
data$Fecha <- as.Date(data$Fecha)

# Crear un objeto xts (Serie de tiempo)
datos_xts <- xts(data[,4:6], order.by = data$Fecha)

# Calcular medias mensuales
pp_month <- apply.monthly(datos_xts$Pp, sum_na)
tmin_month <- apply.monthly(datos_xts$Tmin, mean_na)
tmax_month <- apply.monthly(datos_xts$Tmax, mean_na)

data_month <- data.frame(Fecha = as.Date(index(pp_month)),Pp =coredata(pp_month),Tmax=coredata(tmax_month),Tmin=coredata(tmin_month))




#M?todo 2 librer?a dplyr

#install.packages('dplyr')
library(dplyr)
prom_m <- data %>% group_by(Año,Mes) %>%
  summarise(Tmax = mean_na(Tmax), Tmin = mean_na(Tmin),Pp=sum_na(Pp))

Fecha <- seq.Date(as.Date("1965-01-01"),as.Date("2019-12-01"),by="month")
prom_m <- data.frame(prom_m,Fecha)
head(prom_m,15) 


#install.packages('reshape')
library(reshape2)
##################Box plot
prom_m$Mes <- rep(c("Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"),2019-1965+1) 
prom_m$Mes <- factor(prom_m$Mes,levels = c("Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"))

##Reorganiza el dataframe en función a una o más columnas establecidas
data_box <- melt(prom_m, id.vars = c("Mes"), measure.vars = c("Tmax", "Tmin", "Pp"))

library(ggplot2)
boxplot <- ggplot(data = data_box, aes(x = Mes, y = value,fill=Mes)) +
  geom_boxplot() +
  labs(x = "Fecha", y = "")+
  facet_wrap(~ variable, scales = "free_y", nrow = 3) +  # Separar uno debajo del otro
  theme_bw() +
  theme(legend.position = "none")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"),  strip.text = element_text(color = "black", face = "bold"),strip.background = element_rect(fill="white",color=NA))+
  theme(axis.title = element_text(face = "bold"))+ggtitle("Diagrama de cajas mensual Estación PUNTACOLES")+
  stat_summary(fun=mean,geom="point",shape=18,color="red",size=2)


#Exportar
ggsave(plot=boxplot,file="cajas_puntacoles.png", width = 8, height = 9)
library(plotly)
ggplotly(boxplot)

#install.packages("htmlwidgets")
library(htmlwidgets)
htmlwidgets::saveWidget(ggplotly(boxplot),"cajas_puntacoles.html")


#################################EXTRAA

##############Climograma: Gráfico en el que se representan las temperaturas y las precipitaciones de un lugar, normalmente a lo largo de un año.
#Así, el análisis de un climograma permite deducir las principales características que definen el clima de un determinado lugar.

library(hydroTSM) #Paquete para el análisis de datos de precipitaciones
#install.packages('zoo')
library(zoo) #Similar a xts para el manejo de series de tiempo

head(data)
data_serie <- zoo(data[,4:6],data$Fecha)
head(data_serie,10)

png("climat_puntacoles.png",width=12, height=7,res=700,units ="in")
climograph(pcp=data_serie$Pp, tmx=data_serie$Tmax, tmn=data_serie$Tmin, na.rm=TRUE,
           main="Estación PUNTACOLES", 
           pcp.label="Precipitación (mm)", 
           tmean.label="Temperatura (°C)")

dev.off()

