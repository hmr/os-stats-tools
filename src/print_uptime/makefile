OS := $(shell uname -s)
SRC := print_uptime.c
BIN := print_uptime

# ビルドモード判定
ifeq ($(mode),debug)
	OPT := -DDEBUG -O0 -g
else
	OPT := -O3
endif

# OSごとの設定
ifeq ($(OS),Linux)
	CC := gcc
	CFLAGS := -D_LINUX $(OPT)
	LDFLAGS := -lm
	ARCH :=
else ifeq ($(OS),Darwin)
	CC := cc
	CFLAGS := -D_MACOS $(OPT)
	LDFLAGS := -lm
	ARCH := -arch arm64 -arch x86_64
endif

all: build run

build:
	@echo "Making binary for $(OS)."
	$(CC) $(ARCH) $(CFLAGS) -o $(BIN) $(SRC) $(LDFLAGS)

run:
	@./$(BIN)

clean:
	rm -f $(BIN)
