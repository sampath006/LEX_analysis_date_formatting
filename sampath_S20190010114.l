%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int chk=0;
	char need;
	void full_date(char*);
	char* mnt_num(int);
	char* full_mnt(char*);
	int dated=0,monthm=0,yeary=0;
%}

alp [a-zA-Z]
lower [a-z]
upper [A-Z]
digit [0-9]
new_par "\n\n"
month_ab "Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sept"|"Oct"|"Nov"|"Dec"|"jan"|"feb"|"mar"|"apr"|"may"|"jun"|"jul"|"aug"|"sept"|"oct"|"nov"|"dec"
month_fu "January"|"February"|"March"|"April"|"May"|"June"|"July"|"August"|"September"|"October"|"November"|"December"|"january"|"february"|"march"|"april"|"may"|"june"|"july"|"august"|"september"|"october"|"november"|"december"
dd [0123]?[0-9]("nd"|"st"|"rd"|"th")?
del [ ,/-]
%%

\n[\t ]+{alp} {
	if(yytext[yyleng-1]>=97 && yytext[yyleng-1]<=122)
		{
			yytext[yyleng-1]-=32;
		}
	fprintf(yyout,"\n%c",yytext[yyleng-1]);
}

^[ \t]*({alp}) {
	if (chk==0)
	{
		chk=1;
		if(yytext[yyleng-1]>=97 && yytext[yyleng-1]<=122)
		{
			yytext[yyleng-1]-=32;
		}
		fprintf(yyout,"\t%c",yytext[yyleng-1]);
		}
	else{
		fprintf(yyout,"%s",yytext);
	}
		}

("."|"?"|"!")" "*\n\n(\n)*[ \t]*({alp}) {
	if(yytext[yyleng-1]>=97 && yytext[yyleng-1]<=122)
	{
		yytext[yyleng-1]-=32;
	}
	if (yytext[yyleng-2]!='\t'){
		need=yytext[yyleng-1];
		yytext[yyleng-1]='\t';
		fprintf(yyout,"%c\n\n\t%c",yytext[0],need);
	}
	else{
		fprintf(yyout,"%c\n\n\t%c",yytext[0],yytext[yyleng-1]);
	}

	
}
("."|"?"|"!"|",")" "*\n?{lower} {
	yytext[yyleng-1]-=32;
	fprintf(yyout,"%s",yytext);
}

