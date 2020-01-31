#include "readfile.h"


#include <stdio.h>

#include <sys/capability.h>
#include <linux/capability.h>

static void dump_capabilities()
{
    cap_flag_value_t v = 0;
    cap_t caps = cap_get_proc();

    cap_get_flag(caps, CAP_DAC_READ_SEARCH, CAP_EFFECTIVE, &v);
    printf("exe effective CAP_DAC_READ_SEARCH = %d\n",v);
    cap_get_flag(caps, CAP_DAC_READ_SEARCH, CAP_PERMITTED, &v);
    printf("exe permitted   CAP_DAC_READ_SEARCH = %d\n",v);
    cap_get_flag(caps, CAP_DAC_READ_SEARCH, CAP_INHERITABLE, &v);
    printf("exe inheritable CAP_DAC_READ_SEARCH = %d\n",v);

    cap_free(caps);
}


int main()
{
    dump_capabilities();
    return readSecretFile();
}
