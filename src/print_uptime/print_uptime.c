/* vim: ft=c fenc=utf-8
 *
 * print_uptime.c
 * This program shows uptime of macOS in human friendly style.
 *
 * ORIGIN: 20202-12-03 by hmr
 */

#ifdef _LINUX
#include <sys/sysinfo.h>
#endif

#ifdef _MACOS
#include <time.h>
#include <sys/sysctl.h>
#endif

#include <errno.h>
#include <stdio.h>
#include <math.h>

#ifdef DEBUG
#define dbgprintf(fmt, ...)  printf(fmt, __VA_ARGS__);
#else
#define dbgprintf(fmt, ...)
#endif

/* This function is derive from stackoverflow.
 * https://stackoverflow.com/questions/3269321/ */
double get_uptime()
{
#ifdef _LINUX
    struct sysinfo s_info;
    errno=0;
    sysinfo(&s_info);
    dbgprintf("errno=%d\n", errno);
    long uptime = s_info.uptime;
    dbgprintf("uptime=%ld\n", uptime);
    return (double)uptime;
#endif

#ifdef _MACOS
    struct timeval boottime;
    size_t len = sizeof(boottime);
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    if( sysctl(mib, 2, &boottime, &len, NULL, 0) < 0 )
    {
        return -1.0;
    }
    time_t bsec = boottime.tv_sec;
    time_t csec = time(NULL);

    return difftime(csec, bsec);
#endif
}

int main(void)
{
    double uptime_orig, uptime_month, uptime_week, uptime_day, uptime_hour, uptime_min, uptime_sec;
    const double min_sec = 60;
    const double hour_sec = min_sec * 60;
    const double day_sec = hour_sec * 24;
    const double week_sec = day_sec * 7;
    const double month_sec = day_sec * 30;

    uptime_orig = get_uptime();
    dbgprintf("uptime_orig=%f\n", uptime_orig);
    errno=0;
    uptime_month  = uptime_orig / month_sec;
    dbgprintf("errno=%d, uptime_month=%f\n", errno, uptime_month);
    errno=0;
    uptime_week   = fmod(uptime_orig, month_sec) / week_sec;
    dbgprintf("errno=%d, uptime_week=%f\n", errno, uptime_week);
    errno=0;
    uptime_day    = fmod(uptime_orig, week_sec) / day_sec;
    dbgprintf("errno=%d, uptime_day=%f\n", errno, uptime_day);
    errno=0;
    uptime_hour   = fmod(uptime_orig, day_sec) / hour_sec;
    dbgprintf("errno=%d, uptime_hour=%f\n", errno, uptime_hour);
    errno=0;
    uptime_min    = fmod(uptime_orig, hour_sec) / min_sec;
    dbgprintf("errno=%d, uptime_min=%f\n", errno, uptime_min);
    errno=0;
    uptime_sec    = fmod(uptime_orig, min_sec);
    dbgprintf("errno=%d, uptime_sec=%f\n", errno, uptime_sec);

    // printf("Origin: %.0lf\n", uptime_orig);
    if(uptime_month >= 1) printf("%dM", (int)floor(uptime_month));
    if(uptime_week  >= 1) printf("%dw", (int)floor(uptime_week));
    if(uptime_day   >= 1) printf("%dd", (int)floor(uptime_day));
    if(uptime_hour  >= 1) printf("%dh", (int)floor(uptime_hour));
    if(uptime_min   >= 1) printf("%dm", (int)floor(uptime_min));
    printf("\n");
    // printf("Sec: %d\n", uptime_sec);

    return 0;
}

