FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SYSTEMD_PACKAGES:append:beaglebone-custom = " ${PN}"
SYSTEMD_SERVICE:${PN}:append:beaglebone-custom = " systemd-resolved.service"

SRC_URI:append:beaglebone-custom = " file://resolved-bbb-server.conf"

do_install:append:beaglebone-custom() {
    install -D -m 0644 ${WORKDIR}/resolved-bbb-server.conf \
        ${D}${sysconfdir}/systemd/resolved.conf.d/10-bbb-server.conf
}
