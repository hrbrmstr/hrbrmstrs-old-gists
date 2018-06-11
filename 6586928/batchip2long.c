#include <string.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>

//
// Read in a file with one IP address per line
// and output (to stdout) the same list with
// the longint version of it.
//
// No error checking! #youvebeenwarned
//
// gcc -o batchip2long batchip2long.c
//

int main(int argc, char *argv[]) {

   char ip[16] ;

   FILE *f = fopen(argv[1],"r");

   while(fgets(ip, sizeof ip, f) != NULL) {

      ip[strlen(ip)-1] = '\0'; // take care of eol

      printf("%s,%ld\n",ip,(long unsigned int)htonl(inet_addr(ip)));

   }

   fclose(f) ;
}