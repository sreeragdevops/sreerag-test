output "vpc_id" {
value = aws_vpc.vpc.id
}

output "instance_id" {
    value = aws_instance.ec2.id
}