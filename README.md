# 80386-assembly-string-interpolation

An simple 80386 Assembly program written in AT&T syntax which implements string interpolation.

# How to run?

To compile and run on `x86_64` Ubuntu use:
```
gcc -m32 main.S string_interpolation.S
```

Using the `-m32` flag requires `gcc-multilib`, you can install using:
```
sudo apt-get install -y gcc-multilib
```

# System calls table

This program uses two system calls, `mmap2` and `munmap`. You can find all `32 bit` Linux system calls on in Chromium OS documentation:
https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86-32_bit