#include "myl.h"
#define BUFF 100

// Function to print an integer and return the no. of characters printed
int printInt(int n)
{
    char buff[BUFF];                                    // buff is the char array for storing characters to be printed
    int i=0,j,k,bytes;
    long long int x=n;                                  // long long int necessary for flipping the sign else overflow may occur
    if(x==0) buff[i++]='0';                             // case of 0
    else
    {
        if(x<0)                                         // case of negative number
        {
            buff[i++]='-';                              // add a -ve sign
            x=-x;                                       // flip the sign to make it positive
        }
        while(x)                                        // loop to store the digits in the char array (in reverse order)
        {
            int dig=x%10;
            buff[i++]=(char)('0'+dig);
            x/=10;
        }
        if(buff[0]=='-') j=1;                           // j is the position from which reversal is to start
        else j=0;
        k=i-1;                                          // k is the position where reversal is to end
        while(j<k)                                      // loop for reversal of digits
        {
            char temp=buff[j];
            buff[j++]=buff[k];
            buff[k--]=temp;
        }
    }
    buff[i]='\0';                                       // terminating with the null character
    bytes=i+1;
    __asm__ __volatile__(                               // printing the char array
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    );
    return i;                                           // i contains no. of characters printed
}

// Function to print a float and return the no. of characters printed
int printFlt(float f)
{
    char buff[BUFF];                                    // buff is the char array for storing characters to be printed
    int i=0,bytes;
    if(f==0)                                            // case of 0
    {
        buff[i++]='0';
        buff[i++]='.';
        buff[i++]='0';
    }
    else
    {
        if(f<0)                                         // case of negative number
        {
            buff[i++]='-';                              // add a -ve sign
            f*=-1;                                      // flip the sign to make it positive
        }
        if(f<1)                                         // case of float less than 1
        {
            buff[i++]='0';
            buff[i++]='.';
            while(f>0)                                  // storing the digits of the fractional part in the array
            {
                f*=10;
                buff[i++]=(char)('0'+(int)(f));
                f-=(int)(f);
                if(i==BUFF-1) break;                    // to stop putting characters in the array so that null character can be stored
            }
        }
        else                                            // case of float greater than or equal to 1
        {
            int cnt=i;                                  // cnt stores the position at which decimal point is to be inserted
            while(f>=1)                                 // converting the float into a fractional number
            {
                f/=10;
                cnt++;
            }
            while(f>0)                                  // storing the digits of the fractional part in the array
            {
                f*=10;
                buff[i++]=(char)('0'+(int)(f));
                f-=(int)(f);
                if(i==BUFF-1) break;                    // to stop putting characters in the array so that null character can be stored
                if(i==cnt) buff[i++]='.';               // adding decimal point at the proper position
                if(i==BUFF-1) break;                    // to stop putting characters in the array so that null character can be stored
            }
        }
    }
    buff[i]='\0';                                       // terminating with the null character
    bytes=i+1;
    __asm__ __volatile__(                               // printing the char array
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    );
    return i;                                           // i contains no. of characters printed
}

// Function to print a string and return the no. of characters printed
int printStr(char* s)
{
    int i=0,bytes;
    while(s[i]) i++;                                    // counter for no. of characters to be printed 
    bytes=i+1;
    __asm__ __volatile__(                               // printing the char array
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(s), "d"(bytes)
    );
    return i;                                           // i contains no. of characters printed
}

// Function to read an integer from the console and store it in the given variable
int readInt(int* n)
{
    char buff[BUFF];                                    // buff is the char array for storing characters taken as input
    const long long IntMaxMag=2147483647, IntMinMag=2147483648; // for comparison of input with integer limits
    int len;
    __asm__ __volatile__ (                               // taking input into the char array
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(buff), "d"(BUFF)
    );
    if(len<=0) return ERR;
    int i=0,neg=0,pos=0;
    if(buff[0]=='-') neg=1;
    if(buff[0]=='+') pos=1;
    if(neg || pos) i=1;                                 // setting offset in case sign is present
    while(buff[i]!=' ' && buff[i]!='\n' && buff[i]!='\t')
    {
        if(buff[i]<'0' || buff[i]>'9') return ERR;      // to check for non-digit in the input
        i++;
        if(i==BUFF) return ERR;                         // no. of characters input is more than buffer limit
    }
    long long int temp=0;                               // variable to store the generated integer (long long int to prevent overflow during sign flip)
    if(neg || pos) i=1;                                 // setting offset in case sign is present
    else i=0;
    while(buff[i]!=' ' && buff[i]!='\n' && buff[i]!='\t') // loop to use digits to generate the integer
    {
        temp=temp*10+(int)(buff[i]-'0');
        if(neg)                                         // integer limit check
        {
            if(temp>IntMinMag) return ERR;
        }
        else
        {
            if(temp>IntMaxMag) return ERR;
        }
        i++;
    }
    if((neg || pos) && i==1) return ERR;                // case of no digit after +ve or -ve sign
    else if(i==0) return ERR;                           // case of no input
    if(neg) *n=(int)(-temp);                            // setting the given variable to the appropriate value
    else *n=(int)(temp);
    return OK;
}

