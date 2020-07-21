/*provider "aws" {
region = "eu-central-1"
skip_credentials_validation = false
}*/

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

//get data from vCenter
data "vsphere_datacenter" "dc" {
  name = "SDDC-Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "WorkloadDatastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Cluster-1/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = "10.2.32.4"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "sddc-cgw-network-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

//Test if the connect to cCenter working:
resource "vsphere_folder" "folder" {
  path          = "Druva-test-folder"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

//deploying VM:

resource "vsphere_virtual_machine" "DruvaProxy_ova" {
  name                       = "DruvaProxy"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  host_system_id             = data.vsphere_host.host.id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  datacenter_id              = data.vsphere_datacenter.dc.id
  ovf_deploy {
    // Url to remote ovf/ova file
    remote_ovf_url = "https://ts-ova-test.s3.eu-central-1.amazonaws.com/Druva_Phoenix_BackupProxy_standalone_4.8.15_96907.ova"
  }
    vapp {
    properties = {

//properties missing


    }
  }
}

// s3: ts-ova-test.s3.eu-central-1.amazonaws.com/Druva_Phoenix_BackupProxy_standalone_4.8.15_96907.ova
/*
data "aws_s3_bucket_object" "ova" {
  bucket = "ts-ova-test.s3.eu-central-1.amazonaws.com"
  key    = "Druva_Phoenix_BackupProxy_standalone_4.8.15_96907.ova"
}

resource "vsphere_file" "Druva_ova" {
  datacenter       = "SDDC-Datacenter"
  datastore        = "WorkloadDatastore"
  source_file      = "s3::https://ts-ova-test.s3.eu-central-1.amazonaws.com/Druva_Phoenix_BackupProxy_standalone_4.8.15_96907.ova"
  destination_file = "/Druva_temp/BackupProxy.ova"
}

resource "vsphere_virtual_machine" "Druva_Proxy" {
  folder = "Druva-test-folder"

}
*/
