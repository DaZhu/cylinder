IPHONE_IP=iphone
#IPHONE_IP=root@192.168.1.7
#SSH_FLAGS=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
PACKAGE=cylinder.deb
BUNDLE_IDENTIFIER=com.r333d.cylinder

MOBSUB=.tmp/Library/MobileSubstrate/DynamicLibraries


all: tweak settings
	cd tweak && $(MAKE)
	cd settings && $(MAKE)

clean:
	cd tweak && $(MAKE) clean
	cd settings && $(MAKE) clean

package-dirs:
	mkdir -p .tmp
	mkdir -p .tmp/DEBIAN
	mkdir -p .tmp/Library
	mkdir -p .tmp/Library/Cylinder
	mkdir -p .tmp/Library/MobileSubstrate
	mkdir -p $(MOBSUB)
	mkdir -p .tmp/Library/PreferenceBundles
	mkdir -p .tmp/Library/PreferenceLoader/Preferences

tweak:
	cd tweak && $(MAKE)

settings:
	cd settings && $(MAKE)

$(PACKAGE): tweak/* settings/*
	$(MAKE) all
	$(MAKE) package-dirs
	cp tweak/Cylinder.dylib $(MOBSUB)
	cp tweak/Cylinder.plist $(MOBSUB)
	cp -r tweak/scripts/* .tmp/Library/Cylinder/
	cp -r settings/.theos/obj/CylinderSettings.bundle .tmp/Library/PreferenceBundles
	cp settings/entry.plist .tmp/Library/PreferenceLoader/Preferences
	cp control .tmp/DEBIAN/
	dpkg-deb -b .tmp
	mv .tmp.deb $(PACKAGE)
	rm -rf .tmp

package: $(PACKAGE)

install: $(PACKAGE)
	scp $(SSH_FLAGS) $(PACKAGE) $(IPHONE_IP):.
	ssh $(SSH_FLAGS) $(IPHONE_IP) "dpkg -i $(PACKAGE)"

uninstall:
	ssh $(SSH_FLAGS) $(IPHONE_IP) "apt-get remove $(BUNDLE_IDENTIFIER)"

respring:
	ssh $(SSH_FLAGS) $(IPHONE_IP) "killall SpringBoard"

babies:
	$(MAKE) install && $(MAKE) respring

money:
	$(MAKE) uninstall && $(MAKE) respring
