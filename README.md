# FuckVim: 开箱即用的Neovim整合包

<p align="center">
  <img src="screenshots/fuckvim-logo.png" alt="FuckVim Logo" width="500">
</p>

<div align="center">
  <strong>专为中文C/C++开发者打造，按下空格键立即展示中文快捷键帮助</strong>
</div>

<div align="center">
  <h4>
    <a href="#特色功能">特色功能</a> |
    <a href="#安装指南">安装指南</a> |
    <a href="#使用方法">使用方法</a> |
    <a href="#快捷键">快捷键</a> |
    <a href="#插件列表">插件列表</a> |
    <a href="#配置说明">配置说明</a>
  </h4>
</div>

<div align="center">
  <strong>去你妈的，干就完了!</strong>
</div>

## 简介

FuckVim 是一个开箱即用的 Neovim 配置整合包，专为中文用户和 C/C++ 开发者打造。它集成了最常用的插件和功能，界面美观，操作流畅，并且提供了全中文的按键提示和帮助系统。

不需要复杂的配置，一键安装即可获得专业 IDE 级别的开发体验。

## 截图展示

![主界面](screenshots/main.png)
*启动画面及代码编辑界面*

![帮助系统](screenshots/help.png)
*中文快捷键帮助系统*

![代码补全](screenshots/completion.png)
*智能代码补全*

## 特色功能

- 🇨🇳 **全中文界面及按键提示**：按下空格键立即显示中文快捷键提示面板
- 🚀 **一键编译运行**：F5 快速编译运行 C/C++ 代码
- 🧠 **AI 代码补全**：集成 Codeium 实现智能代码建议
- 🔍 **语义代码导航**：符号列表、定义跳转、引用查找等
- 💻 **美观界面**：VSCode 风格的深色主题
- 🚦 **Git 集成**：文件变更标记、提交信息等
- 🧩 **LSP 支持**：智能代码分析、错误提示、自动修复
- 📝 **自动括号匹配和缩进**：键入左括号自动补全右括号
- 🔄 **变量重命名**：智能重命名变量和函数
- 📊 **项目管理**：文件树、搜索、标签等
- 🖥️ **内置终端**：方便的命令行访问
- 🎮 **键位冲突解决**：经过细致调整的快捷键布局

## 前置依赖

FuckVim 需要以下前置依赖才能正常工作：

### 必需依赖

- **Neovim** (0.9.0+) - 核心编辑器
- **Git** - 插件管理和版本控制
- **GCC/G++ 或 Clang** - C/C++编译器
- **clangd** - C/C++语言服务器
- **clang-format** - 代码格式化工具

### 推荐依赖

- **ripgrep** - 用于文本搜索
- **fd-find** - 用于文件查找
- **nodejs & npm** - 部分LSP服务器需要
- **lazygit** - Git交互工具

### 关于网络问题

由于GitHub访问可能存在问题，强烈建议在安装前确保：

- 网络连接稳定
- 如果在中国大陆，建议**使用代理**以加速访问GitHub
- 如果插件下载缓慢，可使用`export http_proxy=http://127.0.0.1:端口号`启用代理

## 安装指南

### 自动安装（推荐）

安装脚本会自动安装所需依赖并配置FuckVim：

```bash
# 克隆仓库
git clone https://github.com/DengY11/FuckVim.git
cd FuckVim

# 赋予安装脚本执行权限
chmod +x INSTALL.sh

# 运行安装脚本
./INSTALL.sh
```

> **注意**：安装过程中可能需要输入管理员密码以安装依赖项。
> 
> **建议**：在安装前确保系统已经开启了网络代理，以确保顺利从GitHub下载所需插件。

### 手动安装

如果您不想使用安装脚本，可以手动安装：

1. 安装所需依赖（Neovim 0.9.0+, Git, GCC/Clang, clangd, clang-format等）
2. 备份现有Neovim配置（如果有）：`mv ~/.config/nvim ~/.config/nvim.bak`
3. 克隆FuckVim仓库：`git clone https://github.com/DengY11/FuckVim.git`
4. 将配置文件复制到Neovim配置目录：
   ```bash
   mkdir -p ~/.config/nvim
   cp -r FuckVim/init.lua ~/.config/nvim/
   cp -r FuckVim/lua ~/.config/nvim/ # 如果存在lua目录
   ```
