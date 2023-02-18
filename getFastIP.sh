#!/bin/bash

#当前目录
CRTDIR=$(pwd)

#工作目录
WORK="/getFastIP"

if [ ! -d "getFastIP" ];then
 mkdir $WORK 
else
 echo "getFastIP 工作目录已经存在，如果不能正常工作请删除后重新运行脚本"
fi

cd $CRTDIR$WORK


#cloudflare 反代IP物理目录
ipScannerCloudflare=$CRTDIR$WORK'/cloudflare/'


# CloudflareSTPath 工作目录
CloudflareSTPath=$CRTDIR$WORK'/CloudflareSTPath'

echo $ipScannerCloudflare

if [ ! -d $ipScannerCloudflare ];then 
	git clone https://github.com/ip-scanner/cloudflare.git 
else 
	cd $ipScannerCloudflare

	echo "git 强制更新"
	
	git reset --hard origin/master
	
	echo "github项目 ip-scanner/cloudflare 文件夹已经存在"

	echo "开始从 https://github.com/ip-scanner/cloudflare.git 更新最新的反代IP"

	git pull

fi


if [ ! -d $CloudflareSTPath ];then 
	mkdir $CloudflareSTPath

	cd $CloudflareSTPath
	
	wget "https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.2.2/CloudflareST_darwin_amd64.zip"

	unzip CloudflareST_darwin_amd64.zip

	chmod +x CloudflareST


else 
	echo "CloudflareSTPath 存在！"

fi


cd $ipScannerCloudflare


echo "删除缓存: all.txt"
rm -rf all.txt

echo "重新生成 *.txt > all.txt"

cat *.txt > all.txt

echo '移动 all.txt'
mv all.txt $CloudflareSTPath

cd $CloudflareSTPath

echo '开始优选IP'
./CloudflareST -n 500 -dn 50 -tl 150 -tll 40 -t 1 -sl 10 -f all.txt
