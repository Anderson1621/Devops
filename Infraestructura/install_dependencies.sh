#!/bin/bash 
ls -al

find . -name "dependencies.lst" -exec sh -c '
for file do
 dir=${file%/*}
  echo "******************************"
 echo "Provisioning $dir"
 echo "******************************"
 pip3 install --requirement "$file" -t "$dir"
done' sh {} +

ls -al $dir