CXX = g++
CXXFLAGS = -std=c++11 -Wall -Werror -g
LDFLAGS = -lssl -lcrypto
TARGETS = random_walk merkle

all: build

build: $(TARGETS)

random_walk: main.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

merkle: merkle.cpp
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)

run: random_walk merkle
	./random_walk && ./merkle

clean:
	rm -f $(TARGETS) function_trace.txt merkle_root.txt

.PHONY: all build run clean
