# 🚀 使用 GitHub Actions 一键编译 APRX

## 最简单的方法：完全在浏览器中操作！

不需要安装任何编译工具，不需要下载 SDK，GitHub 帮你全部搞定！

## 📝 步骤 1: Fork 仓库

1. 打开项目页面：https://github.com/你的仓库/aprx
2. 点击右上角的 **"Fork"** 按钮
3. 等待 Fork 完成（几秒钟）

## ✅ 步骤 2: 启用 Actions

1. 进入你 Fork 后的仓库
2. 点击顶部的 **"Actions"** 标签
3. 如果看到提示，点击 **"I understand my workflows, go ahead and enable them"**

## 🎯 步骤 3: 开始编译（三选一）

### 方法 A: 立即编译（推荐）

1. 在 **Actions** 页面
2. 左侧选择 **"Build OpenWrt IPK for MT7621"**
3. 右侧点击 **"Run workflow"** 下拉菜单
4. 点击绿色的 **"Run workflow"** 按钮
5. ✨ 编译开始！

### 方法 B: 修改配置后自动编译

1. 在仓库页面点击 `openwrt-package/aprx/files/aprx.conf.example`
2. 点击铅笔图标 ✏️ 编辑
3. 修改配置（比如改个注释）
4. 页面底部点击 **"Commit changes"**
5. ✨ 编译自动开始！

### 方法 C: 创建 Release 标签

1. 在仓库页面右侧点击 **"Releases"**
2. 点击 **"Create a new release"**
3. 点击 **"Choose a tag"**，输入 `v2.9.1`
4. 点击 **"Create new tag"**
5. 填写 Release 标题和说明
6. 点击 **"Publish release"**
7. ✨ 编译开始，完成后自动发布到 Release！

## ⏱️ 步骤 4: 等待编译（10-20分钟）

1. 在 **Actions** 页面查看进度
2. 点击正在运行的任务查看实时日志
3. 看到绿色 ✅ 表示编译成功
4. 看到红色 ❌ 表示失败（点击查看日志排查）

## 📦 步骤 5: 下载 IPK 文件

### 从 Actions 下载：

1. 打开完成的 workflow（绿色 ✅ 的那个）
2. 滚动到页面底部 **"Artifacts"** 部分
3. 点击下载（文件名类似 `aprx-openwrt-24.10.4-mipsel_24kc-2.9-20251119-abc1234.zip`）
4. 解压 ZIP 文件得到 IPK

### 从 Releases 下载（如果是通过标签触发）：

1. 点击仓库的 **"Releases"** 标签
2. 找到最新的 Release
3. 在 **"Assets"** 下直接下载 IPK 文件

## 📥 步骤 6: 安装到路由器

```bash
# 1. 传输到路由器
scp aprx_2.9-1_mipsel_24kc.ipk root@192.168.1.1:/tmp/

# 2. SSH 登录路由器
ssh root@192.168.1.1

# 3. 安装
opkg install /tmp/aprx_2.9-1_mipsel_24kc.ipk

# 4. 编辑配置（改成你的呼号和位置）
vi /etc/aprx.conf

# 5. 启动
/etc/init.d/aprx start
/etc/init.d/aprx enable
```

## 🎉 完成！

你的 APRX iGate 已经运行了！

## 📊 查看状态

```bash
# 查看服务状态
/etc/init.d/aprx status

# 查看日志
logread | grep aprx

# 查看统计
aprx-stat
```

## 🔄 需要重新编译？

只需要：
1. 进入你 Fork 的仓库
2. Actions → Build OpenWrt IPK for MT7621
3. Run workflow
4. 等待完成后下载新的 IPK

## 💡 提示

- ✅ 编译完全在 GitHub 服务器上进行，不占用你的电脑资源
- ✅ 公开仓库使用 GitHub Actions 完全免费
- ✅ 编译产物保留 90 天
- ✅ 可以随时重新编译
- ✅ 每次推送代码都会自动编译

## 🆘 遇到问题？

### Actions 被禁用
→ 进入 Actions 页面，点击启用按钮

### 编译失败
→ 点击失败的任务查看日志，通常是网络问题，重新运行即可

### 找不到下载文件
→ 确保任务显示绿色 ✅，在页面底部找 Artifacts

### 想编译其他平台
→ 查看 [GitHub自动编译说明.md](./GitHub自动编译说明.md) 的详细配置

---

**超简单对吧？** 🎈

不需要 Linux、不需要 SDK、不需要等待下载，浏览器点几下就能编译！
