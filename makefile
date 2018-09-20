debug_or_optimize = -O1

CXX = g++
CXXFLAGS = -Wall -Werror -pedantic --std=c++11 $(debug_or_optimize)

all: test

debug: debug_or_optimize = -g
debug: clean
debug: test

test: BinarySearchTree_compile_check.exe \
		BinarySearchTree_tests.exe \
		BinarySearchTree_public_test.exe \
		Map_compile_check.exe Map_public_test.exe main

	./BinarySearchTree_tests.exe
	./BinarySearchTree_public_test.exe

	./Map_public_test.exe > Map_public_test.out.txt
	diff -q Map_public_test.out.txt Map_public_test.out.correct

	./main train_small.csv test_small.csv --debug > test_small_debug.out.txt
	diff -q test_small_debug.out.txt test_small_debug.out.correct

	./main train_small.csv test_small.csv > test_small.out.txt
	diff -q test_small.out.txt test_small.out.correct

main: main.cpp
	$(CXX) $(CXXFLAGS) main.cpp -o $@

%_public_test.exe: %_public_test.cpp unit_test_framework.cpp  %.h
	$(CXX) $(CXXFLAGS) $< unit_test_framework.cpp -o $@

%_compile_check.exe: %_compile_check.cpp %.h
	$(CXX) $(CXXFLAGS) $< -o $@

# disable built-in rules
.SUFFIXES:

# these targets do not create any files
.PHONY: clean
clean :
	rm -vrf *.o *.exe *.gch *.dSYM *.out.txt main
