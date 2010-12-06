#!/bin/sh
tag=$1;
source_dir=$2;
destination_dir=$3;

#Keep a few directory variables so that everything will go smoothly in any case
working_dir=`pwd`;
flatten_base_dir=`dirname $0`;

echo "Downloading (if necessary) the affected projects, and checkouting tag '$tag' in them."

while read project ;
do 
  if [ ! -d $source_dir/$project ]
  then
    mkdir -p $source_dir/$project ;
  fi
  cd $source_dir/$project ;
  if [ ! -d .git ]
  then
    cd ..
    git clone -o korg git://android.git.kernel.org/platform/$project.git ;
    cd `basename $project` ;
    git fetch ;
  fi
  git checkout $tag ;
  cd $working_dir ;
done < $flatten_base_dir/$tag.projects

mkdir -p $destination_dir;

echo "Copying files...";

while read folder ;
do cp -r $source_dir/$folder/* $destination_dir ;
done < $flatten_base_dir/$tag.folders

#Remove Android.mk - it does not make sense in that context.
rm -f $destination_dir/Android.mk ;

#Put the resources in their rightful package
cp -r $destination_dir/resources/* $destination_dir ;
rm -rf $destination_dir/resources

echo "Done.";

