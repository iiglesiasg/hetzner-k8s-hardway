#resource "hcloud_load_balancer" "load-balancer" {
#  load_balancer_type = "lb11"
#  name               = "cka-lb"
#  location           = var.location # Region

#  depends_on = [data.hcloud_server_network.network]
#}
resource "hcloud_certificate" "lb-cert" {
  certificate = file('../../../pki/certs/kubernetes.pem')
  name = "kubernetes-cert"
  private_key = file('../../../pki/certs/kubernetes-key.pem')
}

resource "hcloud_load_balancer_service" "serv" {
  load_balancer_id = data.hcloud_load_balancer.lb.id
  protocol         = "https"
  listen_port      = 6443
  destination_port = 80
  http {
    certificates = [hcloud_certificate.lb-cert.id]
  }
  health_check {
    interval = 15
    port = 80
    protocol = "https"
    http {
      status_codes = [200]
      path = "/healthz"
      tls = true
      domain = "kubernetes.default.svc.cluster.local"
    }
    timeout = 10
    retries = 3
  }
  depends_on       = [data.hcloud_load_balancer.lb, hcloud_certificate.lb-cert]
}

