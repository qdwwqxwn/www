
for file in *.php; do 
  sed 's#/home/cacti/my-scripts#/var/www/scripts/ticktock#' $file > $file.tmp
  sed 's#/home/cacti/#/var/www/data/ticktock/#' $file.tmp > $file.tmp2
  mv  $file.tmp2 $file 
done