(((("."|"?"|"!")(" ")+[\n\t]*)|("."|"?"|"!")" "*\n\n(\n)*[ \t]*))?({month_ab}|{month_fu}){del}{dd} {
	for(int i=0;i<yyleng;i++)
	{
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	yeary=2021;
	dated=0;
	int poi_r=yyleng-1,val=1;
	while(yytext[poi_r]!=' '){
		if(yytext[poi_r]>=48 && yytext[poi_r]<58){
			dated+=(yytext[poi_r]-48)*val;
			val=val*10;
		}
		poi_r--;
	}
	int i=0,cnn=0,cnt=0,j=0;
	while(!((yytext[i]>=97 && yytext[i]<=122)||(yytext[i]>=65 && yytext[i]<=90))){
		if(yytext[i]=='\n')
		{
			cnn++;
		}
		else if(yytext[i]=='\t')
		{
			cnt++;
		}
		i++;
	}
	j=i;
	if( cnn>2){
		j-=cnn;
		cnt=-1;
	}
	if (cnt>1){
		j-=cnt;
		cnt=-1;
	}
	for(int p=0;p<j;p++){
		fprintf(yyout,"%c",yytext[p]);
	}
	if(cnn==-1){
		fprintf(yyout,"\n\n");
	}
	else if(cnt==-1){
		fprintf(yyout,"\t");
	}
	char pr[poi_r-i+1];
	int i_c=0,l=poi_r-i;
	for(i_c=0;i_c<l;i_c++){
		pr[i_c]=yytext[i];
		i++;
	}
	pr[i_c]='\0';
	char* mon=full_mnt(pr);
	fprintf(yyout,"%s %d,%d",mon,dated,yeary);

}

((((("."|"?"|"!")(" ")+[\n\t]*)|(("."|"?"|"!")" "*\n\n(\n)*[ \t]*)))?(({month_ab}|{month_fu}){del}{dd}{del}({digit}{digit})?{digit}{digit})) {
for(int i=0;i<yyleng;i++){
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	yeary=0;
	dated=0;
	int va=1,poi_r=yyleng-1;
	while(yytext[poi_r]!=' '){
		yeary += (yytext[poi_r]-48)*va;
		va*=10;
		poi_r--;
	}
	poi_r--;
	if(yeary/100==0){
		if(yeary>21){
			yeary+=1900;
		}
		else{
			yeary+=2000;
		}
	}
	va=1;
	while(yytext[poi_r]!=' '){
		if(yytext[poi_r]>=48 && yytext[poi_r]<=57){
		dated += (yytext[poi_r]-48)*va;
		va*=10;
		}
		poi_r--;
	}
	int i=0,cnn=0,cnt=0,j=0;
	while(!((yytext[i]>=97 && yytext[i]<122)||(yytext[i]>=65 && yytext[i]<=90))){
		if(yytext[i]=='\n')
		{
			cnn++;
		}
		else if(yytext[i]=='\t')
		{
			cnt++;
		}
		i++;
	}

	j=i;
	if( cnn>2){
		j-=cnn;
		cnt=-1;
	}
	if (cnt>1){
		j-=cnt;
		cnt=-1;
	}
	for(int p=0;p<j;p++){
		fprintf(yyout,"%c",yytext[p]);
	}
	if(cnn==-1){
		fprintf(yyout,"\n\n");
	}
	else if(cnt==-1){
		fprintf(yyout,"\t");
	}
	char pr[poi_r-i+1];
	int i_c=0,l=poi_r-i;
	for(i_c=0;i_c<l;i_c++){
		pr[i_c]=yytext[i];
		i++;
	}
	pr[i_c] = '\0';
	char* mon=full_mnt(pr);
	fprintf(yyout,"%s %d,%d",mon,dated,yeary);
}

{dd}{del}(("0"[1-9])|"1"[012]|[1-9]){del}({digit}{digit})?{digit}{digit} {
	for(int i=0;i<yyleng;i++){
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	int mnt=0,poi_r=yyleng-1,i=0,va=1;
	dated=0;
	yeary=0;
	while(yytext[poi_r]!=' '){
		yeary+=(yytext[poi_r]-48)*va;
		va*=10;
		poi_r--;
	}
	if(yeary/100==0){
		if(yeary>21){
			yeary+=1900;
		}
		else{
			yeary+=2000;
		}
	}

	va=1;
	poi_r--;
	while(yytext[poi_r]!=' '){
		mnt+=(yytext[poi_r]-48)*va;
		va*=10;
		poi_r--;
	}
	char*mon = mnt_num(mnt);
	va=1;
	poi_r--;
	while(poi_r>=0){
		
		if(yytext[poi_r]>=48 && yytext[poi_r]<=57){
		dated += (yytext[poi_r]-48)*va;
		va*=10;
		}
		poi_r--;

	}
	fprintf(yyout,"%s %d,%d",mon,dated,yeary);
}

{dd}{del}({month_ab}|{month_fu}){del}({digit}{digit})?{digit}{digit} {
	for(int i=0;i<yyleng;i++){
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	int poi_r=yyleng-1,i=0,va=1;
	dated=0;
	yeary=0;
	while(yytext[poi_r]!=' '){
		yeary+=(yytext[poi_r]-48)*va;
		va*=10;
		poi_r--;
	}
	if(yeary/100==0){
		if(yeary>21){
			yeary+=1900;
		}
		else{
			yeary+=2000;
		}
	}
	poi_r--;
	while(yytext[poi_r]!=' '){
		i++;
		poi_r--;
	}
	char mnt[i];
	int j = 0;
	for(j=0;j<i;j++){
		mnt[j]=yytext[poi_r+1+j];
	}
	mnt[j] = '\0';
	char* mon=full_mnt(mnt);
	va=1;
	poi_r--;
	while(poi_r>=0){
		if(yytext[poi_r]>=48 && yytext[poi_r]<=57){
		dated += (yytext[poi_r]-48)*va;
		va*=10;
		}
		poi_r--;

	}
	fprintf(yyout,"%s %d,%d",mon,dated,yeary);

}

{dd}{del}({month_ab}|{month_fu}) {
	for(int i=0;i<yyleng;i++){
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	int poi_r=yyleng-1,va=1,i=0;
	while(yytext[poi_r]!=' '){
		i++;
		poi_r--;
	}
	char mnt[i+1];
	int j = 0;
	for(j=0;j<i;j++){
		mnt[j]=yytext[poi_r+1+j];
	}
	mnt[j] = '\0';
	char* mon = full_mnt(mnt);
	poi_r--;
	dated=0;
	while(poi_r>=0){
		if(yytext[poi_r]>=48 && yytext[poi_r]<=57){
		dated += (yytext[poi_r]-48)*va;
		va*=10;
		}
		poi_r--;
	}
	yeary=2021;
	fprintf(yyout,"%s %d,%d",mon,dated,yeary);
}

((^[ \t]*)|(\n[\t ]+))(({month_ab}|{month_fu}){del}{dd}{del}({digit}{digit})?{digit}{digit}) {
for(int i=0;i<yyleng;i++){
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	yeary=0;
	dated=0;
	int va=1,poi_r=yyleng-1;
	while(yytext[poi_r]!=' '){
		yeary += (yytext[poi_r]-48)*va;
		va*=10;
		poi_r--;
	}
	poi_r--;
	if(yeary/100==0){
		if(yeary>21){
			yeary+=1900;
		}
		else{
			yeary+=2000;
		}
	}
	va=1;
	while(yytext[poi_r]!=' '){
		if(yytext[poi_r]>=48 && yytext[poi_r]<=57){
		dated += (yytext[poi_r]-48)*va;
		va*=10;
		}
		poi_r--;
	}
	int i=0,cnn=0,cnt=0,j=0;
	while(!((yytext[i]>=97 && yytext[i]<122)||(yytext[i]>=65 && yytext[i]<=90))){
		if(yytext[i]=='\n')
		{
			cnn++;
		}
		else if(yytext[i]=='\t')
		{
			cnt++;
		}
		i++;
	}

	j=i;
	if( cnn>2){
		j-=cnn;
		cnt=-1;
	}
	if (cnt>1){
		j-=cnt;
		cnt=-1;
	}
	for(int p=0;p<j;p++){
		fprintf(yyout,"%c",yytext[p]);
	}
	if(cnn==-1){
		fprintf(yyout,"\n\n");
	}
	else if(cnt==-1){
		fprintf(yyout,"\t");
	}
	char pr[poi_r-i+1];
	int i_c=0,l=poi_r-i;
	for(i_c=0;i_c<l;i_c++){
		pr[i_c]=yytext[i];
		i++;
	}
	pr[i_c] = '\0';
	char* mon=full_mnt(pr);
	fprintf(yyout,"\t %s %d,%d",mon,dated,yeary);
}

((^[ \t]*)|(\n[\t ]+))({month_ab}|{month_fu}){del}{dd} {
	for(int i=0;i<yyleng;i++)
	{
		if(yytext[i]==','||yytext[i]=='/'||yytext[i]=='-'){
			yytext[i]=' ';
		}
	}
	yeary=2021;
	dated=0;
	int poi_r=yyleng-1,val=1;
	while(yytext[poi_r]!=' '){
		if(yytext[poi_r]>=48 && yytext[poi_r]<58){
			dated+=(yytext[poi_r]-48)*val;
			val=val*10;
		}
		poi_r--;
	}
	int i=0,cnn=0,cnt=0,j=0;
	while(!((yytext[i]>=97 && yytext[i]<=122)||(yytext[i]>=65 && yytext[i]<=90))){
		if(yytext[i]=='\n')
		{
			cnn++;
		}
		else if(yytext[i]=='\t')
		{
			cnt++;
		}
		i++;
	}
	j=i;
	if( cnn>2){
		j-=cnn;
		cnt=-1;
	}
	if (cnt>1){
		j-=cnt;
		cnt=-1;
	}
	for(int p=0;p<j;p++){
		fprintf(yyout,"%c",yytext[p]);
	}
	if(cnn==-1){
		fprintf(yyout,"\n\n");
	}
	else if(cnt==-1){
		fprintf(yyout,"\t");
	}
	char pr[poi_r-i+1];
	int i_c=0,l=poi_r-i;
	for(i_c=0;i_c<l;i_c++){
		pr[i_c]=yytext[i];
		i++;
	}
	pr[i_c]='\0';
	char* mon=full_mnt(pr);
	fprintf(yyout,"%s %d,%d",mon,dated,yeary);

}




%%

char* mnt_num(int mnt){
	switch(mnt){
		case 1:
			return "January";
		case 2:
			return "February";
		case 3:
			return "March";
		case 4:
			return "April";
		case 5:
			return "May";
		case 6:
			return "June";
		case 7:
			return "July";
		case 8:
			return "August";
		case 9:
			return "September";
		case 10:
			return "October";
		case 11:
			return "November";
		case 12:
			return "December";
		
	}	
}
char* full_mnt(char* str){
	if(str[0]>=97 && str[0]<=122)
	{
		str[0]-=32;
	}
	if(strcmp(str,"Jan")==0 || strcmp(str,"January")==0)
	{
		return "January";
	}
	if(strcmp(str,"Feb")==0 || strcmp(str,"February")==0)
	{
		return "February";
	}
	if(strcmp(str,"Mar")==0 || strcmp(str,"March")==0)
	{
		return "March";
	}
	if(strcmp(str,"Apr")==0 || strcmp(str,"April")==0)
	{
		return "April";
	}
	if(strcmp(str,"May")==0 || strcmp(str,"May")==0)
	{
		return "May";
	}
	if(strcmp(str,"Jun")==0 || strcmp(str,"June")==0)
	{
		return "June";
	}
	if(strcmp(str,"Jul")==0 || strcmp(str,"July")==0)
	{
		return "July";
	}

	if(strcmp(str,"Aug")==0 || strcmp(str,"August")==0)
	{
		return "August";
	}

	if(strcmp(str,"Sept")==0 || strcmp(str,"September")==0)
	{
		return "September";
	}

	if(strcmp(str,"Oct")==0 || strcmp(str,"October")==0)
	{
		return "October";
	}

	if(strcmp(str,"Nov")==0 || strcmp(str,"November")==0)
	{
		return "November";
	}

	if(strcmp(str,"Dec")==0 || strcmp(str,"December")==0)
	{
		return "December";
	}


	
}

int main(){
	extern FILE *yyin,*yyout;
	yyin=fopen("Input.txt","r");
	yyout=fopen("Out.txt","w");
	yylex();
	fclose(yyin);
	fclose(yyout);
	return 0;
}
		
