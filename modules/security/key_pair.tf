resource "tls_private_key" "key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.name}_keypair"
  public_key = trimspace(tls_private_key.key.public_key_openssh)
}
