output "public_ip" {
  value = aws_instance.this.public_ip
}

output "instance_id" {
  value = aws_instance.this.id
}

output "console_output_cmd" {
  value = "aws ec2 get-console-output --instance-id ${aws_instance.this.id} --output text"
}