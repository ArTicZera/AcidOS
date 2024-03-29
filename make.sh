clear

BIN="Binaries"
ACIDOSIMG="AcidOS.img"

echo -e "\n\e[33;40mCompiling files!\e[0m\n"
nasm -fbin Bootloader/boot.asm -o $BIN/boot.bin
nasm -fbin Kernel/kernel.asm -o $BIN/kernel.bin

echo -e "\n\e[33;40mMounting Image File!\e[0m\n"
dd if=/dev/zero of=AcidOS.img bs=512 count=2880
mkfs.fat -F 12 -n "ACIDOS" AcidOS.img
dd if=$BIN/boot.bin of=AcidOS.img conv=notrunc
mcopy -i AcidOS.img $BIN/kernel.bin "::kernel.bin"

if [ $? -eq 0 ]; then
    echo -e "\n\e[36;40mCompiled successfully!\e[0m\n"
else
    echo -e "\n\e[31;40mError compiling!\e[0m\n"
fi

qemu-system-i386 -enable-kvm -m 2048 -smp 4 -drive format=raw,file="AcidOS.img"
