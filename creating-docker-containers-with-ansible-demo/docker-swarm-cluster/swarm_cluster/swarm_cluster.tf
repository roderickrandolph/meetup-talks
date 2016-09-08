resource "template_file" "swarm_node" {
  template = "${file("${path.module}/cloud-config.yml")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "swarm_cluster_lc" {
  name_prefix   = "swarm-cluster-lc-"
  image_id      = "${var.ami}"
  instance_type = "t2.nano"
  user_data     = "${template_file.swarm_node.rendered}"

  security_groups      = ["${compact(split(",", var.security_groups))}"]
  iam_instance_profile = "arn:aws:iam::154386456226:instance-profile/tripler_tracker_role"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "swarm_cluster_asg" {
  name             = "swarm-cluster-asg"
  max_size         = "${var.server_count}"
  min_size         = "${var.server_count}"
  desired_capacity = "${var.server_count}"
  force_delete     = true

  vpc_zone_identifier  = ["${compact(split(",", var.subnets))}"]
  launch_configuration = "${aws_launch_configuration.swarm_cluster_lc.name}"

  load_balancers = ["${compact(split(",", var.load_balancers))}"]

  tag {
    key                 = "Name"
    value               = "swarm-node"
    propagate_at_launch = true
  }
}
