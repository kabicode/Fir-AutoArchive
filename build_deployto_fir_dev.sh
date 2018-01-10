#####################  如何使用  #####################

#配置好下面的配置信息
#把此文件复制到项目
#cd到项目，把此文件拖到命令行执行。

####################  2016年12月20日  #####################

#项目配置
####################
##配置项目名称
PROJECT_NAME=TDQianxiaoer

#配置项目工作空间名称
PROJECT_WORKSPACE_NAME=TDQianxiaoer

#配置项目Target名称
PROJECT_SCHEME_NAME=TDQianxiaoerDev

#配置的plist  - ipa.list
CONFIG_NAME="IPA"

# 配置Fir Token
token="624f2566bbf4584ed011a56ef80fd303"

# 配置Fir appID
firAppID="59b7475cca87a85e200001b5"

#项目路径(不需要配置)
PROJECT_PATH=$(pwd)

#build time (不需要配置)
BUILD_TIME=$(date +%Y%m%d%H%M)

#project temp path (可选配置)
PROJECT_TEMP_PATH=${PROJECT_PATH}_TEMP

#archive path   (可选配置)
ARCHIVE_PATH=${PROJECT_PATH}/build/release/${PROJECT_NAME}_r${BUILD_TIME}

#export path    (可选配置)
EXPORT_PATH=${ARCHIVE_PATH}.ipa

#upload path ipa
UPLOAD_PATH_IPA=${EXPORT_PATH}/${PROJECT_SCHEME_NAME}.ipa

#sdk version
SDK_VERSION=iphoneos


#辅助一份项目，当前项目可以继续编码
echo "copy project files to temp path."
cp -r -f ${PROJECT_PATH} ${PROJECT_TEMP_PATH}
cd ${PROJECT_TEMP_PATH}



echo "Clean 操作"

#没有xcworkspace的项目使用它
#xcodebuild -project ${PROJECT_WORKSPACE_NAME} -scheme ${PROJECT_SCHEME_NAME} clean

xcodebuild -workspace ${PROJECT_WORKSPACE_NAME}.xcworkspace -scheme ${PROJECT_SCHEME_NAME} clean

#xctool -workspace ${PROJECT_WORKSPACE_NAME}.xcworkspace -scheme ${PROJECT_SCHEME_NAME} clean

#归档    -configuration Debug 分发测试
echo "archive project."

xcodebuild -workspace ${PROJECT_WORKSPACE_NAME}.xcworkspace -scheme ${PROJECT_SCHEME_NAME} -configuration Debug build archive -archivePath ${ARCHIVE_PATH}

#xctool -workspace ${PROJECT_WORKSPACE_NAME}.xcworkspace -scheme ${PROJECT_SCHEME_NAME} build archive -archivePath ${ARCHIVE_PATH}

#删除拷贝的项目
echo "delete project temp path."
cd ${PROJECT_PATH}
rm -r -f ${PROJECT_TEMP_PATH}


#打包ipa
echo "export ipa file to export path."
xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH}.xcarchive -exportPath ${EXPORT_PATH} -exportOptionsPlist $(pwd)/${CONFIG_NAME}.plist
#

export LANG=en_US
export LC_ALL=en_US;
echo "正在上传到fir.im...."
fir l $token
fir p "$UPLOAD_PATH_IPA"
changelog=``
curl -X PUT --data "changelog=$changelog" http://fir.im/api/v2/app/$firAppID?token=$token
echo "\n打包上传更新成功！"
clear

