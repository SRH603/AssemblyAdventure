```bash
as -arch arm64 hello.s -o hello.o
clang -arch arm64 -nostartfiles -Wl,-e,_start hello.o -o hello
./hello
```
# AssemblyAdventure
