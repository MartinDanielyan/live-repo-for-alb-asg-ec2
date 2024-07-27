
provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        # Replace this with your bucket name!
        bucket = "terraform-running-state-project1"
        key    = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-2"

        # Replace this with your DynamoDB table name!
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}

resource "aws_db_instance" "project1" {
    identifier_prefix = "terraform-running-project1"
    allocated_storage    = 10
    db_name              = "mydb"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true

    # How should we set the username and password?
    username             = "foo"
    password             = "foobarbaz"
    #username             = "var.db_username"
    #password             = "var.db_password"
}