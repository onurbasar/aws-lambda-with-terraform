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

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(local.lambda_zip_path)
  runtime = "python3.8"

  tags = {
    Name = var.PROJECT
    Env = var.ENV
    Terraform = true
  }
}