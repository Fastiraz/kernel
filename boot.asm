[bits 16] ; we specify 16 bits because bios is a 16 bits system
[org 0x7C00] ; the bootloader is load at 0x7C00 address

; this is a constant to
; store the boot disk number
BOOT_DISK db 0

section .text
  global _start

_start:
  mov si, xcat
  mov [BOOT_DISK], dl ; retrieve boot disk number

  ; colors
  mov al, 0x10 ; https://mendelson.org/wpdos/videomodes.txt
  mov ah, 0x00
  int 0x10

  ; disk
  ; https://en.wikipedia.org/wiki/INT_13H
  mov ah, 0x2
  mov al, 0x1 ; number of sector to read
  mov ch, 0x0 ; which cylinder to read
  mov dh, 0x0 ; which head to read
  mov cl, 0x2 ; wich sector to read
  mov bx, 0x7E00 ; buffer address pointer
  mov dl, [BOOT_DISK] ; the disk
  int 0x13
  ; jmp 0x7E00
  jnb 0x7e00

loop_print:
  mov al, [si]
  inc si

  cmp al, 0
  je end

  ; let's write something using INT_10H
  ; https://en.wikipedia.org/wiki/INT_10H
  mov ah, 0xE
  ; mov al, [xcat]
  mov bh, 0
  mov bl, 0xC ; https://en.wikipedia.org/wiki/BIOS_color_attributes
  int 0x10

  jmp loop_print

end:
  cli ; disable interrupts
  hlt ; halt the CPU

xcat db "0xCat", 0
jmp $ ; loop of itself

; 510 - (actual address - start file address) +0 = 512
times 510-($-$$) db 0
dw 0xAA55 ; boot sector signature (little-endian)

times 1000 db 0