5. 启动Neovim，插件将被自动安装

### 特定系统的依赖安装

#### Ubuntu/Debian
```bash
# 安装基本依赖
sudo apt update
sudo apt install -y git curl unzip wget build-essential cmake

# 安装Neovim (新版本)
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

# 安装编译工具
sudo apt install -y gcc g++ clang clangd clang-format

# 安装其他工具
sudo apt install -y ripgrep fd-find nodejs npm
```

#### Arch Linux
```bash
sudo pacman -S neovim git gcc clang clang-tools-extra ripgrep fd nodejs npm lazygit
```

#### Fedora
```bash
sudo dnf install -y neovim git gcc gcc-c++ clang clang-tools-extra ripgrep fd-find nodejs
```

## 使用方法

### 基本操作

- 按下 `空格` 键查看所有快捷键
- 按下 `空格 + h` 显示详细帮助面板
- 按下 `F5` 编译并运行当前代码
- 按下 `空格 + e` 打开/关闭文件浏览器
- 按下 `空格 + ff` 查找文件
- 按下 `空格 + fg` 全局搜索文本

### AI 代码补全

FuckVim 集成了 Codeium AI 代码补全：

- 在插入模式下，AI 会自动提供代码建议
- 按下 `Ctrl + g` 接受建议
- 按下 `Ctrl + ;` 和 `Ctrl + ,` 查看下一个/上一个建议
- 按下 `空格 + Aa` 进行 Codeium 认证

## 快捷键

FuckVim 提供了直观的中文快捷键提示。按下 `空格` 键可以看到分类的命令列表，按下 `空格 + h` 可以看到完整的快捷键列表。

### 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `空格 + cf` | 格式化代码 |
| `空格 + ca` | 代码操作 |
| `空格 + cr` | 重命名变量/函数 |
| `gr` | 查找所有引用 |
| `gd` | 跳转到定义 |
| `K` | 显示文档 |
| `空格 + e` | 文件浏览器 |
| `空格 + ff` | 查找文件 |
| `空格 + fg` | 全局搜索 |
| `F5` | 运行当前代码 |
| `空格 + /` | 注释代码 |

## 插件列表

FuckVim 集成了以下精选插件：

- **界面美化**: catppuccin/nvim (VSCode风格主题)
- **文件管理**: nvim-neo-tree/neo-tree.nvim
- **模糊查找**: nvim-telescope/telescope.nvim
- **语法高亮**: nvim-treesitter/nvim-treesitter
- **代码导航**: SmiteshP/nvim-navic
- **LSP支持**: neovim/nvim-lspconfig
- **代码补全**: hrsh7th/nvim-cmp
- **自动括号**: windwp/nvim-autopairs
- **AI辅助**: Exafunction/codeium.vim
- **Git集成**: lewis6991/gitsigns.nvim
- **命令提示**: folke/which-key.nvim
- **启动界面**: goolord/alpha-nvim
- **代码块注释**: numToStr/Comment.nvim
- **终端集成**: akinsho/toggleterm.nvim
- **代码编译运行**: CRAG666/code_runner.nvim
- **窗口管理**: mrjones2014/smart-splits.nvim

## 配置说明

FuckVim 的配置文件位于 `~/.config/nvim/init.lua`。目录结构如下：

```
~/.config/nvim/
├── init.lua          # 主配置文件
├── lazy-lock.json    # 插件版本锁定文件
└── lua/              # Lua 模块目录
```

### 自定义配置

您可以通过编辑 `init.lua` 文件来自定义配置。配置文件包含详细的中文注释，方便您理解和修改。

## 贡献指南

欢迎对 FuckVim 进行贡献！请随时提交 issue 或 pull request。

## 致谢

FuckVim 受到了众多优秀 Neovim 配置的启发，感谢所有开源贡献者。

## 许可证

MIT 许可证 