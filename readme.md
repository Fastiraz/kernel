# MBR (Master Boot Record)

The MBR is the first 512 bytes of a disk.
This is how the bootloader determine wich disk is bootable.
It read the first 512 bytes and if the 510 byte is 0x55 and the 511 byte is 0xAA, the bootloader consider that the disk is bootable and it will load the entire first 512 bytes and run the code at address 0.
You can find the structure on the link bellow.
https://en.wikipedia.org/wiki/Master_boot_record
