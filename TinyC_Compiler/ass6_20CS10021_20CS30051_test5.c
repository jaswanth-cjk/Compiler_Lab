int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

//arithmetic operations
int main()  
{  
    int a = 0, b = 1, c = 2, d = 3;
    printStr("Values of data is:");
    printInt(a);
    printStr(" ");
    printStr(b);
    printStr(" ");
    printInt(c);
    printStr(" ");
    printStr(d);
    c = b + d;
    printStr("Value of c is:");
    printInt(a);
    b = c - d;
    printStr("Value of b is:");
    printInt(a);
    a = b * c;
    printStr("Value of a is:");
    printInt(a);
    a++;
    printStr("Value of a is:");
    printInt(a);
    if(a > b)                   //conditionals
    {
        printStr("\na > b")
    }
    else
    {
        printStr("\na <= b")
    }
    return 0;  
}  