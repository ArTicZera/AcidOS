# 🍃 About FolhaOS
AcidOS is a small real mode operating system made in 8086 Assembly and C. This project is being developed as a way to learn more about OSs.

# 🛠️ Current Progress
- ✅ **BIOS Parameter Block**
- ✅ **Extended Boot Record**
- ✅ **VESA Graphics**
- 🚧 **FAT12 Filesystem**
- ❌ **C Kernel**
- ❌ **Interrupts**
- ❌ **Memory management**
- ❌ **Timer**
- ❌ **Shell**
- ❌ **Graphical Interface (GUI)**

# ⚙️ Building
### 🧰 Necessary Components
nasm
### 📄 Compiling
Run the make.sh script using `./make.sh` to compile the OS!
### 🚀 Running
use `qemu-system-i386 -drive format=raw,file="AcidOS.img"`

# 🤝 Contribute
For those who want to contribute to AcidOS, you can help me starring/forking this project or help with code using pull requests.

# Resources
- FAT: https://wiki.osdev.org/FAT#Reading_the_Boot_Sector
