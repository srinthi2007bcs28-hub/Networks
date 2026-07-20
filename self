#include <stdio.h>
#include <string.h>

void printBinary(unsigned char ch)
{
    for(int i=7;i>=0;i--)
        printf("%d",(ch>>i)&1);
    printf(" ");
}

int main()
{
    char data[100], stuffed[200], received[200], recovered[100];
    int i,j=0,k=0;

    printf("BYTE STUFFING\n");
    printf("SOF = F\nEOF = E\nESC = /\n");

    printf("\nEnter Original Message: ");
    scanf("%99s",data);

    stuffed[j++]='F';
    for(i=0;data[i]!='\0';i++)
    {
        if(data[i]=='F' || data[i]=='E' || data[i]=='/')
            stuffed[j++]='/';
        stuffed[j++]=data[i];
    }
    stuffed[j++]='E';
    stuffed[j]='\0';

    printf("\n----- SENDER SIDE -----\n");
    printf("Original Message : %s\n",data);

    printf("Original Binary  : ");
    for(i=0;data[i]!='\0';i++) printBinary(data[i]);
    printf("\n");

    printf("Stuffed Frame    : %s\n",stuffed);

    printf("Stuffed Binary   : ");
    for(i=0;stuffed[i]!='\0';i++) printBinary(stuffed[i]);
    printf("\n");

    printf("Transmitted Frame: %s\n",stuffed);

    strcpy(received,stuffed);

    char ch;
    printf("\nDo you want to induce error? (Y/N): ");
    scanf(" %c",&ch);

    if(ch=='Y'||ch=='y')
    {
        int pos,bit;
        printf("\n1. Bit Level Error\n2. Byte Level Error\nChoice: ");
        int c; scanf("%d",&c);

        if(c==1)
        {
            printf("Enter Byte Position (1-%lu): ",strlen(received));
            scanf("%d",&pos);
            printf("Enter Bit Position (1-8): ");
            scanf("%d",&bit);
            if(pos>=1 && pos<=strlen(received) && bit>=1 && bit<=8)
                received[pos-1]^=(1<<(8-bit));
        }
        else if(c==2)
        {
            printf("Enter Byte Position (1-%lu): ",strlen(received));
            scanf("%d",&pos);
            if(pos>=1 && pos<=strlen(received))
                received[pos-1]^=0xFF;
        }
    }

    printf("\n----- RECEIVER SIDE -----\n");
    printf("Received Frame   : %s\n",received);

    printf("Received Binary  : ");
    for(i=0;received[i]!='\0';i++) printBinary(received[i]);
    printf("\n");

    if(strcmp(stuffed,received)!=0)
    {
        printf("\nTransmission Status : ERROR DETECTED");
        printf("\nFrame Discarded\n");
        return 0;
    }

    printf("\nTransmission Status : NO ERROR\n");

    k=0;
    int len=strlen(received);
    for(i=1;i<len-1;i++)
    {
        if(received[i]=='/')
            i++;
        recovered[k++]=received[i];
    }
    recovered[k]='\0';

    printf("\nRecovered Data   : %s\n",recovered);
    printf("Recovered Binary : ");
    for(i=0;recovered[i]!='\0';i++) printBinary(recovered[i]);
    printf("\n");

    return 0;
}
