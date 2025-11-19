# APRX OpenWrt 编译指南

本指南说明如何为 OpenWrt 24.10.4 (MT7621芯片) 编译 APRX 软件包。

## 前置要求

1. 已安装的 OpenWrt 24.10.4 SDK 或完整的 OpenWrt 构建系统
2. Linux 构建环境 (推荐 Ubuntu 20.04/22.04 或 Debian)
3. 必需的构建工具

## 准备 OpenWrt 构建环境

### 方法 1: 使用 OpenWrt SDK (推荐)

```bash
# 下载 OpenWrt 24.10.4 SDK for MT7621
wget https://downloads.openwrt.org/releases/24.10.4/targets/ramips/mt7621/openwrt-sdk-24.10.4-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64.tar.xz

# 解压 SDK
tar xf openwrt-sdk-24.10.4-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64.tar.xz
cd openwrt-sdk-24.10.4-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64

# 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a
```

### 方法 2: 从源码构建完整的 OpenWrt

```bash
# 克隆 OpenWrt 源码
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
git checkout v24.10.4

# 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 配置目标平台
make menuconfig
# 选择: Target System -> MediaTek Ralink MIPS
#      Subtarget -> MT7621 based boards
```

## 添加 APRX 软件包

```bash
# 复制 aprx 包到 OpenWrt 构建系统
cp -r /path/to/aprx/openwrt-package/aprx package/feeds/packages/aprx

# 或者如果使用 SDK
cp -r /path/to/aprx/openwrt-package/aprx package/aprx
```

## 编译软件包

### 使用 SDK 编译

```bash
# 更新包索引
make package/symlinks

# 编译 aprx
make package/aprx/compile V=s

# 编译完成后，IPK 文件位于:
# bin/packages/mipsel_24kc/packages/aprx_2.9-1_mipsel_24kc.ipk
```

### 使用完整构建系统编译

```bash
# 选择 aprx 包
make menuconfig
# 导航到: Network -> aprx
# 按 M 键选择编译为模块 (ipk)

# 编译
make package/aprx/compile V=s

# 或者编译整个系统
make -j$(nproc)
```

## 编译参数说明

- `V=s`: 显示详细编译输出，便于调试
- `V=99`: 显示更详细的输出
- `-j$(nproc)`: 使用所有 CPU 核心进行并行编译

## 常见问题解决

### 1. 缺少依赖

```bash
# Ubuntu/Debian 安装构建依赖
sudo apt-get update
sudo apt-get install -y build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python3 unzip wget python3-distutils \
python3-setuptools python3-dev rsync subversion swig time \
xsltproc zlib1g-dev
```

### 2. 编译错误

如果出现编译错误，可以清理并重新编译：

```bash
make package/aprx/clean
make package/aprx/compile V=s
```

### 3. 自定义编译选项

如果需要添加 OpenSSL 支持，编辑 `package/aprx/Makefile`:

```makefile
CONFIGURE_ARGS += \
	--with-embedded \
	--with-openssl \  # 启用 OpenSSL
	--with-pthread

# 并添加依赖
DEPENDS:=+libpthread +librt +libopenssl
```

## 安装到路由器

### 通过 SCP 传输

```bash
# 找到生成的 IPK 文件
find bin/ -name "aprx*.ipk"

# 传输到路由器
scp bin/packages/mipsel_24kc/packages/aprx_2.9-1_mipsel_24kc.ipk root@192.168.1.1:/tmp/
```

### 在路由器上安装

```bash
# SSH 登录路由器
ssh root@192.168.1.1

# 安装 IPK
opkg install /tmp/aprx_2.9-1_mipsel_24kc.ipk

# 编辑配置文件
vi /etc/aprx.conf

# 启动服务
/etc/init.d/aprx start

# 设置开机自启
/etc/init.d/aprx enable

# 查看运行状态
/etc/init.d/aprx status
ps | grep aprx
```

## 配置说明

配置文件位于 `/etc/aprx.conf`，需要根据你的实际情况进行配置：

1. 设置你的呼号 (mycall)
2. 配置 APRS-IS 服务器连接
3. 配置串口或网络接口
4. 配置信标和 iGate 参数

详细配置说明请参考：
- `/workspace/aprx.conf.in` - 简单配置示例
- `/workspace/aprx-complex.conf.in` - 复杂配置示例
- `/workspace/doc/aprx-manual.pdf` - 完整手册

## 验证安装

```bash
# 查看版本
aprx -?

# 检查配置文件
aprx -f /etc/aprx.conf -t

# 查看日志
logread | grep aprx
```

## 卸载

```bash
# 停止服务
/etc/init.d/aprx stop
/etc/init.d/aprx disable

# 卸载软件包
opkg remove aprx
```

## 技术支持

- 项目主页: https://github.com/PhirePhly/aprx/
- Google Group: http://groups.google.com/group/aprx-software
- OpenWrt 论坛: https://forum.openwrt.org/

## 许可证

APRX 使用 BSD-3-Clause 许可证，详见 LICENSE 文件。
