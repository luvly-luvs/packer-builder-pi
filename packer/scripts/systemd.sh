#!/usr/bin/env sh
configure_network() {
	tee /etc/systemd/network/"$1".network <<EOF
[Match]
Name=$1

[Network]
DHCP=yes
MulticastDNS=yes
LLMNR=no
EOF
}

configure_network wlan0
configure_network eth0

tee /etc/systemd/resolved.conf <<-EOF
	[Resolve]
	DNS=8.8.8.8 8.8.4.4
	FallbackDNS=1.1.1.1
	DNSSEC=allow-downgrade
	DNSOverTLS=opportunistic
	MulticastDNS=yes
	LLMNR=no
EOF

tee /etc/apt/sources.list.d/backports.list <<-EOF
	deb http://deb.debian.org/debian bullseye-backports main
EOF

apt-get update
apt-get install -y systemd/bullseye-backports systemd-timesyncd/bullseye-backports
apt-get autoremove -y
