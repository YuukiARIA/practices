
default: checker

checker: check.out

solution_java: Main.class

solution_cpp: a.out

check.out: check.c
	gcc -Wall -O2 check.c -o check.out

Main.class: Main.java
	javac Main.java

a.out: main.cpp
	g++ -O2 main.cpp -o a.out

check_java: checker solution_java
	@echo "Input 1:"
	@java -cp . Main < E1-in.txt > E1-out.txt
	@./check.out E1-out.txt E1-ans.txt
	@echo "Input 2:"
	@java -cp . Main < E2-in.txt > E2-out.txt
	@./check.out E2-out.txt E2-ans.txt
	@echo "Input 3:"
	@java -cp . Main < E3-in.txt > E3-out.txt
	@./check.out E3-out.txt E3-ans.txt
	@echo "Input 4:"
	@java -cp . Main < E4-in.txt > E4-out.txt
	@./check.out E4-out.txt E4-ans.txt

check_cpp: checker solution_cpp
	@echo "Input 1:"
	@./a.out < E1-in.txt > E1-out.txt
	@./check.out E1-out.txt E1-ans.txt
	@echo "Input 2:"
	@./a.out < E2-in.txt > E2-out.txt
	@./check.out E2-out.txt E2-ans.txt
	@echo "Input 3:"
	@./a.out < E3-in.txt > E3-out.txt
	@./check.out E3-out.txt E3-ans.txt
	@echo "Input 4:"
	@./a.out < E4-in.txt > E4-out.txt
	@./check.out E4-out.txt E4-ans.txt

dist: check.c Main.java main.cpp Makefile
	tar -cvzf ../water_tank_checker.tar.gz *

clean:
	rm -f *.out *.class *-out.txt
