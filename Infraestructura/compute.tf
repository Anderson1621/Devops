/**********************************************************************************************/
/** Creacion de grupo de seguridad instancia EC2                                                                                   **/
/**********************************************************************************************/

resource "aws_security_group" "instance_sg" {
  name                   = "instance_sg"
  vpc_id                 = aws_vpc.default.id
  revoke_rules_on_delete = true

  ingress {
    from_port   = "2222"
    to_port     = "2222"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65355
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65355
    cidr_blocks = ["10.128.0.0/16"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


/**********************************************************************************************/
/** Creacion grupo de seguridad RDS                                                                                      **/
/**********************************************************************************************/


resource "aws_security_group" "rds_sg" {
  name                   = "rds_sg"
  vpc_id                 = aws_vpc.default.id
  revoke_rules_on_delete = true

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65355
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65355
    cidr_blocks = ["10.128.0.0/16"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

/**********************************************************************************************/
/** Creacion instancia EC2                                                                                      **/
/**********************************************************************************************/
resource "aws_instance" "instance" {
  ami                         = "ami-0528007a60177dd84"
  instance_type               = "t3a.micro"
  #la llave de ssh debe estar creada previamente
  key_name                    = "pruebaDevops"
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  subnet_id                   = element(aws_subnet.public_subnets.*.id, 0)
  associate_public_ip_address = true
  
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y mysql-utilities
sudo apt-get install -y unzip
sudo apt install -y mysql-client-core-5.7 
sudo apt install -y mysql-client-5.7
sudo apt install -y expect
perl -pi -e 's/^#?Port 22$/Port 2222/' /etc/ssh/sshd_config
service sshd restart || service ssh restart
EOF

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}


// DB Subnet groups 
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-${aws_vpc.default.id}-db-subnet-groups"
  subnet_ids = aws_subnet.db_private_subnets.*.id

}

/**********************************************************************************************/
/** Creacion de cluster RDS                                                                                      **/
/**********************************************************************************************/

resource "aws_rds_cluster" "general_purpose_cluster_rds" {
  database_name      = "Prueba"
  master_username    = "admin"
  master_password    = "admin123"
  
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.07.1"
  engine_mode                     = "serverless"
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  port                            = 3306
  backtrack_window                = 0 
  skip_final_snapshot             = false
  copy_tags_to_snapshot           = true
  deletion_protection             = true
  storage_encrypted               = true
}
