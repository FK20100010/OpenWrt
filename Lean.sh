#!/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================
#克隆源码
git clone https://github.com/VIKINGYFY/immortalwrt.git VIKINGYFY
git clone -b openwrt-24.10 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt.git
[ -e files ] && mv files immortalwrt/files
cd immortalwrt
#添加passwall
sed -i '/^#/d' feeds.conf.default
echo "src-git nss_packages https://github.com/qosmio/nss-packages.git" >> "feeds.conf.default"
echo "src-git sqm_scripts_nss https://github.com/qosmio/sqm-scripts-nss.git" >> "feeds.conf.default"

echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo.git;v1.10.0" >> "feeds.conf.default"

./scripts/feeds clean
./scripts/feeds update -a
./scripts/feeds install -a
rm -rf target && cp -rf ../VIKINGYFY/target .
touch target/linux/*/Makefile

#添加自定义插件
#添加自定义插件
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b js --single-branch https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design
# 添加 clouddrive2 插件
git clone https://github.com/kiddin9/openwrt-clouddrive2.git package/openwrt-clouddrive2



#修改wifi名称
sed -i 's/OpenWrt/FK20100010/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#打开WiFi
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#修改时区
#sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#添加usbwan(把txt文件的内容添加到zzz-default-settings文件)
#sed -i -e '/exit 0/{h;s/.*/cat ../G-DOCK/add-usbwan/e;G}' package/lean/default-settings/files/zzz-default-settings或
#sed  -i -e '/exit 0/r ../G-DOCK/add-usbwan' -e 'x;$G' package/lean/default-settings/files/zzz-default-settings

#修改zzz-default-settings的配置
#sed -i 's/samba/samba4/g' package/lean/default-settings/files/zzz-default-settings
#sed -i '/exit 0/i\chmod 755 /etc/init.d/serverchan' package/lean/default-settings/files/zzz-default-settings	
#sed -i '/exit 0/i\chmod 755 /usr/bin/serverchan/serverchan' package/lean/default-settings/files/zzz-default-settings	
#sed -i '/exit 0/i\echo 0xDEADBEEF > /etc/config/google_fu_mode\n' package/lean/default-settings/files/zzz-default-settings

#mv -f ../G-DOCK/lean.default .config
#mv -f ../G-DOCK/lean*.config .config
mv -f ../G-DOCK/jdcloud_re-ss-01.config .config
