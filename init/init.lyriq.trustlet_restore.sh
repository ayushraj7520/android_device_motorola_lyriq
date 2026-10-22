#!/vendor/bin/sh
#
# On release-keys builds mcDriverDaemon searches /vendor/app/mcRegistry,
# /data/vendor/mcRegistry and /system/app/mcRegistry for trustlets.
# On test-keys builds it only searches /mnt/vendor/tzapp, which holds the
# vendor-set trustlets but not the factory-provisioned ones (e.g. the SPI
# driver 030b that the Goodix fingerprint TA needs via drSpiSend).
# Mirror any factory trustlets from /data/vendor/mcRegistry into tzapp so
# the daemon can load them. New files take effect on the next boot.

SRC=/data/vendor/mcRegistry
DST=/mnt/vendor/tzapp

[ -d "$SRC" ] || exit 0
[ -d "$DST" ] || exit 0

copied=0
for f in "$SRC"/*.drbin "$SRC"/*.tlbin "$SRC"/*.tabin; do
    [ -f "$f" ] || continue
    b="${f##*/}"
    [ -e "$DST/$b" ] && continue
    if cp "$f" "$DST/$b"; then
        chown system:system "$DST/$b" 2>/dev/null
        chmod 0644 "$DST/$b" 2>/dev/null
        restorecon "$DST/$b" 2>/dev/null
        echo "lyriq_trustlet_restore: restored $b into tzapp" > /dev/kmsg
        copied=1
    fi
done

if [ "$copied" = "1" ]; then
    echo "lyriq_trustlet_restore: tzapp updated, reboot to load restored trustlets" > /dev/kmsg
fi
exit 0
