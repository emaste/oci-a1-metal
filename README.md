# OCI A1 Metal

This repo contains scripts and terraform configs to create and deploy
FreeBSD 14.x arm64 images in OCI (Oracle Cloud Infrastructure) that
utilise Ampere's Altra processors, either as KVM-backed virtual
machines, known as `A1.Flex` in OCI parlance), or as native bare metal
servers, known as `A1.BM` instances.

## Pre-requisites

- an OCI account
- raised Service Limits that enable booting 160 cores (for Bare Metal only)
- an existing FreeBSD arm64 system to build FreeBSD source and prepare image
- patience

OCI's terraform module requires the following info:

- RSA ssh keypair for creating the serial-over-ssh console
- availability domain
- compartment id
- subnet id
- source id of your image

## terraform provisioning

```
$ sudo pkg install -r FreeBSD sysutils/terraform
$ cd ./terraform
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/oci...
- Installing hashicorp/oci v4.49.0...
- Installed hashicorp/oci v4.49.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

The `apply` phase typically takes 2-3 minutes to prepare storage and
wait for the server to initialise, boot and connect the remote console.

### terraform apply

```
$ env OCI_GO_SDK_DEBUG=v terraform apply -auto-approve

Terraform used the selected providers to generate the following
execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # oci_core_instance.leviathan will be created
  + resource "oci_core_instance" "leviathan" {
      + availability_domain                 = "Ynwz:eu-amsterdam-1-AD-1"
      + boot_volume_id                      = (known after apply)
      + capacity_reservation_id             = (known after apply)
      + compartment_id                      = "ocid1.tenancy.oc1...."
      + dedicated_vm_host_id                = (known after apply)
      + defined_tags                        = (known after apply)
      + display_name                        = "leviathan"
      + fault_domain                        = (known after apply)
      + freeform_tags                       = (known after apply)
      + hostname_label                      = (known after apply)
      + id                                  = (known after apply)
      + image                               = (known after apply)
      + ipxe_script                         = (known after apply)
      + is_pv_encryption_in_transit_enabled = (known after apply)
      + launch_mode                         = (known after apply)
      + metadata                            = {
          + "ssh_authorized_keys" = "ssh-ed25519 AAAAC..."
        }
      + private_ip                          = (known after apply)
      + public_ip                           = (known after apply)
      + region                              = (known after apply)
      + shape                               = "BM.Standard.A1.160"
      + state                               = (known after apply)
      + subnet_id                           = (known after apply)
      + system_tags                         = (known after apply)
      + time_created                        = (known after apply)
      + time_maintenance_reboot_due         = (known after apply)

      + agent_config {
          + are_all_plugins_disabled = (known after apply)
          + is_management_disabled   = true
          + is_monitoring_disabled   = true

          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "Vulnerability Scanning"
            }
          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "Oracle Autonomous Linux"
            }
          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "OS Management Service Agent"
            }
          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "Compute Instance Run Command"
            }
          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "Compute Instance Monitoring"
            }
          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "Block Volume Management"
            }
          + plugins_config {
              + desired_state = "DISABLED"
              + name          = "Bastion"
            }
        }

      + availability_config {
          + is_live_migration_preferred = (known after apply)
          + recovery_action             = "RESTORE_INSTANCE"
        }

      + create_vnic_details {
          + assign_private_dns_record = true
          + assign_public_ip          = "true"
          + defined_tags              = (known after apply)
          + display_name              = (known after apply)
          + freeform_tags             = (known after apply)
          + hostname_label            = (known after apply)
          + private_ip                = (known after apply)
          + skip_source_dest_check    = (known after apply)
          + subnet_id                 = "ocid1.subnet.oc1.eu-amsterdam-1..."
          + vlan_id                   = (known after apply)
        }

      + instance_options {
          + are_legacy_imds_endpoints_disabled = false
        }

      + launch_options {
          + boot_volume_type                    = (known after apply)
          + firmware                            = (known after apply)
          + is_consistent_volume_naming_enabled = (known after apply)
          + is_pv_encryption_in_transit_enabled = (known after apply)
          + network_type                        = (known after apply)
          + remote_data_volume_type             = (known after apply)
        }

      + platform_config {
          + is_measured_boot_enabled           = (known after apply)
          + is_secure_boot_enabled             = (known after apply)
          + is_trusted_platform_module_enabled = (known after apply)
          + numa_nodes_per_socket              = (known after apply)
          + type                               = (known after apply)
        }

      + preemptible_instance_config {
          + preemption_action {
              + preserve_boot_volume = (known after apply)
              + type                 = (known after apply)
            }
        }

      + shape_config {
          + baseline_ocpu_utilization     = (known after apply)
          + gpu_description               = (known after apply)
          + gpus                          = (known after apply)
          + local_disk_description        = (known after apply)
          + local_disks                   = (known after apply)
          + local_disks_total_size_in_gbs = (known after apply)
          + max_vnic_attachments          = (known after apply)
          + memory_in_gbs                 = (known after apply)
          + networking_bandwidth_in_gbps  = (known after apply)
          + ocpus                         = (known after apply)
          + processor_description         = (known after apply)
        }

      + source_details {
          + boot_volume_size_in_gbs = (known after apply)
          + kms_key_id              = (known after apply)
          + source_id               = "ocid1.image.oc1.eu-amsterdam-1..."
          + source_type             = "image"
        }
    }

  # oci_core_instance_console_connection.leviathan_console will be created
  + resource "oci_core_instance_console_connection" "leviathan_console" {
      + compartment_id               = (known after apply)
      + connection_string            = (known after apply)
      + defined_tags                 = (known after apply)
      + fingerprint                  = (known after apply)
      + freeform_tags                = (known after apply)
      + id                           = (known after apply)
      + instance_id                  = (known after apply)
      + public_key                   = "ssh-rsa AAAAB3N..."
      + service_host_key_fingerprint = (known after apply)
      + state                        = (known after apply)
      + vnc_connection_string        = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + oid        = (known after apply)
  + private_ip = (known after apply)
  + public_ip  = (known after apply)
  + ssh        = (known after apply)
oci_core_instance.leviathan: Creating...
oci_core_instance.leviathan: Still creating... [10s elapsed]
oci_core_instance.leviathan: Still creating... [20s elapsed]
oci_core_instance.leviathan: Still creating... [30s elapsed]
oci_core_instance.leviathan: Still creating... [40s elapsed]
oci_core_instance.leviathan: Still creating... [50s elapsed]
oci_core_instance.leviathan: Still creating... [1m0s elapsed]
oci_core_instance.leviathan: Still creating... [1m10s elapsed]
oci_core_instance.leviathan: Still creating... [1m20s elapsed]
oci_core_instance.leviathan: Still creating... [1m30s elapsed]
oci_core_instance.leviathan: Still creating... [1m40s elapsed]
oci_core_instance.leviathan: Still creating... [1m50s elapsed]
oci_core_instance.leviathan: Still creating... [2m0s elapsed]
oci_core_instance.leviathan: Still creating... [2m10s elapsed]
oci_core_instance.leviathan: Still creating... [2m20s elapsed]
oci_core_instance.leviathan: Still creating... [2m30s elapsed]
oci_core_instance.leviathan: Still creating... [2m40s elapsed]
oci_core_instance.leviathan: Still creating... [2m50s elapsed]
oci_core_instance.leviathan: Still creating... [3m0s elapsed]
oci_core_instance.leviathan: Creation complete after 3m1s [id=ocid1.instance.oc1...]
oci_core_instance_console_connection.leviathan_console: Creating...
oci_core_instance_console_connection.leviathan_console: Still creating... [10s elapsed]
oci_core_instance_console_connection.leviathan_console: Still creating... [20s elapsed]
oci_core_instance_console_connection.leviathan_console: Still creating... [30s elapsed]
oci_core_instance_console_connection.leviathan_console: Creation complete after 35s [id=ocid1.instanceconsoleconnection...]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

oid = "ocid1.instance.oc1.eu-amsterdam-1..."
private_ip = "10.0.0.246"
public_ip = "158.101.216.114"
ssh = "/usr/bin/ssh -o ProxyCommand='/usr/bin/ssh -W %h:%p -p 443 ocid1..."
```

Using the information above, we can now connect to the instance over
serial console over ssh, and switch from the memory-backed boot
filesystem, to the main iSCSI volume.

### serial console and networking

Once the serial console has connected, press `enter`, and bring up the
network:

```
Serial console started.  To stop, type ESC (

Cannot read termcap database;
using dumb terminal settings.

# mount -u -o rw /
# ifconfig mce0 inet 10.0.0.246/24 add up mtu 9000

mce0: link state changed to UP
mce0: 2 link states coalesced
mce0: link state changed to UP

# route add default 10.0.0.1
add net default: gateway 10.0.0.1

# ping 169.254.0.2
PING 169.254.0.2 (169.254.0.2): 56 data bytes
64 bytes from 169.254.0.2: icmp_seq=0 ttl=64 time=0.385 ms
64 bytes from 169.254.0.2: icmp_seq=1 ttl=64 time=0.105 ms
64 bytes from 169.254.0.2: icmp_seq=2 ttl=64 time=0.155 ms
64 bytes from 169.254.0.2: icmp_seq=3 ttl=64 time=0.114 ms
^C
--- 169.254.0.2 ping statistics ---
4 packets transmitted, 4 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.105/0.190/0.385/0.114 ms
```

### start iscsi and re-root the kernel

During this process, we see two warnings.

The first is that the OCI iscsi target (server) returns a non-compliant
SCSI response, which FreeBSD will ignore.

The second, is that invalid GPT header, from FreeBSD itself. This is
because the image we use to boot from is actually about 400MiB, and it
is installed to the boot volume for this instance, which is ~ 47GiB
total.

```
# iscsid -l 1 &
# iscsictl -A -p 169.254.0.2 -t iqn.2015-02.oracle.boot:uefi

WARNING: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): ExpDataSN mismatch in SCSI Response (0 vs 1)

da0 at iscsi1 bus 0 scbus0 target 0 lun 1
da0: <ORACLE BlockVolume 1.0> Fixed Direct Access SPC-4 SCSI device
da0: 150.000MB/s transfers
da0: Command Queueing enabled
da0: 47694MB (97677312 512 byte sectors)
(da0:iscsi1:0:0:1): READ(6)/WRITE(6) not supported, increasing minimum_cmd_size to 10.
GEOM: da0: the secondary GPT header is not in the last LBA.

# gpart show
=>     40  2097072  da0  GPT  (47G) [CORRUPT]
       40  2097072    1  efi  (1.0G)

# iscsictl -Lv
Session ID:               1
Initiator name:           iqn.1994-09.org.freebsd:
Initiator portal:
Initiator alias:
Target name:              iqn.2015-02.oracle.boot:uefi
Target portal:            169.254.0.2
Target alias:
User:
Secret:
Mutual user:
Mutual secret:
Session type:             Normal
Enable:                   Yes
Session state:            Connected
Failure reason:
Header digest:            None
Data digest:              None
MaxRecvDataSegmentLength: 262144
MaxSendDataSegmentLength: 8192
MaxBurstLen:              262144
FirstBurstLen:            65536
ImmediateData:            Yes
iSER (RDMA):              No
Offload driver:           None
Device nodes:             da0
```

Inform the kernel where to find itself on the iSCSI volume, and then
reboot:

```
# kenv vfs.root.mountfrom=zfs:zroot/ROOT/default
vfs.root.mountfrom="zfs:zroot/ROOT/default"
# reboot -r

Trying to mount root from zfs:zroot/ROOT/default []...
witness_lock_list_get: witness exhausted
witness_lock_list_get: witness exhausted
(da0:iscsi1:0:0:1): SYNCHRONIZE CACHE(10). CDB: 35 00 00 00 00 00 00 00 00 00
(da0:iscsi1:0:0:1): CAM status: SCSI Status Error
(da0:iscsi1:0:0:1): SCSI status: Check Condition
(da0:iscsi1:0:0:1): SCSI sense: ILLEGAL REQUEST asc:20,0 (Invalid command operation code)
(da0:iscsi1:0:0:1): Error 22, Unretryable error
No suitable dump device was found.
Setting hostuuid: 44f7919a-3248-11ec-a483-97b3066001b4.
Setting hostid: 0xb733c022.
no pools available to import
Starting file system checks:
/dev/gpt/efiboot0: 765 files, 845 MiB free (54063 clusters)
FIXED
/dev/gpt/efiboot0: MARKING FILE SYSTEM CLEAN
Mounting local filesystems:.
Loading kernel modules:
ELF ldconfig path: /lib /usr/lib /usr/lib/compat /usr/local/lib /usr/local/lib/compat/pkg /usr/local/lib/compat/pkg /usr/local/lib/perl5/5.32/mach/CORE
Setting hostname: leviathan.skunkwerks.at.
Setting up harvesting: [UMA],[FS_ATIME],SWI,INTERRUPT,NET_NG,[NET_ETHER],NET_TUN,MOUSE,KEYBOARD,ATTACH,CACHED
Feeding entropy: iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 12288 -> 8192
iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 12288 -> 8192
iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 16384 -> 8192
iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 12288 -> 8192
iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 16384 -> 8192
iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 36864 -> 8192
iscsi_action_scsiio: 169.254.0.2 (iqn.2015-02.oracle.boot:uefi): len 16384 -> 8192

Starting Network: lo0 mce0 mce1.
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> metric 0 mtu 16384
	options=680003<RXCSUM,TXCSUM,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6>
	inet6 ::1 prefixlen 128
	inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1
	inet 127.0.0.1 netmask 0xff000000
	groups: lo
	nd6 options=21<PERFORMNUD,AUTO_LINKLOCAL>
mce0: flags=8863<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 9000
	options=7eed07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWFILTER,VLAN_HWTSO,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6,HWRXTSTMP,NOMAP,TXTLS4,TXTLS6,VXLAN_HWCSUM,VXLAN_HWTSO>
	ether b8:ce:f6:57:d4:a4
	inet 10.0.0.246 netmask 0xffffff00 broadcast 10.0.0.255
	media: Ethernet 50GBase-CR2 <full-duplex,rxpause,txpause>
	status: active
	nd6 options=29<PERFORMNUD,IFDISABLED,AUTO_LINKLOCAL>
mce1: flags=8822<BROADCAST,SIMPLEX,MULTICAST> metric 0 mtu 1500
	options=7eed07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWFILTER,VLAN_HWTSO,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6,HWRXTSTMP,NOMAP,TXTLS4,TXTLS6,VXLAN_HWCSUM,VXLAN_HWTSO>
	ether b8:ce:f6:57:d4:a5
	media: Ethernet autoselect <full-duplex,rxpause,txpause>
	status: no carrier (No issue was observed)
	nd6 options=29<PERFORMNUD,IFDISABLED,AUTO_LINKLOCAL>
Starting devd.
Starting Network: mce1.
mce1: flags=8822<BROADCAST,SIMPLEX,MULTICAST> metric 0 mtu 1500
	options=7eed07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWFILTER,VLAN_HWTSO,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6,HWRXTSTMP,NOMAP,TXTLS4,TXTLS6,VXLAN_HWCSUM,VXLAN_HWTSO>
	ether b8:ce:f6:57:d4:a5
	media: Ethernet autoselect <full-duplex,rxpause,txpause>
	status: no carrier (No issue was observed)
	nd6 options=29<PERFORMNUD,IFDISABLED,AUTO_LINKLOCAL>
add host 127.0.0.1: gateway lo0 fib 0: route already in table
add net 169.254.0.0: gateway 10.0.0.1 fib 0: route already in table
add net default: gateway 10.0.0.1 fib 0: route already in table
add host ::1: gateway lo0 fib 0: route already in table
add net fe80::: gateway ::1
add net ff02::: gateway ::1
add net ::ffff:0.0.0.0: gateway ::1
add net ::0.0.0.0: gateway ::1
Starting iscsid.
Starting iscsictl.
Recovering vi editor sessions:.
Creating and/or trimming log files.
Updating /var/run/os-release done.
Updating motd:.
Clearing /tmp.
Starting syslogd.
Setting date via ntp.
22 Oct 09:45:24 ntpdate[38494]: step time server 72.87.88.203 offset -3.834127 sec
Mounting late filesystems:.
Security policy loaded: MAC/ntpd (mac_ntpd)
Starting cron.
Performing sanity check on sshd configuration.
Starting sshd.
Configuring vt: blanktime.
Starting background file system checks in 60 seconds.

Fri Oct 22 09:45:24 UTC
FreeBSD/arm64 (leviathan) (ttyu0)

login:
```

At this point, you should have remote ssh access.

Remember to shutdown and de-provision the instance, it has a significant
per-hour cost to run.

### importing a zroot via netcat

```
# zpool create \
   -o failmode=continue \
   -O atime=off \
   -O compression=zstd-9 \
    -O checksum=skein \
   -R /mnt \
zroot /dev/gpt/zfs0
# nc -Nvl 1234 | zfs recv -Fuvs zroot
Connection from a01.subnet06131640.vcn06131640.oraclevcn.com 5390 received!
receiving full stream of zroot@migrate into zroot@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/var@migrate into zroot/var@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/var/cache@migrate into zroot/var/cache@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/var/cache/ccache@migrate into zroot/var/cache/ccache@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/var/cache/pkg@migrate into zroot/var/cache/pkg@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/var/cache/distfiles@migrate into zroot/var/cache/distfiles@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/var/log@migrate into zroot/var/log@migrate
received 62.7K stream in 1 seconds (62.7K/sec)
receiving full stream of zroot/var/tmp@migrate into zroot/var/tmp@migrate
received 843M stream in 20 seconds (42.1M/sec)
receiving full stream of zroot/var/mail@migrate into zroot/var/mail@migrate
received 46.3K stream in 1 seconds (46.3K/sec)
receiving full stream of zroot/var/audit@migrate into zroot/var/audit@migrate
received 46.4K stream in 1 seconds (46.4K/sec)
receiving full stream of zroot/var/crash@migrate into zroot/var/crash@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/ROOT@migrate into zroot/ROOT@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/ROOT/default@migrate into zroot/ROOT/default@migrate
received 2.55G stream in 59 seconds (44.3M/sec)
receiving full stream of zroot/usr@migrate into zroot/usr@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/usr/ports@migrate into zroot/usr/ports@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/usr/home@migrate into zroot/usr/home@migrate
received 64.9K stream in 1 seconds (64.9K/sec)
receiving full stream of zroot/usr/obj@migrate into zroot/usr/obj@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
receiving full stream of zroot/usr/src@migrate into zroot/usr/src@migrate
received 44.1K stream in 1 seconds (44.1K/sec)
# zfs list
NAME                        USED  AVAIL     REFER  MOUNTPOINT
zroot                      3.43G  40.7G       96K  none
zroot/ROOT                 2.61G  40.7G       96K  none
zroot/ROOT/default         2.61G  40.7G     2.61G  /mnt
zroot/usr                   536K  40.7G       96K  /mnt/usr
zroot/usr/home              152K  40.7G      152K  /mnt/usr/home
zroot/usr/obj                96K  40.7G       96K  /mnt/usr/obj
zroot/usr/ports              96K  40.7G       96K  /mnt/usr/ports
zroot/usr/src                96K  40.7G       96K  /mnt/usr/src
zroot/var                   841M  40.7G       96K  /mnt/var
zroot/var/audit              96K  40.7G       96K  /mnt/var/audit
zroot/var/cache             384K  40.7G       96K  /mnt/var/cache
zroot/var/cache/ccache       96K  40.7G       96K  /mnt/var/cache/ccache
zroot/var/cache/distfiles    96K  40.7G       96K  /mnt/var/cache/distfiles
zroot/var/cache/pkg          96K  40.7G       96K  /mnt/var/cache/pkg
zroot/var/crash              96K  40.7G       96K  /mnt/var/crash
zroot/var/log               112K  40.7G      112K  /mnt/var/log
zroot/var/mail              104K  40.7G      104K  /mnt/var/mail
zroot/var/tmp               840M  40.7G      840M  /mnt/var/tmp
# zpool set bootfs=zroot/ROOT/default zroot
# kenv vfs.root.mountfrom=zfs:zroot/ROOT/default
vfs.root.mountfrom="zfs:zroot/ROOT/default"
# reboot -r
```

