int func(int i, int j, int x, int y)
{
	if (j / i > y) x++;		//arithmetic operations
	else x=x-x%2;
	return x;
}

void main()
{
	int x = 5;
	float y = 3.7;
	int z = y * x;			//typecasting
	int i, j;
	int a[25][25];				//2D array declaration
	for(i = 1; i < z; i++)		//nested loops
	{
		for(j = z; j > i; j--)
		{
			a[i][j] = func(i, j, x, y);		//function call
		}
	}
	return;
}