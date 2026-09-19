#creating ec2 instance
resource "aws_instance" "example1" {
  instance_type = var.ec2_type
  ami = var.ec2_ami
  subnet_id = var.public_subnet_id
  availability_zone = var.availability_zone
  associate_public_ip_address = var.public_ip
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.key_name
  user_data = base64encode(templatefile("${path.root}/userdata.sh", {
  instance_name  = var.ec2_tags
  log_group_name = var.log_group_name
}))
  tags = {
    Name = var.ec2_tags
  }
}
resource "aws_instance" "example2" {
  instance_type = var.ec2_type
  ami = var.ec2_ami
  subnet_id = var.public_subnet_id
  availability_zone = var.availability_zone
  associate_public_ip_address = var.public_ip
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.key_name
  user_data = base64encode(templatefile("${path.root}/userdata.sh", {
    instance_name  = var.ec2_tags2
    log_group_name = var.log_group_name
  }))
  tags = {
    Name = var.ec2_tags2
  }
}