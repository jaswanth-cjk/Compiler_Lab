/*
    Jashwanth Kumar Chukka (20CS10021)
    Sourabh Soumyakanta Das (20CS30051)
*/

inline int check_equal(int A[], int n, int p)
{
    for(int i=0; i<n; i++)
    {
        if(A[i] == p) return i;
    }

    return -1;
}

int power(int x, int n)
{
    if(x == 0) return 1;
    else if(x == 1) return x;

    else if(x & 1 == 1) return power(x, (n-1)/2)*power(x, (n-1)/2)*x;
    else
        return power(x, n/2)*power(x, n/2);
}

enum check;
enum month{Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec}

restrict int v = 2;
volatile int c = 56;
static int b = 67;

signed main()
{
    float v = 1.23e12;
    double g = 4.33E-34;
    int g = 13;

    int a, b;
    a = 12; b = 13;

    int c;
    c = a&b;
    c = a|b;
    c = a^b;
    c -= a*b + c;

    c <<= a/b;

    // Checking single line comments

    /* Checking multi line comments
    */

   int g = 100;
   while(g--)
   {
    if(g == 10) break;
    else
        continue;
   }

   float val = 100.23;

   do{
    val--;
    g++;
   }while(val > 12);

   int check = 23;

   switch(check)
   {
    case 23: break;
    case 22: val++; break;
    default: break;
   }

    return 0;
}