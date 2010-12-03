#!/bin/sh
tag=$1;
source_dir=$2;
destination_dir=$3;

#Keep a few directory variables so that everything will go smoothly in any case
working_dir=`pwd`;
flatten_base_dir=`dirname $0`;

echo "Checkouting tag '$tag' in the affected projects."

while read line ;
do cd $source_dir/$line ;
git checkout $tag ;
cd $working_dir ;
done < $flatten_base_dir/$tag.projects.list

mkdir -p $destination_dir;

echo "Copying files...";

while read line ;
do cp -r $source_dir/$line/* $destination_dir ;
done < $flatten_base_dir/$tag.folders

#Removing files that are incidentally in the same folders but are not Java source files.
rm -rf $destination_dir/Android.mk $destination_dir/jarjar-rules.txt $destination_dir/overview.html $destination_dir/resources
echo "Done.";

