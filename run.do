vsim +access+r;
run -all;
acdb save;
acdb report -db  fcover.acdb -txt -o cov.txt  
exec cat cov.txt;
exit