
# Create a new server running fedora
resource "hcloud_server" "nodes" {
  count = 1
  name  = "master${count.index}"

  image       = "fedora-32"
  server_type = "cx11"
  location    = var.location # Region
#  ssh_keys    = [data.hcloud_ssh_key.default.id]
  ssh_keys    = ["ningu@Master", "ningunpenk@hotmail.com"] #[hcloud_ssh_key.default.id]
  user_data   = file("./cloud_config/cloud_init_main.yaml")
}

resource "hcloud_server" "nodesw" {
  count       = 1
  name        = "worker${count.index}"
  location    = var.location # Region
  image       = "fedora-32"
  server_type = "cx11"
  ssh_keys    = ["ningu@Master", "ningunpenk@hotmail.com"] #[hcloud_ssh_key.default.id]
  user_data   = file("./cloud_config/cloud_init_worker.yaml")
}