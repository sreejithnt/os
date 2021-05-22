all: disk.img

disk.img: os_image.bin
	dd conv=notrunc if=os_image.bin of=disk.img bs=512

os_image.bin: kernel.bin
	cat bl_kernel.bin kernel.bin > os_image.bin

kernel.bin: kernel_entry.o kernel.o 
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

kernel.o: bl_kernel.bin
	gcc -fno-pie -m32 -ffreestanding -c kernel_new.c -o kernel.o

bl_kernel.bin: bl_kernel.asm create_disk
	nasm -f bin bl_kernel.asm -o bl_kernel.bin

create_disk: bl_kernel.asm
	dd if=/dev/zero of=disk.img bs=512 count=2880

clean:
	rm *.o *.bin *.img
