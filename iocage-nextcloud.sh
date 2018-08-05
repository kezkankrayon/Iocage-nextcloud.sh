#!/bin/bash

# Initialize defaults.
JAIL_NAME="nextcloud"
RELEASE="11.2-RELEASE"

#JAIL_IP=""
#DEFAULT_GW_IP=""
#INTERFACE=""
#VNET="off"
#POOL_PATH=""
#TIME_ZONE=""
#HOST_NAME=""
#DB_PATH=""
#FILES_PATH=""
#PORTS_PATH=""
#STANDALONE_CERT=0
#DNS_CERT=0
#TEST_CERT="--test"

cat <<__EOF__ >/tmp/pkg.json
{
	"pkgs":[
		"gettext-runtime",
		"nginx",
		"php72",
		"php72-bz2",
		"php72-ctype",
		"php72-curl",
		"php72-dom",
		"php72-exif",
		"php72-fileinfo",
		"php72-filter",
		"php72-gd",
		"php72-hash",
		"php72-iconv",
		"php72-json",
		"php72-ldap",
		"php72-mbstring",
		"php72-openssl",
		"php72-pcntl",
		"php72-pdo",
		"php72-pdo_pgsql",
		"php72-pecl-memcached",
		"php72-pecl-smbclient",
		"php72-pgsql",
		"php72-posix",
		"php72-session",
		"php72-simplexml",
		"php72-wddx",
		"php72-xml",
		"php72-xmlreader",
		"php72-xmlwriter",
		"php72-xsl",
		"php72-zip",
		"php72-zlib",
		"postgresql10-client",
		"postgresql10-server",
		"redis"
	]
}
__EOF__
 
iocage create --name "${JAIL_NAME}" -p /tmp/pkg.json -r "${RELEASE}" boot="on" vnet="on" bpf="yes" dhcp="on" host_hostname="${JAIL_NAME}"

# Remove tmp.
rm /tmp/pkg.json 

# mount configs.
iocage exec ${JAIL_NAME} mkdir -p /mnt/configs
iocage fstab -a ${JAIL_NAME} ${CONFIGS_PATH} /mnt/configs nullfs rw 0 0

# Mount 
iocage exec ${JAIL_NAME} mkdir -p /mnt/postgres
iocage fstab -a ${JAIL_NAME} ${DIR_DATASET} /mnt/postgres nullfs rw 0 0


iocage exec ${JAIL_NAME} /mnt/configs/setup.sh

# Set final interface configuration. 
#iocage set vnet=on "${JAIL_NAME}"
#iocage set dhcp=on "${JAIL_NAME}"
#iocage set bpf=yes "${JAIL_NAME}"