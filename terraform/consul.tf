provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "${var.pub_key}"
}

data "aws_ami" "consul" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "packer-consul*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "self"
  ]
}

resource "aws_instance" "consul-server" {
  ami = "${data.aws_ami.consul.id}"
  instance_type = "t2.nano"
  iam_instance_profile = "${aws_iam_instance_profile.consul-join.name}"
  count = 3
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
  ]
  tags {
    Name = "consul-server"
    consul = "server"
  }
}

# Create the policy
data "aws_iam_policy_document" "consul-join-policy" {
  statement {
    sid = 1

    actions = [
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "consul-join" {
  name = "${var.namespace}-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy = "${data.aws_iam_policy_document.consul-join-policy.json}"
}

# Create an IAM role for the auto-join
# Create the policy
data "aws_iam_policy_document" "consul-join-role" {
  statement {
    sid = 1

    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consul-join" {
  name = "${var.namespace}-consul-join"
  assume_role_policy = "${data.aws_iam_policy_document.consul-join-role.json}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name = "${var.namespace}-consul-join"
  roles = [
    "${aws_iam_role.consul-join.name}"]
  policy_arn = "${aws_iam_policy.consul-join.arn}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name = "${var.namespace}-consul-join"
  role = "${aws_iam_role.consul-join.name}"
}

output "ip" {
  value = "${join(",", aws_instance.consul-server.*.public_ip)}"
}