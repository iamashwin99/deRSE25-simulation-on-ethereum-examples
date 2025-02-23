#include <iostream>
#include <cstdlib>
#include <fstream>
#include <string>

class FunctionTracer {
    static std::ofstream trace_file;
    static int indent_level;
    const char* name;
    std::string args;
    const int& result;

public:
    template<typename... Args>
    FunctionTracer(const char* n, const int& ret_val, Args... arguments) : name(n), result(ret_val) {
        if (!trace_file.is_open()) {
            trace_file.open("function_trace.txt");
        }
        args = build_args(arguments...);
        write_entry();
    }

    FunctionTracer(const char* n, const int& ret_val) : name(n), result(ret_val) {
        if (!trace_file.is_open()) {
            trace_file.open("function_trace.txt");
        }
        write_entry();
    }

    ~FunctionTracer() {
        write_exit();
    }

private:
    void write_entry() {
        trace_file << std::string(indent_level, ' ') << "Enter: " << name << "(" << args << ")\n";
        indent_level += 2;
    }

    void write_exit() {
        indent_level -= 2;
        trace_file << std::string(indent_level, ' ') << "Exit: " << name << "(" << args << ") -> " << result << "\n";
    }

    template<typename T>
    std::string build_args(T value) {
        return std::to_string(value);
    }

    template<typename T, typename... Args>
    std::string build_args(T first, Args... rest) {
        return std::to_string(first) + ", " + build_args(rest...);
    }

    std::string build_args() { return ""; }
};

std::ofstream FunctionTracer::trace_file;
int FunctionTracer::indent_level = 0;

#define TRACE_RETURN(ret_var, ...) \
    FunctionTracer _tracer(__FUNCTION__, ret_var __VA_OPT__(,) __VA_ARGS__)

int random_walk_step(int position, int rand_int) {
    int ret = position + (rand_int % 2 == 0 ? 1 : -1);
    TRACE_RETURN(ret, position, rand_int);
    return ret;
}

int main() {
    int ret = 0;
    TRACE_RETURN(ret);
    std::srand(42);
    int position = 0;
    int rand_int = 0;

    for (int i = 0; i < 100; ++i) {
        rand_int = std::rand();
        position = random_walk_step(position, rand_int);
        std::cout << "Step " << i << ": " << position << "\n";
    }

    return ret;
}