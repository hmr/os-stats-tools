# osx-stat-tools
Simple and small tools to show various system stats which are unique to macOS.
Intended to be used in tmux's status line.

## print_uptime
To show uptime of macOS in human friendly style like.

```
$ ./bin/print_uptime
1M2w3d14h50m
```
This means the uptime is "1 month, 2 weeks, 3 days, 14 hours and 50 minutes".

### Compile
Clang or GCC is required to compile.

```
$ clang -o print_uptime print_uptime.c
```

## print_mpressure
To calculate and show memory pressure.
```
$ ./bin/print_mpressure
25.4
```
This means the memory pressure is 25.4%.
