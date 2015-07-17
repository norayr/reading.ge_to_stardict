

#download

wget -c -O tmp.html http://www.reading.ge/ka/dictionary

#get our line

cat tmp.html | grep նաև > tmp1.html

#make eols

sed -i 's/<\/tr>/<\/tr>\n/g' tmp1.html


#clean tabs
rm -f *.tab

#process

while read line
do

#get georgian word
gw=`echo $line | awk -F '[<>]' '{ print $5 }'`
printf "$gw\t\t"
#get az word
aw=`echo $line | awk -F '[<>]' '{ print $9 }'`
#printf "$aw\t\t"
#get armenian word
if [ "$gw" == "ზეზვა" ]
then
   hw="Զեզվա (անուն)"
elif [ "$gw" == "ლოც" ]
then
   hw="Վերջածանց"
else
   hw0=`echo $line | awk -F '[<>]' '{ print $13 }'`
   hw1=`echo $hw0 | sed 's/-/֊/g'`
   hw2=`echo $hw1 | sed 's/\.\.\.\./…/g'`
   hw3=`echo $hw2 | sed 's/\.\.\./…/g'`
   hw4=`echo $hw3 | sed 's/\./․/g'`
   hw=`echo $hw4 | sed 's/\,\ օր․/;\ օր․/g'`
fi
printf "$hw\n"
#write ge-hy.tab
echo -e "$gw\t\t\t$hw\n" >> reading.ge_ge-hy.tab

#write ge-az.tab
echo -e "$gw\t\t\t$aw\n" >> reading.ge_ge-az.tab

# now we need to generate reverse dictionary, armenian - georgian
# it would be easy if each georgian word would have only one translation
# however sometimes there are several translations separated by commas
if [[ $hw == *","* ]]
then

   #for word in $(echo $hw | sed -n 1'p' | tr ',' '\n')
   #do 
   #remove text in parentheses
   withoutpar=`echo $hw | sed s/'([^)]*)'/''/g`
   echo $withoutpar | sed -n 1'p' | tr ',' '\n' | while read word
	  do
	  #remove numbers followed by dots
      #word1=`echo $word | sed 's/[0-9]//g'`
	  #word2=`echo $word1 | sed 's/\.//g'`
      word1=`echo $word | sed 's/[0-9]․//g'`
	  #word2=`echo $word1 | sed 's/\.\.\./…/g'`
	  #word3=`echo $word1 | sed 's/\./․/g'`
	  echo -e "$word1\t\t\t$gw" >> reading.ge_hy-ge.tab
   done
else
      echo -e "$hw\t\t\t$gw" >> reading.ge_hy-ge.tab
fi

done < tmp1.html




#create dictionary files
mkdir -p out
cp *.tab out
cd out
stardict_tabfile reading.ge_ge-hy.tab
stardict_tabfile reading.ge_ge-az.tab
stardict_tabfile reading.ge_hy-ge.tab
