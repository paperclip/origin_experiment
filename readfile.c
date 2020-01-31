
#include "readfile.h"

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int readSecretFile()
{
    char buffer[1024];
    int bytes_read;
    int fd = open("testfile",O_RDONLY);
    if (fd < 0)
    {
        perror("Unable to open testfile");
        return 1;
    }
    bytes_read = read(fd, buffer, 1023);
    if (bytes_read < 0)
    {
        perror("Unable to read from testfile");
        return 2;
    }
    buffer[bytes_read] = 0;

    printf("Able to read: %s\n", buffer);
    return 0;
}
