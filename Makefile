SHELL = /bin/bash
.PHONY: all clean help install
include $(shell pwd)/../../device/rockchip/.BoardConfig.mk
include $(shell pwd)/../../distro/output/.config

CURDIR := $(shell pwd)

install:
	mkdir -p $(DESTDIR)/oem $(DESTDIR)/userdata $(DESTDIR)/mnt/sdcard $(DESTDIR)/etc/init.d $(DESTDIR)/lib/udev/rules.d $(DESTDIR)/usr/bin $(DESTDIR)/usr/sbin
	install -m 0755 -D $(CURDIR)/S50usbdevice $(DESTDIR)/etc/init.d/
	install -m 0644 -D $(CURDIR)/61-usbdevice.rules $(DESTDIR)/lib/udev/rules.d/
	install -m 0755 -D $(CURDIR)/usbdevice $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/glmarktest.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/gstaudiotest.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/gstmp3play.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/gstmp4play.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/gstvideoplay.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/gstvideotest.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/gstwavplay.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/mp3play.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/waylandtest.sh $(DESTDIR)/usr/bin/
	install -m 0755 -D $(CURDIR)/S21mountall.sh $(DESTDIR)/etc/init.d/
	install -m 0755 -D $(CURDIR)/fstab $(DESTDIR)/etc/
	install -m 0644 -D $(CURDIR)/61-partition-init.rules $(DESTDIR)/lib/udev/rules.d/
	install -m 0644 -D $(CURDIR)/61-sd-cards-auto-mount.rules $(DESTDIR)/lib/udev/rules.d/
	install -m 0755 -D $(CURDIR)/resize-helper $(DESTDIR)/usr/sbin/
	install -m 0755 -D $(CURDIR)/S22resize-disk $(DESTDIR)/etc/init.d/
	`echo -e "/dev/disk/by-partlabel/oem\t/oem\t\t\t$(RK_OEM_FS_TYPE)\t\tdefaults\t\t0\t2" > $(DESTDIR)/etc/fstab` && \
	`echo -e "/dev/disk/by-partlabel/userdata\t/userdata\t\t$(RK_USERDATA_FS_TYPE)\t\tdefaults\t\t0\t2" >> $(DESTDIR)/etc/fstab`
	install -m 0644 -D -t $(DESTDIR)/usr/share/alsa/cards $(CURDIR)/cards/*
	install -m 0644 -D $(CURDIR)/asound.conf.in $(DESTDIR)/etc/asound.conf && \
	sed -i "s#\#PCM_ID#${BR2_PACKAGE_RKSCRIPT_DEFAULT_PCM}#g" $(DESTDIR)/etc/asound.conf
	cd / && ln -fs $(DESTDIR)/userdata $(DESTDIR)/data && ln -fs $(DESTDIR)/mnt/sdcard $(DESTDIR)/sdcard && cd -
	[ ! -e  $(DESTDIR)/etc/init.d/.usb_config ] && touch $(DESTDIR)/etc/init.d/.usb_config || true
	[ ! `grep usb_ums_en $(DESTDIR)/etc/init.d/.usb_config` ] && `echo usb_ums_en >> $(DESTDIR)/etc/init.d/.usb_config` || true
	[ ! `grep usb_adb_en $(DESTDIR)/etc/init.d/.usb_config` ] && `echo usb_adb_en >> $(DESTDIR)/etc/init.d/.usb_config` || true

