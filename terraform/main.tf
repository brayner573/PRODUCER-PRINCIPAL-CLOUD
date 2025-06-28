provider "aws" {
  region = var.aws_region
  
}

resource "aws_s3_bucket" "producer_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_iam_role" "lambda_exec_role" {
   name = "lambda_exec_role_terraform_Cuba" # update

   assume_role_policy = jsonencode({
     Version = "2012-10-17",
     Statement = [{
       Action = "sts:AssumeRole",
       Principal = {
         Service = "lambda.amazonaws.com"
       },
       Effect = "Allow",
       Sid = ""
     }]
  })
} 


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/function.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  role = aws_iam_role.lambda_exec_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.13"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

 environment {
   variables = {
     ENV = "dev"
    }
  }
}
