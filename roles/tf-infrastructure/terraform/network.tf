resource "hcloud_network" "vpc" {
  name     = "my-net"
  ip_range = "10.0.0.0/19"
}
resource "hcloud_network_subnet" "nodes-subnet" {
  network_id   = hcloud_network.vpc.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}

resource "hcloud_server_network" "serv-network-m" {
  count      = 1
  network_id = hcloud_network.vpc.id
  server_id  = hcloud_server.nodes[count.index].id

  ip = "10.0.0.1${count.index}"

}

resource "hcloud_server_network" "serv-network-s" {
  count      = 1
  network_id = hcloud_network.vpc.id
  server_id  = hcloud_server.nodesw[count.index].id
  ip         = "10.0.0.2${count.index}"
}


resource "hcloud_load_balancer" "load-balancer" {
  load_balancer_type = "lb11"
  name               = "cka-lb"
  location           = var.location # Region

  depends_on = [hcloud_server_network.serv-network-m]
}

resource "hcloud_load_balancer_network" "lb-net" {
  load_balancer_id = hcloud_load_balancer.load-balancer.id
  network_id       = hcloud_network.vpc.id
  ip               = "10.0.0.2"
}

#resource "hcloud_load_balancer_service" "serv" {
#  load_balancer_id = hcloud_load_balancer.load-balancer.id
#  protocol         = "http"
#  listen_port      = 6443
#  depends_on       = [hcloud_server_network.serv-network-m]
#}

resource "hcloud_load_balancer_target" "lb-target" {
  count = 1

  load_balancer_id = hcloud_load_balancer.load-balancer.id
  type             = "server"
  server_id        = hcloud_server.nodes[count.index].id
  depends_on       = [hcloud_server_network.serv-network-m]
  use_private_ip   = true
}