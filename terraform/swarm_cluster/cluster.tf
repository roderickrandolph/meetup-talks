resource "aws_launch_configuration" "swarm_cluster_lc" {
    name_prefix   = "swarm-cluster-lc-"
    image_id      = "ami-08111162" # Amazon Linux AMI (HVM / 64-bit)
    instance_type = "t2.nano"
    user_data     = "${var.user_data}"
    key_name      = "butterfinger"

    security_groups      = ["${compact(split(",", var.security_groups))}"]
    iam_instance_profile = "arn:aws:iam::154386456226:instance-profile/tripler_tracker_role"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "swarm_cluster_asg" {
    name             = "swarm-cluster-asg"
    max_size         = 5
    min_size         = 5
    desired_capacity = 5
    force_delete     = true

    vpc_zone_identifier  = ["${compact(split(",", var.subnets))}"]
    launch_configuration = "${aws_launch_configuration.swarm_cluster_lc.name}"

    load_balancers = ["${compact(split(",", var.load_balancers))}"]

    tag {
        key   = "Name"
        value = "swarm-node"
        
        propagate_at_launch = true
    }
}
