# ref:https://jihulab.com/Xm798/Yunzai-Bot-Docs/-/raw/master/scripts/install_v3.sh

#!/bin/bash

set -e
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;36m'
plain='\033[0m'

echo -e "${yellow}
===========================================================
    Description: Yunzai-bot v3 Docker 部署辅助脚本
    Author: @Xm798
    Github: https://github.com/Xm798/Yunzai-Bot-Docs
===========================================================${plain}
"

function install_plugin() {
    # $1 插件名称 $2 插件目录名 $3 插件仓库地址
    echo -e ${blue}
    read -e -r -p "是否安装 $1 ($2)? [Y/n] " input
    echo -e ${plain}
    case $input in
    [yY][eE][sS] | [yY])
        echo -e "安装位置：./yunzai/plugins/$2"
        sed -i -r "/plugins\/$2/s/^(\s+)(# )/\1/" docker-compose.yaml

        if [ ! -d ./yunzai/plugins/$2 ]; then
            set +e
            git clone $3 ./yunzai/plugins/$2
            if [ "$?" -ne "0" ]; then
                echo -e "${red}$1 安装失败！\n"
            else
                echo -e "${green}$1 安装成功！\n"
            fi
            set -e
        else
            echo -e "${red}$1 文件夹已存在！\n"
        fi
        ;;
    [nN][oO] | [nN])
        echo -e "${plain}跳过 $1 安装...\n"
        ;;
    *)
        echo -e "${plain}跳过 $1 安装...\n"
        ;;
    esac
}

echo -e "将在当前目录下创建 yunzai-bot 文件夹并在其中完成后续工作..."
echo -e ${blue}
read -e -r -p "是否继续? [Y/n]" input
echo -e ${plain}
case $input in
[yY][eE][sS] | [yY]) ;;

[nN][oO] | [nN])
    exit 0
    ;;
*)
    exit 0
    ;;
esac

YUNZAI_RAW_URL="https://gitee.com/TimeRainStarSky/Yunzai/raw/main"
YUNZAI_GENSHIN_PLUGIN_REPO="https://gitee.com/TimeRainStarSky/Yunzai-genshin"
MIAO_PLUGIN_REPO="https://gitee.com/yoimiya-kokomi/miao-plugin.git"
CVS_PLUGIN_REPO="https://gitee.com/Ctrlcvs/xiaoyao-cvs-plugin.git"

echo -e "${green}\n创建所需文件夹...${plain}"

[ -d yunzai-bot ] || mkdir yunzai-bot
cd yunzai-bot

folder_list="yunzai/logs yunzai/data yunzai/plugins/example yunzai/genshin_config
    yunzai/config redis/data redis/logs go-cq/"

for folder in $folder_list; do
    if [ ! -d $folder ]; then
        echo -e "  - 创建 $folder"
        mkdir -p $folder
    else
        echo -e "${red}  - $folder already exists."
    fi
done

echo -e "${green}\n下载配置文件...${plain}"
curl -sL ${YUNZAI_RAW_URL}/config/default_config/redis.yaml -o ./yunzai/config/redis.yaml
curl -sL ${YUNZAI_RAW_URL}/config/default_config/qq.yaml -o ./yunzai/config/qq.yaml
curl -sL ${YUNZAI_RAW_URL}/config/default_config/group.yaml -o ./yunzai/config/group.yaml
curl -sL ${YUNZAI_RAW_URL}/config/default_config/other.yaml -o ./yunzai/config/other.yaml

sed -i 's|127.0.0.1|redis|g' ./yunzai/config/redis.yaml

echo -e "${green}\n下载docker-compose文件...${plain}"
curl -sL https://gitee.com/Qieee/Yunzai-docker/raw/main/docker-compose.yaml -o ./docker-compose.yaml

install_plugin "喵喵插件" "miao-plugin" $MIAO_PLUGIN_REPO
install_plugin "图鉴插件" "xiaoyao-cvs-plugin" $CVS_PLUGIN_REPO
install_plugin "YUNZAI_GENGINE插件" "genshin" $YUNZAI_GENSHIN_PLUGIN_REPO

echo -e "${green}------------------------------
 已准备就绪，请使用 cd yunzai-bot 进入工作目录。
------------------------------${plain}
 请使用 ${yellow}docker-compose up -d${plain} 启动容器，
 使用 ${yellow}docker-compose logs -f --tail 100${plain} 查看日志。
 如需修改配置，请手动修改 ${yellow}./yunzai-bot/yunzai/config/${plain} 目录中的文件。
 使用go-cqhttp生成配置文件后再启动docker，参考https://github.com/Mrs4s/go-cqhttp
 使用 ${yellow}docker-compose -f go-cq --tail 100查看go-cqhttp${plain} 日志
------------------------------
${yellow} 更多帮助请参见： https://docs.yunzai.org/deploy/linux/Docker.html
"

echo -e "${green}------------------------------"
