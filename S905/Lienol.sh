#!/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================
git clone -b main --single-branch https://github.com/Lienol/openwrt openwrt
#添加passwall
sed -i '$a src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall.git' openwrt/feeds.conf.default

cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
#移除不用软件包
rm -rf package/lean/luci-app-dockerman
rm -rf package/lean/luci-app-wrtbwmon
rm -rf feeds/packages/net/smartdns

#add luci-app-dockerman
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman
#添加argon主题
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge package/luci-theme-edge
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon-1.7.2
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#添加简易网盘
[ -e ../S905/files ] && mv ../S905/files openwrt/files
sed -i '/exit 0/i\mkdir -pv /srv/webd/web/.Trash' package/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\chmod 775 /usr/bin/webd\n' package/default-settings/files/zzz-default-settings

#添加自定义插件
rm -rf package/lean/luci-app-turboacc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-turboacc package/lean/luci-app-turboacc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dnsforwarder package/lean/dnsforwarder
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean//shortcut-fe/simulated-driver package/lean//shortcut-fe/simulated-driver

git clone https://github.com/small-5/luci-app-adblock-plus.git package/luci-app-adblock-plus

svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

[ -e ../S905/s905-Lienol.config ] && mv -f ../S905/s905-Lienol.config .config

