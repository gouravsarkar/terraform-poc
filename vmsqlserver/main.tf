provider "google" {
  version = "3.5.0"
  credentials = file("D:\\cloudguild23\\terraform-poc\\cred\\dps-parent-project-86cf6a6130b9.json")
  project = "dps-parent-project"
  region = "us-central1"
  zone = "us-central1-c"
}


resource "google_compute_network" "default" {
  name                    = "sql-server-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "sql-server-subnet"
  network       = google_compute_network.default.self_link
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_instance" "sql_server_vm" {
  name         = "sql-server-vm"
  machine_type = "n1-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "windows-server-2022-dc-core-v20220513"
    }
  }

  network_interface {
    network    = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.default.self_link
    access_config {}
  }

  metadata_startup_script = <<-SCRIPT
    # PS script to install SQL Server
    $ErrorActionPreference = "Stop"

    $sa_password = "welcome@1234"
    $sql_svc_account = "NT AUTHORITY\\SYSTEM"

    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile C:\\temp\\WSLUbuntu2004.appx

    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Add-WindowsCapability -Online -Name WSL

    Rename-Item C:\\temp\\WSLUbuntu2004.appx C:\\temp\\WSLUbuntu2004.zip
    Expand-Archive -Path C:\\temp\\WSLUbuntu2004.zip -DestinationPath C:\\temp\\wslubuntu2004
    Add-AppxPackage -Path C:\\temp\\wslubuntu2004\\appx\\Manifest.xml -Register -DisableDevelopmentMode

    wsl --set-default-version 2
    wsl --set-version Ubuntu-20.04 2

    Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2157202 -OutFile C:\\temp\\SQLServer2019.exe

    Start-Process -FilePath C:\\temp\\SQLServer2019.exe -ArgumentList "/q /ACTION=Install /FEATURES=SQL /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT=`"$sql_svc_account`" /SQLSYSADMINACCOUNTS=`"BUILTIN\\ADMINISTRATORS`" /AGTSVCACCOUNT=`"$sql_svc_account`" /SECURITYMODE=SQL /SAPWD=`"$sa_password`" /IACCEPTSQLSERVERLICENSETERMS" -Wait

    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    Restart-Computer -Force
  SCRIPT

  metadata = {
    "block-project-ssh-keys" = "true"
  }

#  service_account {
#    scopes = ["srvterraform@moonlit-text-385314.iam.gserviceaccount.com", "compute-ro", "storage-ro"]
#  }
}
