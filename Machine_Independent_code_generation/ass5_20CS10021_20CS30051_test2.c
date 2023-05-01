void func(int* a, int x)
{
	*a = *a * x;
}

int main()
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