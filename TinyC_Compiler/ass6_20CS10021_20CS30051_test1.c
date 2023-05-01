int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

//passing data to functions as pointers and 1-D array test
void func(int* a)
{
	printStr("\nValue of a[2] is :");
    printInt(a[2]);
}

void strPrint(char* s)
{
    printStr(s);
}

void main()
{
	int i;
	int a[20];
	for(i = 0; i < 20; i++)		//loops
	{
		a[i] = i;
	}
    char* x = "Printing has started.";
    strPrint(x);
    func(a);
	return;
}