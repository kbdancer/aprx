# APRX for OpenWrt - MT7621

[![Build OpenWrt IPK](https://github.com/你的用户名/aprx/actions/workflows/build-openwrt-ipk.yml/badge.svg)](https://github.com/你的用户名/aprx/actions/workflows/build-openwrt-ipk.yml)

APRX 是一个多功能的 APRS iGate/Digipeater 软件，本项目提供了为 OpenWrt 24.10.4 (MT7621) 编译 IPK 包的完整解决方案。

## 🚀 三种编译方法

### 方法 1: GitHub Actions 自动编译（推荐）⭐

**最简单！不需要安装任何工具！**

1. Fork 本仓库
2. 启用 Actions
3. 点击 "Run workflow"
4. 下载编译好的 IPK

[📖 查看详细教程](openwrt-package/快速开始-GitHub版.md)

### 方法 2: 本地一键脚本

```bash
cd openwrt-package
./build-ipk.sh
```

[📖 查看详细教程](openwrt-package/快速开始.md)

### 方法 3: 手动编译

[📖 查看详细教程](openwrt-package/README-zh_CN.md)

## 📚 完整文档

| 文档 | 说明 |
|------|------|
| [编译说明-完整版.md](编译说明-完整版.md) | 三种编译方法对比和选择指南 |
| [快速开始-GitHub版.md](openwrt-package/快速开始-GitHub版.md) | GitHub Actions 图文教程 |
| [GitHub自动编译说明.md](openwrt-package/GitHub自动编译说明.md) | GitHub Actions 高级配置 |
| [快速开始.md](openwrt-package/快速开始.md) | 本地编译快速指南 |
| [README-zh_CN.md](openwrt-package/README-zh_CN.md) | 详细编译文档 |
| [配置示例](openwrt-package/aprx/files/aprx.conf.example) | 配置文件模板 |

## 📦 文件结构

```
aprx/
├── .github/workflows/          # GitHub Actions 自动编译配置
│   └── build-openwrt-ipk.yml  # 主 workflow 文件
├── openwrt-package/            # OpenWrt 包定义
│   ├── aprx/                  # 包源文件
│   │   ├── Makefile          # 编译配置
│   │   └── files/            # 安装文件
│   ├── build-ipk.sh          # 一键编译脚本
│   └── [文档...]
└── [APRX 源代码...]
```

## ✨ 功能特性

- ✅ RX-iGate (接收并转发到 APRS-IS)
- ✅ TX-iGate (从 APRS-IS 转发到无线电)
- ✅ 数字中继器 (Digipeater)
- ✅ 粘性数字中继器 (Viscous Digipeater)
- ✅ KISS TNC 支持
- ✅ 多串口/多 TNC 支持
- ✅ D-STAR D-PRS 支持
- ✅ 流量统计 (Erlang Monitor)

## 🎯 支持的硬件

- **默认**: MT7621 (mipsel_24kc)
- **可配置**: MT7620, AR71xx, x86_64 等其他 OpenWrt 平台

## 📥 安装使用

```bash
# 1. 传输到路由器
scp aprx_*.ipk root@192.168.1.1:/tmp/

# 2. SSH 登录并安装
ssh root@192.168.1.1
opkg install /tmp/aprx_*.ipk

# 3. 编辑配置
vi /etc/aprx.conf

# 4. 启动服务
/etc/init.d/aprx start
/etc/init.d/aprx enable
```

## ⚙️ 基本配置

编辑 `/etc/aprx.conf`：

```conf
mycall  BG1ABC-10              # 你的呼号
myloc   lat 3950.00N lon 11620.00E  # 你的位置

<aprsis>
    login    BG1ABC-10         # 登录呼号
    passcode 12345             # APRS-IS 密码
    server   asia.aprs2.net 14580
</aprsis>
```

获取密码: https://apps.magicbug.co.uk/passcode/

## 🔗 相关链接

- [APRX 项目主页](https://github.com/PhirePhly/aprx)
- [APRS.fi 地图](https://aprs.fi/)
- [OpenWrt 官网](https://openwrt.org/)

## 📝 许可证

BSD-3-Clause License

## 🆘 获取帮助

- [GitHub Issues](https://github.com/PhirePhly/aprx/issues)
- [APRX Google Group](http://groups.google.com/group/aprx-software)

---

**推荐**: 使用 [GitHub Actions 自动编译](openwrt-package/快速开始-GitHub版.md)，最简单快捷！
