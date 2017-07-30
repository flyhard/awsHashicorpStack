resource "aws_security_group" "ssh" {
  egress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    self = true
  }
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    self = true
  }
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}