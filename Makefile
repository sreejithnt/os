# Automatically generate lists of sources using wildcards .
C_SOURCES = $( wildcard kernel/*.c drivers/*.c)
HEADERS = $( wildcard kernel/*.h drivers/*.h )

# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = $ {C_SOURCES :.c =.o}

all: disk.img

# This is the actual disk image that the computer loads
disk.img: os_image.bin
	dd conv=notrunc if=os_image.bin of=disk.img bs=512

# This is the actual binary
# which is the combination of our compiled bootsector and kernel
# $^ stands for all dependencies.
# in this case it is boot/bl_kernel.bin kernel.bin
os_image.bin: boot/bl_kernel.bin kernel.bin
	cat $^ > os_image.bin


# This builds the binary of our kernel from two object files :
# the linker links these together and creates the binary file
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
# - $@ means the target file - kernel.bin in this case
kernel.bin: kernel/kernel_entry.o ${OBJ} 
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary


# Generic rule for compiling C code to an object file
# For simplicity , we assume C files depend on all header files .
%.o: %.c ${HEADERS}
	gcc -fno-pie -m32 -ffreestanding -c $< -o $@


# Assemble the kernel_entry.
# $< stands for first dependency
# elf format is needed by the linker to link with c object file
%.o: %.asm
	nasm $< -f elf -o $@

# this is for bootloader
# this binary and along with kernel binary make it disk image
%.bin: %.asm
	nasm $< -f bin -o $@

create_disk: boot/bl_kernel.asm
	dd if=/dev/zero of=disk.img bs=512 count=2880

clean:
	rm -fr *.o *.bin disk.img
	rm -fr kernel/*.o boot/*.bin drivers/*.o