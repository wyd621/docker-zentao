#!/bin/bash

PermanentDir="/data"
AppDir="/app"
UserCfg="${PermanentDir}/my.php"

# 在持久化存储中创建需要的目录
[ ! -d $PermanentDir/data ] && mkdir $PermanentDir/data
cp -a ${AppDir}/www/data/* ${PermanentDir}/data/
rm -rf ${AppDir}/www/data/
ln -s ${PermanentDir}/data ${AppDir}/www/data
[ ! -d $PermanentDir/ext ] && mkdir $PermanentDir/ext

for d in `ls ${AppDir}/module/`
do
if [ -d ${AppDir}/module/${d} ] ;then
  [ ! -d ${PermanentDir}/ext/${d} ] && mkdir $PermanentDir/ext/${d}
  [ -d ${AppDir}/module/${d}/ext ] && cp -a ${AppDir}/module/${d}/ext/* ${PermanentDir}/ext/${d}/

 rm -rf ${AppDir}/module/$d/ext
 ln -s $PermanentDir/ext/${d} ${AppDir}/module/${d}/ext
fi
done

[ ! -f $UserCfg ] && touch $UserCfg
[ -f ${AppDir}/config/my.php ] && rm ${AppDir}/config/my.php
ln -s $UserCfg ${AppDir}/config/my.php
chmod -R 777 ${PermanentDir}

php5-fpm

nginx -g 'daemon off;'
