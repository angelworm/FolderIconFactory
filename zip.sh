#!/bin/bash 

archive_name="source"

base=`dirname $0`
echo $base;

exclued_files="${base}/without.sh"

#without_files=`echo $without_files | sed -e s/\ /\|/`
#exclued_files="--exclude (${without_files})"
#for e in $without_file
#do
#	echo $e;
#	exclued_files=${exclued_files}" --exclude "$e
#done

echo $exclued_files
echo `cat $exclued_files`
tar cvzfX "$archive_name".tgz ${exclued_files} . 