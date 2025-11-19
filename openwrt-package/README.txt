===============================================
  APRX for OpenWrt 24.10.4 (MT7621) 编译包
===============================================

本目录包含了为 MT7621 芯片的 OpenWrt 24.10.4 编译 APRX 所需的所有文件。

📁 目录结构
===============================================
openwrt-package/
├── aprx/                    # OpenWrt 包目录
│   ├── Makefile            # OpenWrt 编译配置
│   └── files/              # 安装文件
│       ├── aprx.init       # 启动脚本
│       └── aprx.conf.example  # 配置示例
├── build-ipk.sh            # 一键编译脚本 (推荐)
├── README-zh_CN.md         # 详细编译文档
├── 快速开始.md             # 快速入门指南
└── README.txt              # 本文件

🚀 快速编译
===============================================
最简单的方法：

cd /workspace/openwrt-package
./build-ipk.sh

脚本会自动完成所有编译步骤，无需手动配置。

📦 输出文件
===============================================
编译成功后会生成：
- aprx_2.9-1_mipsel_24kc.ipk

文件路径：
openwrt-sdk-*/bin/packages/mipsel_24kc/packages/

📖 文档说明
===============================================
- 快速开始.md        - 推荐首先阅读，包含快速安装指南
- README-zh_CN.md    - 完整的编译和配置文档
- aprx/files/aprx.conf.example - 详细的配置文件示例

💻 系统要求
===============================================
编译环境：
- Ubuntu 20.04/22.04 或 Debian 11/12
- 至少 4GB 内存
- 至少 10GB 磁盘空间
- 稳定的网络连接（需要下载 SDK）

目标设备：
- MT7621 芯片的路由器
- OpenWrt 24.10.4 固件
- 至少 16MB 闪存

⚡ 三步安装
===============================================
1. 编译 IPK：
   ./build-ipk.sh

2. 传输到路由器：
   scp aprx_*.ipk root@192.168.1.1:/tmp/

3. 安装并配置：
   ssh root@192.168.1.1
   opkg install /tmp/aprx_*.ipk
   vi /etc/aprx.conf
   /etc/init.d/aprx start

🔧 关键配置
===============================================
最少需要修改的配置项：

1. mycall - 你的呼号
2. myloc - 你的位置
3. aprsis login - APRS-IS 登录呼号
4. aprsis passcode - APRS-IS 密码
5. interface - 你的 TNC 接口配置

详细说明请查看配置示例文件。

📡 支持的硬件
===============================================
✓ 串口 KISS TNC (USB 转串口)
✓ 网络 KISS TNC (TCP)
✓ AX.25 网络设备
✓ D-STAR D-PRS

🆘 获取帮助
===============================================
- 查看文档：cat 快速开始.md
- 官方网站：https://github.com/PhirePhly/aprx
- Google Group：http://groups.google.com/group/aprx-software

📝 版本信息
===============================================
APRX 版本：2.9
OpenWrt 版本：24.10.4
目标平台：MT7621 (mipsel_24kc)
编译日期：2025-11-19

开始使用：./build-ipk.sh
===============================================
