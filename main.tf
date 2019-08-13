data "template_cloudinit_config" "config" {
  base64_encode = true

  part {
    content = file("${path.module}/cloud-init.yml")

    # ######################################################
    # _________         _________ _______               _______  _______  _______    _
    # \__   __/|\     /|\__   __/(  ____ \    |\     /|(  ____ \(  ____ )(  ____ \  ( )
    #    ) (   | )   ( |   ) (   | (    \/    | )   ( || (    \/| (    )|| (    \/  | |
    #    | |   | (___) |   | |   | (_____     | (___) || (__    | (____)|| (__      | |
    #    | |   |  ___  |   | |   (_____  )    |  ___  ||  __)   |     __)|  __)     | |
    #    | |   | (   ) |   | |         ) |    | (   ) || (      | (\ (   | (        (_)
    #    | |   | )   ( |___) (___/\____) |    | )   ( || (____/\| ) \ \__| (____/\   _
    #    )_(   |/     \|\_______/\_______)    |/     \|(_______/|/   \__/(_______/  (_)

    # content_type = "text/cloud-config"
    # filename = "cloud-config.yml"

    content_type = "text/jinja2"
    filename = "jinja.yml"
  }
}






resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = var.key_name
  instance_type = "t3.nano"

  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  associate_public_ip_address = true

  user_data = data.template_cloudinit_config.config.rendered

  tags = {
    Name = "cloud-init-test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "this" {
  name_prefix = "cloud-init-test"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}