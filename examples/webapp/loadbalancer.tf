
# Load balancing
resource "aws_elb" "www" {
  name = "tf-demo-elb"
  # The same availability zone as our instance
  availability_zones = ["${element(aws_instance.www.*.availability_zone, count.index)}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances = ["${aws_instance.www.*.id}"]
}

resource "aws_route53_record" "tf-demo-lb-record" {
  name = "${concat("www",".", aws_route53_zone.primary.name)}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  type = "CNAME"
  records = [ "${aws_elb.www.dns_name}" ]
  ttl = "1"
}
