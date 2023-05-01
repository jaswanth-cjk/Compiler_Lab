test: a.out
	./a.out
a.out: main.o lib20CS10021_ass2.a
	cc main.o -L. -l20CS10021_ass2

main.o: main.c myl.h
	cc -c main.c

lib20CS10021_ass2.a: 20CS10021_ass2.o
	ar -rcs lib20CS10021_ass2.a 20CS10021_ass2.o

20CS10021_ass2.o: 20CS10021_ass2.c myl.h
	cc -c 20CS10021_ass2.c

clean:
	rm a.out main.o lib20CS10021_ass2.a 20CS10021_ass2.o 

