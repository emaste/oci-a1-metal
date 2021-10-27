provider "oci" {}

resource "oci_core_instance" "leviathan" {
  agent_config {
    is_management_disabled = "true"
    is_monitoring_disabled = "true"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Oracle Autonomous Linux"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = "Ynwz:eu-amsterdam-1-AD-1"
  compartment_id      = "ocid1.tenancy.oc1..aaaaaaaaobmlhruktcqx2vi7r5mdu7eqkzucnjhziwfeb6s6thzgay4ujuhq"
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = "ocid1.subnet.oc1.eu-amsterdam-1.aaaaaaaa7lfgj4fcyfxlqc7cr4nhottzufvo5zzj2vc4syayk23i4rchenfq"
  }
  display_name = "leviathan"
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  metadata = {
    "ssh_authorized_keys" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ0cNlRkFRRleUZhFjIZYJ2p7h7wNWvODGBLEzfSfvr dch@skunkwerks.at 20201124"
  }
  shape = "BM.Standard.A1.160"
  source_details {
    source_type = "image"
    source_id = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaao4r5sq2jinn7chcuv3u3b4ch6jukooxxwxp45myrjhufnzxcakya"
  }
}

resource "oci_core_instance_console_connection" "leviathan_console" {
  instance_id = oci_core_instance.leviathan.id
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8OZGfPONqBUYPOVaxmthl6YEfUfUrTppvBLd1m0AotOXUfNIp43foqMwoQ6SJ1fSAsaqXjPydpV1djvxlgh55B8xZoPvT188EefbDYLSHl1FTH/uufiIkRReT5xx4kqg8zhrOR8+kk2ICtwIhZn4SHpJaImutzOfMexFj/H6BPBjiVsWcwj7rlDDEn9Bx1lJ30d/1B7Qlaw5bySTs973BxKAMeny1tOBFOwnOqo93WpZ1dt8GJB+zq763Q2jPqZv3yQUxxPFGUSTzvmrx/WMkaqKW7IKeXZV9oxc8UYCBzU2li+uPMJCbAUpXk50pxNa2Kb2bQBwgEF3LawmfXFkN oracle_rsa"
}


output "oid" {
  value = oci_core_instance.leviathan.id
}

output "ssh" {
  value = replace(oci_core_instance_console_connection.leviathan_console.connection_string, "ssh ", "/usr/bin/ssh ")
}

output "public_ip" {
  value = oci_core_instance.leviathan.public_ip
}

output "private_ip" {
  value = oci_core_instance.leviathan.private_ip
}

