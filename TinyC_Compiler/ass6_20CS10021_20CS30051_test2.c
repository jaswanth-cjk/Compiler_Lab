int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

//loop test
void func(int* a, int x)
{
	*a = *a * x;
    printStr("New value is :")
}

void main()
{
	int x=2, y=10;
	float z = 0.625;
	while(y--)		//while loop
	{
		z = z * x;
	}
	int *a;			//pointer usage for function call
	*a = 96;
	do {			// do-while loop
		func(a,x);
		x++;
	} while(z > *a);
	return;
}