[bits 16] ; we specify 16 bits because bios is a 16 bits system
[org 0x7C00] ; the bootloader is load at 0x7C00 address

section .text
  global _start

_start:
  mov si, xcat

print_loop:
  mov al, [si]
  inc si

  cmp al, 0
  je end

  ; let's write something using INT_10H
  ; https://en.wikipedia.org/wiki/INT_10H
  mov ah, 0xE
  ; mov al, [xcat]
  mov bh, 0
  mov bl, 0xD ; https://en.wikipedia.org/wiki/BIOS_color_attributes
  int 0x10

  jmp print_loop

end:
  cli ; disable interrupts
  hlt ; halt the CPU

xcat db "0xCat", 0
jmp $ ; loop of itself

; 510 - (actual address - start file address) +0 = 512
times 510-($-$$) db 0
dw 0xAA55 ; boot sector signature (little-endian)
