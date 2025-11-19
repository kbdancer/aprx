#!/bin/bash
#
# APRX OpenWrt IPK 快速编译脚本
# 适用于 OpenWrt 24.10.4 - MT7621
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENWRT_SDK_URL="https://downloads.openwrt.org/releases/24.10.4/targets/ramips/mt7621/openwrt-sdk-24.10.4-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64.tar.xz"
SDK_FILENAME="openwrt-sdk-24.10.4-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64.tar.xz"
SDK_DIR="openwrt-sdk-24.10.4-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64"

echo "========================================"
echo "APRX OpenWrt IPK 编译脚本"
echo "目标平台: MT7621 (mipsel_24kc)"
echo "OpenWrt 版本: 24.10.4"
echo "========================================"
echo ""

# 检查是否已经在 OpenWrt SDK 目录中
if [ -f "rules.mk" ] && [ -d "package" ]; then
    echo "✓ 检测到 OpenWrt SDK 环境"
    SDK_ROOT="$(pwd)"
else
    # 检查是否需要下载 SDK
    if [ ! -d "$SDK_DIR" ]; then
        echo "步骤 1: 下载 OpenWrt SDK..."
        if [ ! -f "$SDK_FILENAME" ]; then
            echo "正在下载 SDK (约 200MB)..."
            wget "$OPENWRT_SDK_URL" -O "$SDK_FILENAME"
        else
            echo "✓ SDK 压缩包已存在"
        fi
        
        echo "步骤 2: 解压 SDK..."
        tar xf "$SDK_FILENAME"
    else
        echo "✓ SDK 目录已存在"
    fi
    
    SDK_ROOT="$PWD/$SDK_DIR"
fi

echo ""
echo "步骤 3: 复制 APRX 包到 SDK..."
rm -rf "$SDK_ROOT/package/aprx"
cp -r "$SCRIPT_DIR/aprx" "$SDK_ROOT/package/"
echo "✓ 包已复制"

echo ""
echo "步骤 4: 更新 feeds..."
cd "$SDK_ROOT"
./scripts/feeds update -a
./scripts/feeds install -a

echo ""
echo "步骤 5: 编译 APRX..."
make package/aprx/clean
make package/aprx/compile V=s -j$(nproc)

echo ""
echo "========================================"
echo "编译完成!"
echo "========================================"
echo ""

# 查找生成的 IPK 文件
IPK_FILE=$(find "$SDK_ROOT/bin/packages" -name "aprx*.ipk" 2>/dev/null | head -n 1)

if [ -n "$IPK_FILE" ]; then
    IPK_SIZE=$(du -h "$IPK_FILE" | cut -f1)
    echo "✓ IPK 文件已生成:"
    echo "  位置: $IPK_FILE"
    echo "  大小: $IPK_SIZE"
    echo ""
    echo "安装方法:"
    echo "  1. 传输到路由器: scp $IPK_FILE root@192.168.1.1:/tmp/"
    echo "  2. SSH 登录路由器: ssh root@192.168.1.1"
    echo "  3. 安装: opkg install /tmp/$(basename $IPK_FILE)"
    echo ""
else
    echo "✗ 错误: 未找到 IPK 文件"
    echo "请检查编译输出中的错误信息"
    exit 1
fi
