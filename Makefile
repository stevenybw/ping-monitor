PACKAGE=ping-monitor
VERSION=1.0
ARCH=all

all:
	mkdir -p build/DEBIAN
	cp -r debian/control debian/postinst build/DEBIAN/
	chmod 755 build/DEBIAN/postinst

	mkdir -p build/etc/systemd/system
	cp etc/systemd/system/ping-monitor.service build/etc/systemd/system/

	mkdir -p build/usr/local/bin
	cp usr/local/bin/ping-monitor.sh build/usr/local/bin/
	chmod +x build/usr/local/bin/ping-monitor.sh

	dpkg-deb --build build $(PACKAGE)_$(VERSION)_$(ARCH).deb

