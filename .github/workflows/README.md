# GitHub Actions Workflows

本目录包含自动化编译的 workflow 配置。

## 可用的 Workflows

### build-openwrt-ipk.yml
自动编译 APRX 为 OpenWrt IPK 包

**触发条件:**
- Push 到 main/master 分支
- 创建新的 tag
- Pull Request
- 手动触发

**编译平台:**
- OpenWrt 24.10.4
- MT7621 (mipsel_24kc)

**产物:**
- aprx_*.ipk
- sha256sums.txt
- md5sums.txt

详细使用说明请查看: [GitHub自动编译说明.md](../openwrt-package/GitHub自动编译说明.md)
