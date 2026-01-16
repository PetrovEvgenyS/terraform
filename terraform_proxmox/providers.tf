provider "proxmox" {
  pm_api_url          = "https://10.100.10.241:8006/api2/json"
  pm_api_token_id     = "root@pam!terraform"
  pm_api_token_secret = "28fc6d3c-5773-4329-9b86-dd0fabf7d1f0"
  pm_tls_insecure     = true
}

