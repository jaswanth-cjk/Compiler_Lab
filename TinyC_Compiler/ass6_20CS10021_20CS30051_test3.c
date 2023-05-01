int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

//global declarations
int i, arr[50];                         // 1D array declaration
int fib(int n);           				// function declaration
char c='v', d='i';						// char declaration

//recursive function calling
int fib(int n){
    printStr("\nValue of input is :");
    printInt(n);
	if(n <= 1) return n;
	else if(arr[n] != -1) return arr[n];
	else return arr[n] = fib(n-1) + fib(n-2);
}

void main()
{
	for(i = 0; i < 50; i++)
	{
		arr[i] = -1;
	}
	arr[0] = 0;
    arr[1] = 0;
	int x = fib(32);
	char res;
	if(x%2 == 1 && x > 100) res = c;
	else res = d;
    printStr("Conditionals checked");
	return 0;
}