#include <stdio.h>
#include <sys/mman.h>
int main(void)
{
    void *ptr = mmap(NULL, 60000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
    printf("PROT_READ = %d\n", PROT_READ);
    printf("PROT_WRITE = %d\n", PROT_WRITE);
    printf("PROT_READ | PROT_WRITE = %d\n", PROT_READ | PROT_WRITE);
    printf("MAP_SHARED = %d\n", MAP_SHARED);
    printf("MAP_ANONYMOUS = %d\n", MAP_ANONYMOUS);
    printf("MAP_PRIVATE | MAP_ANONYMOUS = %d\n", MAP_PRIVATE | MAP_ANONYMOUS);
    munmap(ptr, 4096);
    return 0;
}