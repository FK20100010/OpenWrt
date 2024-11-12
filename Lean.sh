#!/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================
#克隆源码
git clone https://github.com/coolsnowwolf/lede openwrt
[ -e files ] && mv files openwrt/files
cd openwrt
#添加passwall
sed -i '$a src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall.git' feeds.conf.default
./scripts/feeds clean
./scripts/feeds update -a
./scripts/feeds install -a

#添加自定义插件
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-fileassistant package/luci-app-fileassistan
git clone https://github.com/small-5/luci-app-adblock-plus.git package/luci-app-adblock-plus
git clone https://github.com/ntlf9t/luci-app-easymesh package/luci-app-easymesh
git clone https://github.com/KFERMercer/luci-app-tcpdump.git package/luci-app-tcpdump

#添加主题
git clone https://github.com/thinktip/luci-theme-neobird.git  
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge package/luci-theme-edge
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon-1.7.2
#rm -rf package/luci-theme-argon-1.5.1/htdocs/luci-static/argon/head-icon.jpg
#rm -rf package/luci-theme-argon1.5/htdocs/luci-static/argon/img/
#cp -rf package/luci-theme-argon-1.x/htdocs/luci-static/argon/head-icon.jpg package/luci-theme-argon-1.5.1/htdocs/luci-static/argon/
#sed -i '/class="darkMask"/a \ \ \ <div class="login-bg" style="background-color: #5e72e4"></div>' package/luci-theme-argon-1.5.1/luasrc/view/themes/argon/header.htm
#sed -i '/background-image/d' package/luci-theme-argon-1.5.1/luasrc/view/themes/argon/header.htm

##添加openwrt-usb-modeswitch-official
#git clone https://github.com/gzhechu/openwrt-usb-modeswitch-official.git package/openwrt-usb-modeswitch-official
#sed -i 's/2.2.0/2.6.0/g' package/openwrt-usb-modeswitch-official/Makefile
#sed -i 's/f323fe700edd6ea404c40934ddf32b22/be73dcc84025794081a1d4d4e5a75e4c/g' package/openwrt-usb-modeswitch-official/Makefile
#sed -i 's/20140529/20191128/g' package/openwrt-usb-modeswitch-official/Makefile
#sed -i 's/dff94177781298aaf0b3c2a3c3dea6b2/e8fce7eb949cbe16c61fb71bade4cc17/g' package/openwrt-usb-modeswitch-official/Makefile
##添加ZTE-MF832S网卡
#cp -rf ../ZTE-MF832S/* files/etc/
##添加4G网卡网络接口
#sed -i '/exit 0/i\uci set network.4G_LTE=interface' package/lean/default-settings/files/zzz-default-settings
#sed -i '/exit 0/i\uci set network.4G_LTE.ifname=eth1' package/lean/default-settings/files/zzz-default-settings
#sed -i '/exit 0/i\uci set network.4G_LTE.proto=dhcp' package/lean/default-settings/files/zzz-default-settings
#sed -i '/exit 0/i\uci commit network' package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i 's/wan wan6/wan wan6 4G_LTE/g' /etc/config/firewall\n" package/lean/default-settings/files/zzz-default-settings

#修改lan口地址
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

#修改机器名称
sed -i 's/OpenWrt/G-DOCK/g' package/base-files/files/bin/config_generate

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
#添加简易网盘
sed -i '/exit 0/i\mkdir -pv /srv/webd/web/.Trash' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\ln -sv /mnt/sda1 /srv/webd/web/U盘' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\ln -sv /mnt/mmcblk0p1/all /srv/webd/web/SD卡' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\chmod 775 /usr/bin/webd\n' package/lean/default-settings/files/zzz-default-settings

#修改banner
rm -rf package/base-files/files/etc/banner
cp -rf ../banner package/base-files/files/etc/
#mv -f ../G-DOCK/lean.default .config
#mv -f ../G-DOCK/lean*.config .config
mv -f ../G-DOCK/xiaomi_mi-router-4c.config .config
