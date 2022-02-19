# Devops


# 1. Codificacion
# Se crea una funcion lambda sencilla que usa node para insertar una cantidad de registros #dependiendo de la variable iterador, esto se hace con el fin de poder realizarle en un futuro #pruebas de ETL a la base de datos, se agregara un archivo txt que posee los comandos aws cli #pertinentes para poder realizar correctamente el despliegue. 


# 2. Infraestructa
# Se crean varios archivos como infraestructura de codigo en los cuales estan 

# Compute.tf este archivo contiene todo lo relacionado con la creacion del cluster RDS 
# como la instancia EC2 y los grupos de seguridad

# network.tf este archivo tiene como finalidad la creacion de la VPC y las subredes relacionadas

# variables.tf es el archivo que contiene las variables de configuracion de la infraestructura como
# codigo, cabe destacar que se eligio terraform ya que internamente es lo que estan usando aunque este tipo de temas tambien se pueden hacer sin problema con SAM de CloudFormation.

# Se creo una carpeta con el nombre de documentacion en la cual se encuentran unos archivos txt que contienen algunos comandos a tener en cuenta y se agrego como imagen el diagrama de infraestructura.

# 3. Automatizacion

# Se creo un archivo jenkins file que basicamente posee los stage necesarios para realizar el despliegue de la infraestructura, cabe destacar que para probar hay que agregar los datos de la cuenta de aws ya que se uso con mi cuenta personal y con unas imagenes docker que tengo previamente guardadas en mi cuenta 
