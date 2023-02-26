resource "google_compute_instance" "my-private-vm" {
  name         = "my-private-vm"
  machine_type = "e2-medium"
  zone         = "us-east4-c"

  depends_on = [
    google_container_cluster.my_cluster ,
    google_container_node_pool.node-pool
  ]
  

  metadata_startup_script = <<-EOF
                                    #
                                    sudo apt install -y apt-transport-https ca-certificates gnupg
                                    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
                                    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
                                    sudo apt-get update && sudo apt-get install -y google-cloud-cli
                                    sudo apt-get install kubectl -y
                                    sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y   
                                 EOF

  # Set Service Account with scopes 
  service_account {
    email = google_service_account.service-acc.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform" ]
  }

  # Add the boot disk
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }


  # Set the machine to be a private instance
  network_interface {
    network = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.my_ip.address
    }
  }
}

resource "google_compute_address" "my_ip" {
  name = "my-ip"
}