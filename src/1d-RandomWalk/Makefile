CXX = g++
CXXFLAGS = -std=c++11 -Wall -Werror -g
LDFLAGS = -lssl -lcrypto
TARGETS = random_walk merkle

all: build

build: $(TARGETS)

random_walk: main.cpp
	$(CXX) $(CXXFLAGS) -DENABLE_INSTRUMENTATION -o $@ $<

merkle: merkle.cpp
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)

run: random_walk merkle
	./random_walk && ./merkle

instrumentation_comparison: main.cpp
	@echo "Building random_walk with instrumentation..."
	@sed 's/for (int i = 0; i < 100; ++i)/for (int i = 0; i < 1000000; ++i)/' main.cpp > main_perf_test.cpp
	$(CXX) $(CXXFLAGS) -DENABLE_INSTRUMENTATION -o random_walk_instrumented main_perf_test.cpp
	@echo "Building random_walk without instrumentation..."
	$(CXX) $(CXXFLAGS) -o random_walk_no_instrumentation main_perf_test.cpp
	@echo "Running performance comparison (1M iterations)..."
	@echo "Performance Comparison Report" > performance_comparison.txt
	@echo "============================" >> performance_comparison.txt
	@/bin/bash -c 'echo "Date: $$(date)"' >> performance_comparison.txt
	@echo "Test Configuration: 1,000,000 random walk steps" >> performance_comparison.txt
	@echo "" >> performance_comparison.txt
	@echo "Testing with instrumentation (3 runs):" >> performance_comparison.txt
	@/bin/bash -c '(time -p ./random_walk_instrumented > /dev/null) 2>&1 | grep real' >> performance_comparison.txt
	@/bin/bash -c '(time -p ./random_walk_instrumented > /dev/null) 2>&1 | grep real' >> performance_comparison.txt
	@/bin/bash -c '(time -p ./random_walk_instrumented > /dev/null) 2>&1 | grep real' >> performance_comparison.txt
	@echo "" >> performance_comparison.txt
	@echo "Testing without instrumentation (3 runs):" >> performance_comparison.txt
	@/bin/bash -c '(time -p ./random_walk_no_instrumentation > /dev/null) 2>&1 | grep real' >> performance_comparison.txt
	@/bin/bash -c '(time -p ./random_walk_no_instrumentation > /dev/null) 2>&1 | grep real' >> performance_comparison.txt
	@/bin/bash -c '(time -p ./random_walk_no_instrumentation > /dev/null) 2>&1 | grep real' >> performance_comparison.txt
	@echo "" >> performance_comparison.txt
	@echo "- Instrumented version includes function call tracing overhead" >> performance_comparison.txt
	@echo "- Non-instrumented version has no tracing code compiled in" >> performance_comparison.txt
	@echo "- Each run performs 1,000,000 function calls to random_walk_step()" >> performance_comparison.txt
	@echo "- File I/O overhead in instrumented version affects performance" >> performance_comparison.txt
	@echo "" >> performance_comparison.txt
	@ls -1shS function_trace.txt 2>/dev/null | /bin/bash -c 'read -r line; echo "Trace file size: $${line}"' >> performance_comparison.txt 2>/dev/null || echo "No trace file generated" >> performance_comparison.txt
	@echo "" >> performance_comparison.txt
	@echo "Comparison completed. Results saved to performance_comparison.txt"
	@cat performance_comparison.txt
	@rm -f random_walk_instrumented random_walk_no_instrumentation main_perf_test.cpp

clean:
	rm -f $(TARGETS) function_trace.txt merkle_root.txt performance_comparison.txt random_walk_instrumented random_walk_no_instrumentation main_perf_test.cpp test_instrumented

.PHONY: all build run clean instrumentation_comparison
