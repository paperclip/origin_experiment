
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/capability.h>
#include <sys/prctl.h>

#define pr_arg(x) ((unsigned long) x)

static int cap_set_ambient(cap_value_t cap, cap_flag_value_t set)
{
    int result, val;
    switch (set)
    {
        case CAP_SET:
	        val = PR_CAP_AMBIENT_RAISE;
            break;
        case CAP_CLEAR:
	        val = PR_CAP_AMBIENT_LOWER;
	        break;
        default:
	        errno = EINVAL;
	        return -1;
    }
    result = prctl(PR_CAP_AMBIENT, pr_arg(val), pr_arg(cap),  pr_arg(0), pr_arg(0));
    return result;
}

static void dump_capabilities()
{
    cap_flag_value_t v = 0;
    cap_t caps = cap_get_proc();
    int ret;
    printf("Launcher Before set Capabilities: %s\n", cap_to_text(caps, NULL));
    cap_value_t newcaps[1] = { CAP_DAC_READ_SEARCH, };
    cap_set_flag(caps, CAP_INHERITABLE, 1, newcaps, CAP_SET);
    cap_set_proc(caps);
    printf("Launcher After set Capabilities: %s\n", cap_to_text(caps, NULL));

    cap_get_flag(caps, CAP_DAC_READ_SEARCH, CAP_EFFECTIVE, &v);
    printf("launcher effective   CAP_DAC_READ_SEARCH = %d\n",v);
    cap_get_flag(caps, CAP_DAC_READ_SEARCH, CAP_PERMITTED, &v);
    printf("launcher permitted   CAP_DAC_READ_SEARCH = %d\n",v);
    cap_get_flag(caps, CAP_DAC_READ_SEARCH, CAP_INHERITABLE, &v);
    printf("launcher inheritable CAP_DAC_READ_SEARCH = %d\n",v);

    // if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_DAC_READ_SEARCH))
    // {
    //     perror("Cannot set CAP_DAC_READ_SEARCH ambient");
    // }

    errno = 0;
    ret = cap_set_ambient(CAP_DAC_READ_SEARCH, CAP_SET);
    if (ret != 0)
    {
        perror("cap_set_ambient fails");
    }

    cap_free(caps);
}


int main()
{
    char* argv[2] = {"exe", NULL};
    dump_capabilities();
    execv("./exe", argv);
    return 10;
}
