CXXFLAGS += -O3 -std=c++11 -Wall -Wpedantic -fPIC
LIB_DIR = lib

ifdef SYSTEMROOT
    CXXFLAGS += -lpthread
else
    CXXFLAGS += -pthread
endif

ifeq ($(SSE4),1)
	CXXFLAGS += -msse4.2
endif

SRCS := $(wildcard omp/*.cpp)
OBJS := ${SRCS:.cpp=.o}

all: lib/libompeval.a test ev evpy

lib:
	mkdir lib

lib/libompeval.a: $(OBJS) | lib
	ar rcs $@ $^

test: test.cpp benchmark.cpp lib/libompeval.a
	$(CXX) $(CXXFLAGS) -o $@ $^

ev: ev.cpp lib/libompeval.a
	$(CXX) $(CXXFLAGS) -o $@ $^

evpy: setup.py pyCardRange.pyx $(LIB_DIR)/libompeval.a 
	CFLAGS="$(CXXFLAGS)" python setup.py build_ext --inplace

clean:
	$(RM) test test.exe lib/libompeval.a $(OBJS) pyCardRange.cpp pyCardRange.so
