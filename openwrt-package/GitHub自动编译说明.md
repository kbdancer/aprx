# GitHub Actions 自动编译 IPK 指南

## 📋 概述

本项目已配置 GitHub Actions 自动编译功能，可以自动为 MT7621 芯片编译 OpenWrt IPK 包。无需本地安装编译环境！

## 🚀 使用方法

### 方法 1: Fork 仓库并自动编译

1. **Fork 本仓库到你的 GitHub 账号**
   - 点击页面右上角的 "Fork" 按钮

2. **启用 GitHub Actions**
   - 进入你 Fork 的仓库
   - 点击 "Actions" 标签
   - 如果提示启用 workflows，点击 "I understand my workflows, go ahead and enable them"

3. **触发编译**
   
   有三种方式触发自动编译：

   **方式 A: 推送代码**
   ```bash
   git clone https://github.com/你的用户名/aprx.git
   cd aprx
   # 做一些修改
   git add .
   git commit -m "Update configuration"
   git push
   ```

   **方式 B: 创建 Release 标签**
   ```bash
   git tag v2.9.1
   git push origin v2.9.1
   ```
   这会自动创建 GitHub Release 并附带编译好的 IPK 文件

   **方式 C: 手动触发**
   - 进入 GitHub 仓库的 "Actions" 页面
   - 选择 "Build OpenWrt IPK for MT7621" workflow
   - 点击 "Run workflow" 按钮
   - 选择分支并点击绿色的 "Run workflow" 按钮

4. **等待编译完成**
   - 编译通常需要 10-20 分钟
   - 可以在 Actions 页面查看实时日志

5. **下载编译产物**
   
   **方式 A: 从 Actions 下载**
   - 打开完成的 workflow run
   - 在页面底部找到 "Artifacts" 部分
   - 下载 `aprx-openwrt-*.zip` 文件
   - 解压后得到 IPK 文件

   **方式 B: 从 Releases 下载 (如果是通过 tag 触发)**
   - 进入仓库的 "Releases" 页面
   - 下载最新的 release 中的 IPK 文件

## 📦 编译产物说明

每次成功编译会生成以下文件：

- `aprx_2.9-1_mipsel_24kc.ipk` - 主程序包
- `sha256sums.txt` - SHA256 校验和
- `md5sums.txt` - MD5 校验和

## ⚙️ 自动编译配置

### 触发条件

自动编译会在以下情况触发：

1. ✅ 推送到 `main` 或 `master` 分支
2. ✅ 创建新的 tag (v开头)
3. ✅ 提交 Pull Request
4. ✅ 手动触发 (workflow_dispatch)

### 编译环境

- **系统**: Ubuntu 22.04
- **OpenWrt 版本**: 24.10.4
- **目标平台**: ramips/mt7621
- **架构**: mipsel_24kc
- **编译时间**: 约 10-20 分钟

### 自定义配置

如果需要修改编译配置，编辑 `.github/workflows/build-openwrt-ipk.yml` 文件：

```yaml
env:
  OPENWRT_VERSION: 24.10.4  # 修改 OpenWrt 版本
  TARGET: ramips             # 修改目标平台
  SUBTARGET: mt7621          # 修改子平台
  ARCH: mipsel_24kc          # 修改架构
```

## 🔄 编译其他平台

想要为其他平台编译？修改 workflow 文件中的环境变量：

### MT7620 示例
```yaml
env:
  OPENWRT_VERSION: 24.10.4
  TARGET: ramips
  SUBTARGET: mt7620
  ARCH: mipsel_24kc
```

### AR71xx (老款 TP-Link 路由器) 示例
```yaml
env:
  OPENWRT_VERSION: 19.07.10  # 注意：新版本可能不支持 ar71xx
  TARGET: ar71xx
  SUBTARGET: generic
  ARCH: mips_24kc
```

### x86_64 示例
```yaml
env:
  OPENWRT_VERSION: 24.10.4
  TARGET: x86
  SUBTARGET: 64
  ARCH: x86_64
```

## 📊 查看编译状态

### 方法 1: GitHub Actions 页面
1. 进入仓库的 "Actions" 标签
2. 查看最近的 workflow runs
3. 点击查看详细日志

### 方法 2: Badges (徽章)

在你的 README.md 中添加状态徽章：

```markdown
![Build Status](https://github.com/你的用户名/aprx/actions/workflows/build-openwrt-ipk.yml/badge.svg)
```

效果：
![Build Status](https://github.com/你的用户名/aprx/actions/workflows/build-openwrt-ipk.yml/badge.svg)

## 🐛 常见问题

### 1. Actions 被禁用

**问题**: Fork 的仓库默认禁用 Actions

**解决**:
- 进入仓库的 Actions 页面
- 点击 "I understand my workflows, go ahead and enable them"

### 2. 编译失败

**问题**: 编译过程出错

**解决步骤**:
1. 查看 Actions 日志中的错误信息
2. 常见原因：
   - 网络问题导致 SDK 下载失败 → 重新运行 workflow
   - 代码语法错误 → 检查并修复代码
   - OpenWrt 版本不匹配 → 检查版本号是否正确

### 3. 找不到编译产物

**问题**: 编译成功但找不到 IPK 文件

**解决**:
1. 确保编译任务显示为绿色 ✅
2. 在 workflow run 页面底部查找 "Artifacts" 部分
3. Artifacts 保留 90 天，超期会自动删除

### 4. 磁盘空间不足

**问题**: 编译时提示磁盘空间不足

**解决**: workflow 已包含清理脚本，如果仍然不够，可以修改 workflow 添加更多清理步骤：

```yaml
- name: Free more disk space
  run: |
    sudo rm -rf /opt/hostedtoolcache
    sudo rm -rf /usr/local/lib/android
    sudo apt-get clean
    df -h
```

## 💡 高级用法

### 1. 编译多个平台

创建矩阵构建，同时为多个平台编译：

```yaml
jobs:
  build:
    strategy:
      matrix:
        include:
          - target: ramips
            subtarget: mt7621
            arch: mipsel_24kc
          - target: ramips
            subtarget: mt7620
            arch: mipsel_24kc
          - target: ath79
            subtarget: generic
            arch: mips_24kc
    
    name: Build for ${{ matrix.target }}/${{ matrix.subtarget }}
    # ... 其他配置
```

### 2. 定时自动编译

添加定时触发，每周自动编译一次：

```yaml
on:
  schedule:
    - cron: '0 0 * * 0'  # 每周日 UTC 时间 00:00
```

### 3. 编译后自动测试

在 workflow 中添加测试步骤：

```yaml
- name: Test package
  run: |
    # 提取并检查 IPK 内容
    ar x artifacts/aprx_*.ipk
    tar -tzf data.tar.gz
    # 验证文件完整性
```

## 📝 工作流程文件位置

- **主配置文件**: `.github/workflows/build-openwrt-ipk.yml`
- **包定义文件**: `openwrt-package/aprx/Makefile`
- **启动脚本**: `openwrt-package/aprx/files/aprx.init`

## 🔗 相关链接

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [OpenWrt SDK 下载](https://downloads.openwrt.org/releases/)
- [OpenWrt 包编译指南](https://openwrt.org/docs/guide-developer/packages)

## 📧 需要帮助？

如果遇到问题：
1. 查看 [GitHub Issues](https://github.com/PhirePhly/aprx/issues)
2. 在仓库中创建新的 Issue
3. 提供详细的错误日志和环境信息

---

**提示**: 使用 GitHub Actions 编译完全免费，每月有 2000 分钟的免费额度（公开仓库无限制）。
