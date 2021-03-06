#!/bin/bash
path=/var/kns
durl="http://192.168.1.4/cnkixhs/Urlpaper.php?action=get"
uurl="http://192.168.1.4/cnkixhs/Upfile.php"
ckurls=`curl --connect-timeout 10 $durl 2>>$path/down.log`
if [ ! -n "$ckurls" ];then
        exit 28
fi
echo $ckurls | grep "error" >>/dev/null
if [ $? -eq 0 ];then
	echo "url error"
	exit 28
fi
for url in ${ckurls[@]}
#遍历下载地址集合 
do
#下载论文
fname=`echo ${url:0-9}`
url=`echo ${url%/*}`
wget -T 10  -t 2 -O $path/$fname $url >/dev/null 2>>$path/wget.log
if [ $? -ne 0 ];then
	echo "erro!find this log"
fi
#up file
curl --connect-timeout 10 -F "file=@$path/$fname" $uurl >/dev/null 2>>$path/up.log
if [ $? -eq 0 ];then
#上传成功删除本地文件
  rm -rf $path/$fname
fi
sleep 1
done
exit 0
