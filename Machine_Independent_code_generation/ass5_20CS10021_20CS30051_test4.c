//function call from another function
int max_mag(int x, int y) 
{
   int ans = 0;
   if(x < 0) x = -x;          //unary operator
   if(y < 0) y = -y;
   ans = x > y ? x : y;		//ternary operator
   return ans;
}

int max_area(int a, int b)
{
	int side = max_mag(a, b);
	int area = side * side;
	return area;
}

int main()
{
	int x = max_area(7, -9);
	return;
}