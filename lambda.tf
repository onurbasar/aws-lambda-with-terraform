locals {
  lambda_zip_path = "output/${var.PROJECT}.zip"
}

data archive_file "lambda-with-terraform-zip" {
  type = "zip"
  source_file = "${var.PROJECT}.py"
  output_path = local.lambda_zip_path
}

resource "aws_lambda_function" "test-lambda-with-terraform" {
  filename      = local.lambda_zip_path
  function_name = var.PROJECT
  role          = aws_iam_role.lambda_role_s3.arn
  handler       = "${var.PROJECT}.lambda_handler"

  source_code_hash = filebase64sha256(local.lambda_zip_path)
  runtime = "python3.8"

  tags = {
    Name = var.PROJECT
    Env = var.ENV
    Terraform = true
  }
}
