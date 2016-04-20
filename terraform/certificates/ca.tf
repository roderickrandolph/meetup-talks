resource "tls_private_key" "ca_key" {
    algorithm = "RSA"

    lifecycle {
        create_before_destroy = true
    }
}

resource "tls_self_signed_cert" "ca_cert" {
    key_algorithm   = "${tls_private_key.ca_key.algorithm}"
    private_key_pem = "${tls_private_key.ca_key.private_key_pem}"

    is_ca_certificate     = true
    allowed_uses          = ["any_extended"]
    validity_period_hours = 12

    subject {
        common_name = "ca"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "null_resource" "generate_ca_certs" {
    triggers = {
        ca_key  = "${tls_private_key.ca_key.private_key_pem}"
        ca_cert = "${tls_self_signed_cert.ca_cert.cert_pem}"
    }

    provisioner "local-exec" {
        command = <<EOF
mkdir -p ${path.module}/ca
echo "${tls_private_key.ca_key.private_key_pem}" > ${path.module}/ca/key.pem
echo "${tls_self_signed_cert.ca_cert.cert_pem}"  > ${path.module}/ca/cert.pem
EOF
    }
}

output "ca_cert_pem" {
    value = "${base64encode(tls_self_signed_cert.ca_cert.cert_pem)}"
}
