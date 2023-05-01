test: ass6_20CS30051_20CS10021 libass2_20CS30051.a
	./ass6_20CS30051_20CS10021 ass6_20CS10021_20CS30051_test1 > ass6_20CS10021_20CS30051_quads1.out
	./ass6_20CS30051_20CS10021 ass6_20CS10021_20CS30051_test2 > ass6_20CS10021_20CS30051_quads2.out
	./ass6_20CS30051_20CS10021 ass6_20CS10021_20CS30051_test3 > ass6_20CS10021_20CS30051_quads3.out
	./ass6_20CS30051_20CS10021 ass6_20CS10021_20CS30051_test4 > ass6_20CS10021_20CS30051_quads4.out
	./ass6_20CS30051_20CS10021 ass6_20CS10021_20CS30051_test5 > ass6_20CS10021_20CS30051_quads5.out

ass6_20CS30051_20CS10021: lex.yy.o y.tab.o ass6_20CS10021_20CS30051_translator.o ass6_20CS10021_20CS30051_target_translator.o
	g++ lex.yy.o y.tab.o ass6_20CS10021_20CS30051_translator.o ass6_20CS10021_20CS30051_target_translator.o -o ass6_20CS30051_20CS10021

ass6_20CS10021_20CS30051_target_translator.o: ass6_20CS10021_20CS30051_target_translator.cxx ass6_20CS10021_20CS30051_translator.h
	g++ -c ass6_20CS10021_20CS30051_target_translator.cxx

ass6_20CS10021_20CS30051_translator.o: ass6_20CS10021_20CS30051_translator.cxx ass6_20CS10021_20CS30051_translator.h
	g++ -c ass6_20CS10021_20CS30051_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass6_20CS10021_20CS30051.l y.tab.h ass6_20CS10021_20CS30051_translator.h
	flex ass6_20CS10021_20CS30051.l

y.tab.c y.tab.h: ass6_20CS10021_20CS30051.y
	bison -dty ass6_20CS10021_20CS30051.y

libass2_20CS30051.a: ass2_20CS30051.o
	ar -rcs libass2_20CS30051.a ass2_20CS30051.o

ass2_20CS30051.o: ass2_20CS30051.c myl.h
	gcc -c ass2_20CS30051.c

clean:
	rm  libass2_20CS30051.a\
		ass2_20CS30051.o\
		ass6_20CS30051_20CS10021\
		ass6_20CS10021_20CS30051_translator.o\
		ass6_20CS10021_20CS30051_target_translator.o\
		lex.yy.*\
		y.tab.*