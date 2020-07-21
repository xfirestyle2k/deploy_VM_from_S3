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

data "vsphere_datacenter" "SDDC-Datacenter" {}
//data "vsphere_datastore" "WorkloadDatastore" {}

data "vsphere_resource_pool" "pool" {}

//data "vsphere_datastore" "WorkloadDatastore" {}

resource "vsphere_folder" "folder" {
  path          = "Druva-test-folder"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.SDDC-Datacenter.id
}
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

resource "vsphere_virtual_machine" "Druva_Proxy" {
  name                       = "DruvaProxy"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  //datastore_id               = "WorkloadDatastore"
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  datacenter_id              = data.vsphere_datacenter.SDDC-Datacenter.id
  ovf_deploy {
    // Url to remote ovf/ova file
    remote_ovf_url = "https://ts-ova-test.s3.eu-central-1.amazonaws.com/Druva_Phoenix_BackupProxy_standalone_4.8.15_96907.ova"
  }
}


// s3: ts-ova-test.s3.eu-central-1.amazonaws.com/Druva_Phoenix_BackupProxy_standalone_4.8.15_96907.ova
