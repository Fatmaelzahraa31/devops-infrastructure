resource "google_container_cluster" "my_cluster" {
  name               = "my-cluster"
  network            = google_compute_network.vpc.id
  subnetwork         = google_compute_subnetwork.subnet.id
  location           = "us-east4-c"
  remove_default_node_pool = true
  initial_node_count = 1

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.0.1.0/24"
      display_name = "cidr-range"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "fatma120d.svc.id.goog"
  }

  ip_allocation_policy { 
    cluster_secondary_range_name = "cluster-range"
     services_secondary_range_name = "svc-range"
  }

  # Set the cluster to private
  private_cluster_config {
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    enable_private_nodes    = true
  }

  node_config {
    service_account = google_service_account.service-acc.email
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]  
  }
}