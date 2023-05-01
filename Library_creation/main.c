
// Name: Chukka Jaswanth Kumar
// Roll No: 20CS10021
// Compilers Assignment 2

#include "myl.h"

int main()
{
    printStr("************ Testing the library ************\n");
    printStr("\n");

    printStr("\n******* Testing the printStr function *******\n");

    printStr("\n Example String_1 : ");
    char *str1 = "Hello.";
    int lenStr1 = printStr(str1);
    printStr("\n # Number of characters printed : ");
    printInt(lenStr1);

    printStr("\n\n ********* Example String_2 : ");
    char *str2 = "Testing some new string: jaswanth_cjk";
    int lenStr2 = printStr(str2);
    printStr("\n # Number of characters printed : ");
    printInt(lenStr2);

    printStr("\n\n******* Testing the printInt function *******\n");

    printStr("\n Example Integer_1 : ");
    int num1 = 9843210;
    int lenNum1 = printInt(num1);
    printStr("\n # Number of characters printed : ");
    printInt(lenNum1);

    printStr("\n\n Example Integer_2 : ");
    int num2 = -1909834;
    int lenNum2 = printInt(num2);
    printStr("\n # Number of characters printed : ");
    printInt(lenNum1);

    printStr("\n\n******* Testing the printFlt function *******\n");

    printStr("\n Example Float_1 : ");
    float float1 = 5.342579;
    int lenFloat1 = printFlt(float1);
    printStr("\n # Number of characters printed : ");
    printInt(lenFloat1);

    printStr("\n\n Example Float_2 : ");
    float float2 = -987.048549;
    int lenFloat2 = printFlt(float2);
    printStr("\n # Number of characters printed : ");
    printInt(lenFloat2);

    printStr("\n\n******** Testing the readInt function ********\n");

    printStr("\nEnter Integer_1 : ");
    int n1;
    int flag1 = readInt(&n1);
    if (flag1 == ERR)
        printStr("!!! It is not a valid integer number !!!");
    else
    {
        printStr("Entered integer is : ");
        printInt(n1);
    }

    printStr("\n\nEnter Integer_2 : ");
    int n2;
    int flag2 = readInt(&n2);
    if (flag2 == ERR)
        printStr("!!! It is not a valid integer number !!!");
    else
    {
        printStr("Entered integer is: ");
        printInt(n2);
    }

    printStr("\n\n******** Testing the readFlt function ********\n");

    printStr("\n Enter Float_1 : ");
    float f1;
    int flag3 = readFlt(&f1);
    if (flag3 == ERR)
        printStr("!!! It is not a valid float number !!!");
    else
    {
        printStr("Entered float is: ");
        printFlt(f1);
    }

    printStr("\n\nEnter Float_2 : ");
    float f2;
    int flag4 = readFlt(&f2);
    if (flag4 == ERR)
        printStr("!!! It is not a valid float number !!!");
    else
    {
        printStr("Entered float is: ");
        printFlt(f2);
    }
    printStr("\n\n");
}
