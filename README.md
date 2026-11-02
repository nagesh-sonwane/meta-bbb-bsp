<!-- Copyright (c) 2026 Nagesh Sonwane <nagesh.sonwane@hotmail.com> -->

# meta-bbb-bsp

`meta-bbb-bsp` is a Scarthgap BSP customization layer for BeagleBone
hardware. It builds on TI's `meta-beagle` layer from the Scarthgap branch of
[`meta-ti`](https://git.yoctoproject.org/meta-ti), rather than copying its
machine, kernel, or U-Boot recipes.

The layer adds the `beaglebone-custom` machine, which requires and inherits
TI's `beaglebone` machine configuration. It sets the hostname to `bbb-server`
and enables systemd-resolved mDNS announcements, so the device is discoverable
as `bbb-server.local` on supporting local networks. Its kernel and U-Boot
`.bbappend` files provide recipe-local search paths for custom patches. Add
board-specific kernel and bootloader changes there; keep image recipes and
package selection in `meta-custom-core`. The U-Boot recipe sets the generated
extlinux root argument to `/dev/mmcblk0p2`, the root partition in the TI
two-partition SD image layout. Its config fragment sets the default boot delay
to three seconds; this provides a three-second autoboot interruption window,
not a persistent stop at the U-Boot prompt.

## Layer dependencies

- OE-Core: `oe-core/meta` (from the `openembedded-core` project)
- TI BSP: `meta-ti/meta-ti-bsp`
- TI BeagleBone support: `meta-ti/meta-beagle`
- ARM layers: `meta-arm/meta-arm-toolchain` and `meta-arm/meta-arm`

Add these layers and `meta-bbb-bsp` to `BBLAYERS` in this order:

```bitbake
BBLAYERS += " \
  /path/to/meta-arm/meta-arm-toolchain \
  /path/to/meta-arm/meta-arm \
  /path/to/meta-ti/meta-ti-bsp \
  /path/to/meta-ti/meta-beagle \
  /path/to/meta-openembedded/meta-oe \
  /path/to/meta-openembedded/meta-perl \
  /path/to/meta-openembedded/meta-python \
  /path/to/meta-openembedded/meta-networking \
  /path/to/meta-openembedded/meta-webserver \
  /path/to/meta-bbb-bsp \
"
```

The Scarthgap checkouts used in this workspace are `meta-openembedded` and
`sources/meta-arm` / `sources/meta-ti`.

## Build

The layer includes board-specific `local.conf` and `bblayers.conf` samples in
`conf/templates/beaglebone-custom/`. From the workspace root, initialize a
build with:

```sh
TEMPLATECONF="$PWD/sources/meta-bbb-bsp/conf/templates/beaglebone-custom" \
  source oe-core/oe-init-build-env build-bbb
```

The template enables the OE-Core, ARM, TI BeagleBone, and project layers,
selects `beaglebone-custom`, and uses the `network-servers` distribution.
The template paths are relative to the OE-Core checkout (`oe-core` in this
workspace). `meta-openembedded` provides additional layers and is not a
replacement for OE-Core.

TI's BeagleBone machine defaults to the `bb_org-6_12` BSP profile (Linux 6.12
and U-Boot 2025.x on the current Scarthgap branch). To select the available
6.6 profile instead:

```bitbake
TI_PREFERRED_BSP = "bb_org-6_6"
```

The base machine supports the BeagleBone device trees provided by TI's layer.
Use `meta-custom-core` for project image recipes and package groups.

## Adding patches

Place Linux patches in `recipes-kernel/linux/files/` and U-Boot patches in
`recipes-bsp/u-boot/files/`. Reference them from the corresponding `.bbappend`
using `SRC_URI`, for example:

```bitbake
SRC_URI:append:beaglebone-custom = " file://0001-custom-board-change.patch"
```

The append files set up these recipe-local directories as `FILESEXTRAPATHS`.
