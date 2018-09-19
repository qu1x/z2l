#
# This file is the pfs recipe.
#

SUMMARY = "Persistent File System"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://pfs.sh file://Makefile"

S = "${WORKDIR}"

do_install() {
	install -d ${D}/etc/init.d ${D}/etc/rcS.d
	install -m 0755 ${S}/pfs.sh ${D}/etc/init.d
	ln -s ../init.d/pfs.sh ${D}/etc/rcS.d/S70pfs.sh
}

FILES_${PN} = "/etc/init.d/pfs.sh /etc/rcS.d/S70pfs.sh"
