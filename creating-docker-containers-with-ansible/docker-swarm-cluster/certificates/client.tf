resource "tls_private_key" "client_key" {
  algorithm = "RSA"

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_cert_request" "client_csr" {
  key_algorithm   = "${tls_private_key.ca_key.algorithm}"
  private_key_pem = "${tls_private_key.client_key.private_key_pem}"

  subject {
    common_name = "client"
  }
}

resource "tls_locally_signed_cert" "client_cert" {
  ca_key_algorithm   = "${tls_private_key.ca_key.algorithm}"
  ca_cert_pem        = "${tls_self_signed_cert.ca_cert.cert_pem}"
  ca_private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  cert_request_pem   = "${tls_cert_request.client_csr.cert_request_pem }"

  allowed_uses          = ["client_auth"]
  validity_period_hours = 12
}

resource "null_resource" "generate_client_certs" {
  triggers = {
    ca_cert     = "${tls_self_signed_cert.ca_cert.cert_pem}"
    client_key  = "${tls_private_key.client_key.private_key_pem}"
    client_cert = "${tls_locally_signed_cert.client_cert.cert_pem}"
  }

  provisioner "local-exec" {
    command = <<EOF
mkdir -p ${path.module}/client
echo "${tls_self_signed_cert.ca_cert.cert_pem}"        > ${path.module}/client/ca.pem
echo "${tls_private_key.client_key.private_key_pem}"   > ${path.module}/client/key.pem
echo "${tls_locally_signed_cert.client_cert.cert_pem}" > ${path.module}/client/cert.pem
EOF
  }
}
