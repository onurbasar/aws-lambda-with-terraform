# aws-lambda-with-terraform
Create and list S3 buckets with AWS Lambda created from Terraform

## Requirements
- AWS Account : To create and use AWS services, you need to create an AWS account. If you don't have a one, you can start with [free tier](https://aws.amazon.com/free/?trk=ps_a134p000003yLUxAAM&trkCampaign=acq_paid_search_brand&sc_channel=PS&sc_campaign=acquisition_TR&sc_publisher=Google&sc_category=Core&sc_country=TR&sc_geo=EMEA&sc_outcome=acq&sc_detail=aws%20free%20tier&sc_content=Account_e&sc_segment=444593201013&sc_medium=ACQ-P|PS-GO|Brand|Desktop|SU|AWS|Core|TR|EN|Text&s_kwcid=AL!4422!3!444593201013!e!!g!!aws%20free%20tier&ef_id=CjwKCAiA6Y2QBhAtEiwAGHybPYSOT3kQVI41nmHzbyFVm1idt1Sjxa7UhajbSQ9HqkHcgQ08EBvl8RoCuIEQAvD_BwE:G:s&s_kwcid=AL!4422!3!444593201013!e!!g!!aws%20free%20tier&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all). For this project, services are in the scope of free tier, i.e you will not charge for creating Lambda function or creating S3 Bucket. Check out here if you want to know more about [free tier limits](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all).
- AWS CLI : The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With terminal commands, you can manage your AWS services. To install aws-cli, see [installing or updating the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). 
- AWS Credentials : In order to manage your services from command line tools, you need an **aws_access_key_id** and **an aws_secret_access_key**. Creating a new user for IaC purposes is recommended. For this, you can create a new user with **IAM**. For this;
  1. Go to IAM
  2. Under Users click 'Add User'
  3. Give a. username (like terraform_user)
  4. For credential type select 'Access key - Programmatic access' and click next
  5. Click 'Create Group', specify a group name and select 'AdministratorAccess' policy. 
  6. Click Review and create user. This user has a programmatic access and admin permissions.
  
  After you create the user, go to Users and select the user you have created. Go to 'Security Credentials' and click 'Create access key'. This will give an    access   key id and a secret access key. Save and dont share these credentials. You can not see access key again after you close this window. 
  
  Once you have your credentials, open terminal and type:
  ```
  aws credentials
  ```
  Paste yur access key id, secret access key id. You can select a default region either.
- Terraform : For this project, you need to have Hashicorp Terraform, see [Download Terraform](https://www.terraform.io/downloads).On Mac, you can download with:
  ```
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  ```
## Project
- After you deploy this project, a Lambda function and an IAM role will be created in eu-west-1 region. You can change AWS_REGION variable under **variables.tf** file. Under **provider.tf** file, you can see the AWS as provider. 
- In **iam.tf**, 'lambda_role_s3' and 'lambda_policy' for Lambda function will be created. This is like creating a user and attach a policy with management console. lambda_role_s3 has full access for S3 and CloudWatch. You may wanna change this permissions under Statement for security purposes. You can check out [this site](https://awspolicygen.s3.amazonaws.com/policygen.html) to create AWS policies. 
- **lambda.tf** file will create firstly a zip for .py file. Then it will create a Lambda function. Lambda function will have:
  - IAM role which is created from **iam.tf**
  - Project name which is defined in **variables.tf**
  - Script zip which is created **lambda.tf**
  - Runtime of Python 3.8
- After you set up credentials, go to terminal and start terraform with:
  ```
  terraform init
  ```
  This will install hashicorp/aws v3.74.1 and create a file called .terraform. You need to have ''Terraform has been successfully initialized!'' message.
  Before deployment, you can view the services which will be created with:
  ```
  terraform plan
  ```
  If everyting seems OK, start deployment. This will take apprx. 20 seconds.
  ```
  terraform apply
  ```
  Check the Lambda function from AWS management console. 
## Test

- If your deployment is successfuli you can test the lambda function with Lambda Test event. In the python file, if **key1 is 0**, then S3 buckets will be listed. There is no need for key2 and key3 to list S3 Buckets.
- **If key1 is 1**, a new bucket will be created. Key2 (bucket name) is mandatory, you need to give a global unique value for key2. Key3 is the region for bucket. If you don't give any region, bucket will be create in default region (us-east-1).
