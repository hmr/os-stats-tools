/* vim: ft=c fenc=utf-8
 *
 * print_uptime.c
 * This program shows uptime of macOS in human friendly style.
 *
 * ORIGIN: 20202-12-03 by hmr
 */

#include <time.h>
#include <errno.h>
#include <sys/sysctl.h>
#include <stdio.h>
#include <math.h>

/* This function is derive from stackoverflow.
 * https://stackoverflow.com/questions/3269321/ */
double get_uptime()
{
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
}

int main(void)
{
    double uptime_orig, remaining;
    int uptime_month, uptime_week, uptime_day, uptime_hour, uptime_min, uptime_sec;
    const int min_sec = 60;
    const int hour_sec = min_sec * 60;
    const int day_sec = hour_sec * 24;
    const int week_sec = day_sec * 7;
    const int month_sec = day_sec * 30;

    uptime_orig = get_uptime();

    uptime_month  = (int) floor(uptime_orig / month_sec);
    uptime_week   = (int) floor(fmod(uptime_orig, month_sec) / week_sec);
    uptime_day    = (int) floor(fmod(uptime_orig, week_sec) / day_sec);
    uptime_hour   = (int) floor(fmod(uptime_orig, day_sec) / hour_sec);
    uptime_min    = (int) floor(fmod(uptime_orig, hour_sec) / min_sec);
    uptime_sec    = (int) fmod(uptime_orig, min_sec);

    // printf("Origin: %.0lf\n", uptime_orig);
    if(uptime_month > 0) printf("%dM", uptime_month);
    if(uptime_week  > 0) printf("%dw", uptime_week);
    if(uptime_day   > 0) printf("%dd", uptime_day);
    if(uptime_hour  > 0) printf("%dh", uptime_hour);
    if(uptime_min   > 0) printf("%dm", uptime_min);
    printf("\n");
    // printf("Sec: %d\n", uptime_sec);

    return 0;
}

