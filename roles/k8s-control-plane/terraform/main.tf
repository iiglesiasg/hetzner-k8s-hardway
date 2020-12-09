#resource "hcloud_load_balancer" "load-balancer" {
#  load_balancer_type = "lb11"
#  name               = "cka-lb"
#  location           = var.location # Region

#  depends_on = [data.hcloud_server_network.network]
#}
#resource "hcloud_certificate" "lb-cert" {
#  certificate = file("../../../pki/certs/kubernetes.pem")
#  name        = "kubernetes-cert"
#  private_key = file("../../../pki/certs/kubernetes-key.pem")
#}

resource "hcloud_load_balancer_service" "serv" {
  load_balancer_id = data.hcloud_load_balancer.lb.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
#  http {
#    certificates = [hcloud_certificate.lb-cert.id]
#  }
  health_check {
    interval = 15
    port     = 80
    protocol = "http"
    http {
      status_codes = [200]
      path         = "/healthz"
      tls          = false
      domain       = "kubernetes.default.svc.cluster.local"
    }
    timeout = 10
    retries = 3
  }
  depends_on = [data.hcloud_load_balancer.lb]
}

