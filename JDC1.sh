git clone -b ipq60xx-devel_nss --single-branch https://github.com/JiaY-shi/openwrt.git openwrt
[ -e files ] && mv files openwrt/files
cd openwrt

#sed -i '$a src-git other https://github.com/Lienol/openwrt-package.git;other' feeds.conf.default
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"

#sed -i '$a src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall.git' feeds.conf.default
#sed -i '$a src-git xiaorouji1 https://github.com/xiaorouji/openwrt-passwall.git;luci' feeds.conf.default
#sed -i '$a src-git-full x https://github.com/x-wrt/com.x-wrt.git' feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a

#添加自定义插件
#git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b js --single-branch https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design

rm -rf feeds/packages/net/chinadns-ng
cp -rf feeds/passwall_packages/chinadns-ng/ feeds/packages/net/
rm -rf feeds/luci/applications/luci-app-passwall/
cp -rf feeds/passwall/luci-app-passwall/ feeds/luci/applications

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

#rm -rf package/libs/ustream-ssl
#rm -rf feeds/packages/net/miniupnpd
#svn co https://github.com/x-wrt/x-wrt/trunk/package/libs/ustream-ssl package/ustream-ssl
#svn co https://github.com/x-wrt/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd
         
#修改lan口地址
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

#修改机器名称
sed -i 's/OpenWrt/JDCloud/g' package/base-files/files/bin/config_generate

#默认打开WiFi
sed -i 's/disabled=1/disabled=0/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

#修改时区
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#make V=s -j$(nproc)
