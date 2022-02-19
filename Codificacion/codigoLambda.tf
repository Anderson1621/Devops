provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "pruebaDevops" {
  function_name = "pruebaDevops"

  # Parametros de entrada tanto bucket como archivo principal"
  s3_bucket = "pruebaDevops"
  s3_key    = "v1.0.0/main.zip"

  handler = "main.handler"
  runtime = "nodejs6.10"

  role = "${aws_iam_role.lambda_exec.arn}"
}

# Se debe crear un rol para que pueda ejecutar la lambda.
# cabe destacar que este rol es el pre-definido por aws para la ejecucion de las lambdas
resource "aws_iam_role" "lambda_exec" {
  name = "pruebaDevops"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


#Se crea el recurso de api gateway
resource "aws_api_gateway_rest_api_pruebaDevops" "pruebaDevops" {
  name        = "pruebaDevops"
  description = "Api gateway "
}


#Se crea el recurso del api
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.id}"
  parent_id   = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.root_resource_id}"
  path_part   = "{proxy+}"
}

#Se crea el metodo del api
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.id}"
  resource_id   = "${aws_api_gateway_rest_api_pruebaDevops.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

#Se crea la integracion del api esto con el fin de especificar las solicitudes entrantes al api
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.pruebaDevops.invoke_arn}"
}


#se crea el metodo para especificar la ruta del proxy
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.id}"
  resource_id   = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}


#Se crea la integracion ya con la ruta del proxy
resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api_pruebaDevops.example.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.pruebaDevops.invoke_arn}"
}


#Se realiza el despliegue del api
resource "aws_api_gateway_deployment" "pruebaDevops" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api_pruebaDevops.pruebaDevops.id}"
  stage_name  = "test"
}


#Se le asignan los permisos para que el api pueda acceder a la lambda y poder ejecutarla
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.pruebaDevops.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.pruebaDevops.execution_arn}/*/*"
}