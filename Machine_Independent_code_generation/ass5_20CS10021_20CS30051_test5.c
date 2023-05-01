int main()  
{  
    int a = 0, b = 1, c = 2, d = 3;
    c = b ^ d;
    b = c & d;
    a = b | c;
    char ans;
    if(a > b)                   //nested if-else
    {
        if(c > d) ans = 'c';
        else ans = 'd';
    }
    else
    {
        if(c > d) ans = 'a';
        else ans = 'b';
    }
    return 0;  
}  