[BITS    16]

GetCPUInfo:
        pusha

        xor     eax, eax

        cpuid

        mov     [vendor + 8], ebx
        mov     [vendor + 12], edx
        mov     [vendor + 16], ecx

        popa

        ret

vendor:
        db "Vendor: "
        times 13 db 0x00
