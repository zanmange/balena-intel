DEPENDS_append_class-target = " grub-conf"
RDEPENDS_${PN}_class-target_remove = "grub-common"

GRUB_BUILDIN += " gcry_sha256 gcry_rsa"

do_mkimage() {
	cd ${B}

	# Set up GPG
	export GNUPGHOME="${B}/gpghome"
	rm -rf "${GNUPGHOME}"
	mkdir -p "${GNUPGHOME}"
	chmod 0700 "${GNUPGHOME}"

	# Generate a new key pair for this build
	echo "%no-protection" > gpg.conf
	echo "Key-Type: RSA" >> gpg.conf
	echo "Key-Length: 4096" >> gpg.conf
	echo "Name-Real: Balena GRUB" >> gpg.conf
	echo "Name-Comment: GPG key used to sign Balena GRUB" >> gpg.conf
	echo "Name-Email: hello@balena.io" >> gpg.conf
	echo "Expire-Date: 0" >> gpg.conf

	gpg --batch --gen-key gpg.conf

	gpg --export > grubgpg.pub
	# Search for the grub.cfg on the local boot media by using the
	# built in cfg file provided via this recipe
	grub-mkimage -c ../cfg -p /EFI/BOOT -d ./grub-core/ \
	              -O ${GRUB_TARGET}-efi -o ./${GRUB_IMAGE_PREFIX}${GRUB_IMAGE} \
	              --pubkey grubgpg.pub  \
	              ${GRUB_BUILDIN}
	rm -f grubgpg.pub
}

do_deploy_append_class-target() {
    install -d ${DEPLOYDIR}/grub/${GRUB_TARGET}-efi
    cp -r ${D}/${libdir}/grub/${GRUB_TARGET}-efi/*.mod ${DEPLOYDIR}/grub/${GRUB_TARGET}-efi

    # Share gpghome so that we can sign everyting in resin-image
    cp -a ${B}/gpghome ${DEPLOYDIR}/grub/
}
