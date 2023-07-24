-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]

# SPECIFIC KERNEL PARAMETERS
---
[https://github.com/gg7/gentoo-kernel-guide](https://github.com/gg7/gentoo-kernel-guide)

__EFI stub__
```
Processor type and features ->
	[*] EFI runtime service support 
    [*]   EFI stub support
    [ ]     EFI mixed-mode support
    ...
    ...
    [*] Built-in kernel command line
    (root=/dev/sda2)
```

Intel Drivers

Nvidia Graphic cards

__BLUETOOTH__
```
[*] Networking support --->
	<M>   Bluetooth subsystem support --->
		[*]   Bluetooth Classic (BR/EDR) features
        <*>     RFCOMM protocol support
        [ ]       RFCOMM TTY support
        < >     BNEP protocol support
        [ ]       Multicast filter support
        [ ]       Protocol filter support
        <*>     HIDP protocol support
        [*]     Bluetooth High Speed (HS) features
        [*]   Bluetooth Low Energy (LE) features
	    Bluetooth device drivers ->
            <M> HCI USB driver
			<M> HCI UART driver 
	<*>   RF switch subsystem support ->
Device Drivers ->
	HID support ->
		<*>   User-space I/O driver support for HID subsystem
```

__TOUCHPAD SYNAPTICS__
```
Device Drivers  --->
   Input device support  --->
      <*>   Event interface
      [*]   Mice  --->
         <*>   PS/2 mouse
```

Virtualization
