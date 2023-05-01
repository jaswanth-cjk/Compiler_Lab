test: ass5_20CS30051_20CS10021
	./ass5_20CS30051_20CS10021 < ass5_20CS10021_20CS30051_test1.c > ass5_20CS10021_20CS30051_quads1.out
	./ass5_20CS30051_20CS10021 < ass5_20CS10021_20CS30051_test2.c > ass5_20CS10021_20CS30051_quads2.out
	./ass5_20CS30051_20CS10021 < ass5_20CS10021_20CS30051_test3.c > ass5_20CS10021_20CS30051_quads3.out
	./ass5_20CS30051_20CS10021 < ass5_20CS10021_20CS30051_test4.c > ass5_20CS10021_20CS30051_quads4.out
	./ass5_20CS30051_20CS10021 < ass5_20CS10021_20CS30051_test5.c > ass5_20CS10021_20CS30051_quads5.out

ass5_20CS30051_20CS10021: lex.yy.c y.tab.c ass5_20CS10021_20CS30051_translator.o
	g++ lex.yy.c y.tab.c ass5_20CS10021_20CS30051_translator.o -o ass5_20CS30051_20CS10021

ass5_20CS10021_20CS30051_translator.o: ass5_20CS10021_20CS30051_translator.cxx ass5_20CS10021_20CS30051_translator.h
	g++ -c ass5_20CS10021_20CS30051_translator.h
	g++ -c ass5_20CS10021_20CS30051_translator.cxx

lex.yy.c: ass5_20CS10021_20CS30051.l y.tab.h ass5_20CS10021_20CS30051_translator.h
	flex ass5_20CS10021_20CS30051.l

y.tab.c y.tab.h: ass5_20CS10021_20CS30051.y
	bison -dty ass5_20CS10021_20CS30051.y

clean:
	rm lex.yy.*\
	   ass5_20CS30051_20CS10021\
	   y.tab.*\
	   ass5_20CS10021_20CS30051_translator.o\
	   ass5_20CS10021_20CS30051_translator.h.gch