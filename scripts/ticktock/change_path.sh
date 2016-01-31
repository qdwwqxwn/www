
for file in *.sh; do 
  sed 's#/var/www/data/ticktock/#/var/www/data/ticktock/#' $file > $file.tmp
  mv  $file.tmp $file 
done

