# 🧪 About AcidOS
AcidOS is a small real mode operating system made in 8086 Assembly. This project is being developed as a way to learn more about OSs.

# 🛠️ Current Progress
- ✅ **BIOS Parameter Block**
- ✅ **Extended Boot Record**
- ✅ **FAT12 Filesystem**
- ✅ **VESA Graphics**
- ❌ **Interrupts**
- ❌ **Timer**
- ❌ **Shell**
- ❌ **Memory Management**

# 🚀 Future Ideas
- **C Library**
- **Bitmap Fonts**
- **GUI**

# ⚙️ Building
### 🧰 Necessary Components
nasm
### 📄 Compiling
Run the make.sh script using `./make.sh` to compile the OS!
### 🚀 Running
use `qemu-system-i386 -drive format=raw,file="AcidOS.img"`

# 🤝 Contribute
For those who want to contribute to AcidOS, you can help me starring/forking this project or help with code using pull requests.

# 🗂️ Resources
- FAT: https://wiki.osdev.org/FAT#Reading_the_Boot_Sector
- Reading from the disk: https://youtu.be/srbnMNk7K7k
- LBA to CHS: http://www.osdever.net/tutorials/view/lba-to-chs
