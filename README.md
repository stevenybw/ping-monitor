# ping-monitor

`ping-monitor` 是一个轻量级的网络稳定性监控工具，用于持续 `ping` 多个目标主机，并将响应状态与延迟信息记录到日志文件中。它作为一个 `systemd` 服务后台运行，适用于诊断网络中断、丢包或高延迟问题，特别适合家庭或轻量服务器场景。

> 🖥️ **注意：本工具假定运行在 WSL 2 环境中的 Ubuntu 系统内**，并通过调用宿主机的 PowerShell 命令来获取无线网络的 SSID。因此该工具在原生 Linux 上不适用，或需要额外适配。

---

## ✨ 功能特点

- 持续监控多个目标（如 8.8.8.8、1.1.1.1、google.com、baidu.com）
- 记录每次 `ping` 的成功/失败状态和延迟值（ms）
- 日志带时间戳、网络接口名、IP 地址和（如有）Wi-Fi SSID
- `systemd` 后台服务自动启动、守护
- 支持 `.deb` 安装包一键部署

---

## 📦 安装方式（使用 `.deb` 包）

1. 克隆仓库或下载 release 包：

```bash
git clone https://github.com/yourname/ping-monitor.git
cd ping-monitor
```

2. 构建 `.deb` 包：

```bash
make
```

构建完成后会生成文件：
```
ping-monitor_1.0_all.deb
```

3. 安装：

```bash
sudo dpkg -i ping-monitor_1.0_all.deb
```

4. 此时服务已经自动启动，通过以下方式查看：

```bash
sudo systemctl status ping-monitor.service
```

5. 通过以下方式可以实时查看日志

```bash
tail -f /var/log/ping-monitor/ping.log
```

---

## ⚙️ 默认配置

### 监控目标主机列表

脚本中默认的目标主机为：

```bash
HOSTS=("8.8.8.8" "1.1.1.1" "google.com" "baidu.com")
```

你可以根据需要修改安装路径中的脚本文件：

```bash
sudo nano /usr/local/bin/ping-monitor.sh
```

---

## 📁 文件结构

```
ping-monitor/
├── debian/
│   ├── control            # DEB 包元信息
│   ├── postinst           # 安装后自动启动服务
├── etc/
│   └── systemd/
│       └── system/
│           └── ping-monitor.service
├── usr/
│   └── local/
│       └── bin/
│           └── ping-monitor.sh
├── Makefile
├── README.md
```

---

## 🧼 卸载方式

```bash
sudo apt remove ping-monitor
```

---

## ⚠️ WSL 兼容说明

- 本工具依赖以下 PowerShell 命令从宿主机获取网络信息：

```powershell
netsh wlan show interfaces
```

- 若你在非 WSL 环境或非 Windows 主机使用本工具，请根据系统环境自行调整脚本中相关命令。

---

## 📜 开源许可证

本项目采用 [MIT License](LICENSE)。

---

## 🙋‍♂️ 贡献 & 问题反馈

欢迎 issue 或 PR！如果你对某些功能有建议，比如：

- 支持 Web UI 查看日志
- 日志自动轮转
- 支持 ICMP 之外的探测协议（如 HTTP/S）

请在 GitHub 提出 🙌
