CXX = g++
CXXFLAGS = -std=c++11 -Wall -Werror
TARGET = random_walk

all: build

build: $(TARGET)

$(TARGET): main.cpp
	$(CXX) $(CXXFLAGS) -o $(TARGET) main.cpp

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
