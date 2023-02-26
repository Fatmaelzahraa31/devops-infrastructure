resource "google_compute_subnetwork" "subnet" {
  name          = "subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc.id
  region        = "us-east4"
  # 
  
  secondary_ip_range {
     range_name = "cluster-range"
    ip_cidr_range = "10.0.2.0/24"
  }
  secondary_ip_range {
     range_name = "svc-range"
    ip_cidr_range = "10.0.3.0/24"
  }
}