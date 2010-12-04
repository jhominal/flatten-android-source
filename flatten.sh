#!/bin/sh
tag=$1;
source_dir=$2;
destination_dir=$3;

#Keep a few directory variables so that everything will go smoothly in any case
working_dir=`pwd`;
flatten_base_dir=`dirname $0`;

echo "Downloading (if necessary) the affected projects, and checkouting tag '$tag' in them."

while read line ;
do 
  if [ ! -d $source_dir/$line ]
  then
    mkdir -p $source_dir/$line ;
  fi
  cd $source_dir/$line ;
  if [ ! -d .git ]
  then
    cd ..
    git clone -o korg git://android.git.kernel.org/platform/$line.git ;
    cd $working_dir ;
    cd $source_dir/$line ;
    git fetch ;
  fi
  git checkout $tag ;
  cd $working_dir ;
done < $flatten_base_dir/$tag.projects

mkdir -p $destination_dir;

echo "Copying files...";

while read line ;
do cp -r $source_dir/$line/* $destination_dir ;
done < $flatten_base_dir/$tag.folders

#Remove files that don't make sense in a flattened hierarchy.
rm -f $destination_dir/Android.mk ;
#Put the "resources" in their rightful package
cp -r $destination_dir/resources/* $destination_dir ;
rm -rf $destination_dir/resources
echo "Done.";

