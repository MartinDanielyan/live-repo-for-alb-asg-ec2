
provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        # Replace this with your bucket name!
        bucket = "terraform-running-state-project1"
        key    = "stage/services/webserver-cluster/terraform.tfstate"
        region = "us-east-2"

        # Replace this with your DynamoDB table name!
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}

module "webserver_cluster" {
    source = "github.com/MartinDanielyan/modules.git//services/webserver-cluster?ref=v0.0.1"
    cluster_name = "webservers-stage"
    
    db_remote_state_bucket = "terraform-running-state-project1"
    db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

    instance_type = "t2.micro"
    min_size      = 2
    max_size      = 3
}

# resource "aws_security_group_rule" "allow_testing_inbound" {
#     type = "ingress"
#     security_group_id = module.webserver_cluster.alb_security_group_id

#     from_port = 12345
#     to_port   = 12345
#     protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
# }

resource "aws_security_group_rule" "allow_ssh_instance" {
    type = "ingress"
    security_group_id = module.webserver_cluster.instance_security_group_id

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
