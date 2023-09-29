#!/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================
#克隆源码
git clone -b main --single-branch https://github.com/openwrt/openwrt
#svn co https://github.com/Lienol/openwrt/trunk/tools/ucl openwrt/tools/ucl
#svn co https://github.com/Lienol/openwrt/trunk/tools/upx openwrt/tools/upx
#sed -i 'N;28 a tools-y += ucl upx' openwrt/tools/Makefile
#sed -i 'N;42 a $(curdir)/upx/compile := $(curdir)/ucl/compile' openwrt/tools/Makefile

[ -e files ] && mv files openwrt/files
cd openwrt
#添加passwall
sed -i '$a src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall.git' feeds.conf.default
sed -i '$a src-git xiaorouji1 https://github.com/xiaorouji/openwrt-passwall.git;luci' feeds.conf.default
sed -i '$a src-git-full x https://github.com/x-wrt/com.x-wrt.git' feeds.conf.default
./scripts/feeds clean
./scripts/feeds update -a
./scripts/feeds install -a

cp /usr/bin/upx staging_dir/host/bin
cp /usr/bin/upx-ucl staging_dir/host/bin
rm -rf package/libs/ustream-ssl
rm -rf feeds/packages/net/miniupnpd
svn co https://github.com/x-wrt/x-wrt/trunk/package/libs/ustream-ssl package/ustream-ssl
svn co https://github.com/x-wrt/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd

#wget -P target/linux/generic/hack-5.15 https://raw.githubusercontent.com/x-wrt/x-wrt/master/target/linux/generic/hack-5.15/999-natcap-patch-kernel-for-cone-nat-support.patch
#wget -P target/linux/generic/hack-5.15 https://raw.githubusercontent.com/x-wrt/x-wrt/master/target/linux/generic/hack-5.15/960-net-core-__netif_receive_skb_core-handle-INGRESS-bef.patch

#wget -q -O - https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz | tar -Jx --strip 1 -f - -C staging_dir/host/bin upx-3.96-amd64_linux/upx
#添加自定义插件
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-fileassistant package/luci-app-fileassistan
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-cpufreq package/luci-app-cpufreq
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-netdata package/luci-app-netdata
git clone https://github.com/ssuperh/luci-app-vlmcsd-new.git package/luci-app-vlmcsd-new
git clone https://github.com/flytosky-f/openwrt-vlmcsd.git package/openwrt-vlmcsd
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon-2.2.9
#svn checkout https://github.com/Hyy2001X/AutoBuild-Packages/trunk/luci-app-webd package/luci-app-webd
#svn checkout https://github.com/Hyy2001X/AutoBuild-Packages/trunk/webd package/webd
#git clone https://github.com/small-5/luci-app-adblock-plus.git package/luci-app-adblock-plus
git clone https://github.com/ntlf9t/luci-app-easymesh package/luci-app-easymesh
git clone https://github.com/KFERMercer/luci-app-tcpdump.git package/luci-app-tcpdump
git clone https://github.com/dazhaolear/luci-app-autorebootnew.git package/luci-app-autorebootnew
#修改Samba4d的位置
sed -i "/exit 0/i\sed -i 's/services/nas/g' /usr/lib/lua/luci/controller/samba4.lua" package/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\sed -i 's/services/nas/g' /usr/share/luci/menu.d/luci-app-samba4.json" package/default-settings/files/zzz-default-settings
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/luci-app-ksmbd.json
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json

#修改lan口地址
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

#修改机器名称
sed -i 's/OpenWrt/Google/g' package/base-files/files/bin/config_generate

#修改wifi名称
sed -i 's/OpenWrt/Google-WiFi/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#默认打开WiFi
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#修改时区
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate



#mv -f ../Google-Wifi/Google.config .config
mv -f ../Google-Wifi/google_op.config .config