// Function to read a float from the console and store it in the given variable
int readFlt(float* f)
{
    char buff[BUFF];                                     // buff is the char array for storing characters taken as input
    int len;
    __asm__ __volatile__ (                               // taking input into the char array
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(buff), "d"(BUFF)
    );
    if(len<=0) return ERR;
    int i=0,neg=0,pos=0,dotFound=-1,eFound=-1,expSignFound=0;
    if(buff[0]=='-') neg=1;
    if(buff[0]=='+') pos=1;
    if(neg || pos) i=1;                                 // setting offset in case sign is present
    while(buff[i]!=' ' && buff[i]!='\n' && buff[i]!='\t')
    {
        if(buff[i]=='.')                                // check for decimal point occuring atmost once and before the exp sign
        {
            if(eFound==-1 && dotFound==-1) dotFound=i;
            else return ERR;
        }
        else if(buff[i]=='e' || buff[i]=='E')           // check for exp sign occuring atmost once
        {
            if(eFound==-1) eFound=i;
            else return ERR;
        }
        else if(buff[i]=='-' || buff[i]=='+')           // check for -ve or +ve signs occuring atmost once and just after exp sign
        {
            if(eFound!=-1 && expSignFound==0 && i==eFound+1)
            {
                if(buff[i]=='+') expSignFound=1;
                else expSignFound=-1;
            }
            else return ERR;
        }
        else if(buff[i]<'0' || buff[i]>'9') return ERR; // check for non digit characters
        i++;
        if(i==BUFF) return ERR;                         // no. of characters input is more than buffer limit
    }
    if((neg || pos) && i==1) return ERR;                // case of no digit after +ve or -ve sign
    else if(i==0) return ERR;                           // case of no input
    if(eFound!=-1 && i==eFound+1) return ERR;           // case of no digits after exp sign
    if(expSignFound!=0 && i==expSignFound+1) return ERR;// case of no digits after -ve or +ve signs
    if(neg || pos) i=1;                                 // setting offset in case sign is present
    else i=0;
    if((dotFound==-1 && eFound==i) || (dotFound!=-1 && eFound==dotFound+1)) return ERR; // case of no digit before exp sign
    float val=0;
    while(buff[i]!='.' && buff[i]!=' ' && buff[i]!='\n' && buff[i]!='\t' && buff[i]!='e' && buff[i]!='E') // storing integral part
    {
        val=val*10+(int)(buff[i]-'0');
        i++;
    }
    float frac=0;
    if(dotFound!=-1)                                    // storing the fractional part
    {
        int j=i+1;
        while(buff[j]!=' ' && buff[j]!='\n' && buff[j]!='\t' && buff[i]!='e' && buff[i]!='E') j++;
        j--;                                            // j is the location of the final digit of fractional part
        while(j>i)                                      // loop to store the digits in the fractional part
        {
            frac+=(int)(buff[j]-'0');
            frac/=10;
            j--;
        }
    }
    val+=frac;
    if(eFound!=-1) 
    {
        i=eFound+1;
        int cnt=0;
        if(expSignFound!=0) i++;
        while(buff[i]!=' ' && buff[i]!='\n' && buff[i]!='\t') // loop to find the given exponent
        {
            cnt=cnt*10+(int)(buff[i]-'0');
            i++;
        }
        if(expSignFound==-1)                            // case of negative exponent
        {
            while(cnt--) val/=10;
        }
        else                                            // case of positive exponent
        {
            while(cnt--) val*=10;
        }
    }
    if(neg) val*=-1;                                    // sign flip in case of -ve value
    *f=val;                                             // setting the given variable to the appropriate value
    return OK;
}