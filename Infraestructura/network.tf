/**********************************************************************************************/
/** VPC                                                                                      **/
/**********************************************************************************************/
resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = "true"
}


/**********************************************************************************************/
/** Creacion de subredes                                                                                      **/
/**********************************************************************************************/
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.default.id
  cidr_block = "${var.cidr_block_base}.${count.index + var.subnets_by_product * var.general_purpose_index}.0/24"
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  count = length(var.availability_zones) 
}

/**********************************************************************************************/
/** Creacion de subredes para base de datos                                                                                      **/
/**********************************************************************************************/

resource "aws_subnet" "db_private_subnets" {
  vpc_id                  = aws_vpc.default.id
  cidr_block = "${var.cidr_block_base}.${count.index + var.subnets_by_product * var.general_purpose_index + 3}.0/24" 
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  count = length(var.availability_zones)
}


/**********************************************************************************************/
/** Creacion de internet gateway para salida a internet                                                                                      **/
/**********************************************************************************************/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id
}


/**********************************************************************************************/
/** creacion de tabla de enturamiento                                                                                      **/
/**********************************************************************************************/
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

/**********************************************************************************************/
/** Asociacion de las subredes a la tabla de enrutamiento                                                     **/
/**********************************************************************************************/
resource "aws_route_table_association" "public_table_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}