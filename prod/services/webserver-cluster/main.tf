
provider "aws" {
    region = "us-east-2"
}

module "webserver_cluster" {
    source = "github.com/MartinDanielyan/modules//services/webserver-cluster?ref=v0.0.1"
    cluster_name = "webservers-prod"

    db_remote_state_bucket = "terraform-running-state-project1"
    db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

    instance_type = "t3.micro"
    min_size      = 2
    max_size      = 4
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}
