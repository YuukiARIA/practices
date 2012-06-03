
default: checker

checker: check.out

solution: Main.class

check.out: check.c
	gcc -Wall -O2 check.c -o check.out

Main.class: Main.java
	javac Main.java

check_all: checker solution
	@echo "Input 1:"
	@java -cp . Main < E1-in.txt > E1-out.txt
	@./check E1-out.txt E1-ans.txt
	@echo "Input 2:"
	@java -cp . Main < E2-in.txt > E2-out.txt
	@./check E2-out.txt E2-ans.txt
	@echo "Input 3:"
	@java -cp . Main < E3-in.txt > E3-out.txt
	@./check E3-out.txt E3-ans.txt
	@echo "Input 4:"
	@java -cp . Main < E4-in.txt > E4-out.txt
	@./check E4-out.txt E4-ans.txt

clean:
	rm -f *.out *.class *-out.txt
