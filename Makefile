#OBJS = nptl-init.o 
CC = gcc
#CFLAGS= -I. -D_GNU_SOURCE -fPIC -DORIGINAL -DMY_DEBUG
CFLAGS= -g -O2 -fno-omit-frame-pointer -I. -D_GNU_SOURCE -fPIC -DWITH_TRYLOCK #-DGET_STATISTICS #REPORT_LINE_INFO
LD = $(CC)
LDFLAGS = -lpthread -ldl  -shared -lstdc++

TARGET = liblockperf.so 

SRCS = $(wildcard *.c)
CPP_SRCS = $(wildcard *.cpp)
OBJS = $(patsubst %.c,%.o,$(SRCS))
CPP_OBJS = $(patsubst %.cpp,%.o,$(CPP_SRCS))

#OBJECTS_AS := $(patsubst %.s,%.o,$(wildcard *.S))
OBJECTS_AS = lowlevellock.o
all: $(TARGET) CSCOPE

$(TARGET) : $(OBJS) $(OBJECTS_AS) $(CPP_OBJS)
#$(TARGET) : $(OBJS) 
	$(LD) -o $@ $^ $(LDFLAGS)
%.o : %.c
	$(CC) $(CFLAGS) -c $<
%.o : %.cpp
	$(CC) $(CFLAGS) -fpermissive -c $<
%.o : %.S
	$(CC) $(CFLAGS) -c $<
CSCOPE:
	`find -name '*.c' -o -name '*.cpp' -o -name '*.h' -name '*.hh'> cscope.files`
	`cscope -b -q -k`

clean:
	rm -f liblockperf.so *.o
