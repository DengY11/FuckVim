#!/bin/bash

# FuckVim 安装脚本
# 作者: DengY11
# GitHub: https://github.com/DengY11/FuckVim

# 彩色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# Logo 显示
function show_logo() {
    echo -e "${PURPLE}"
    echo '  ███████╗██╗   ██╗ ██████╗██╗  ██╗██╗   ██╗██╗███╗   ███╗  '
    echo '  ██╔════╝██║   ██║██╔════╝██║ ██╔╝██║   ██║██║████╗ ████║  '
    echo '  █████╗  ██║   ██║██║     █████╔╝ ██║   ██║██║██╔████╔██║  '
    echo '  ██╔══╝  ██║   ██║██║     ██╔═██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║  '
    echo '  ██║     ╚██████╔╝╚██████╗██║  ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║  '
    echo '  ╚═╝      ╚═════╝  ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  '
    echo -e "${NC}"
    echo -e "${CYAN}===== 为C/C++开发者打造的Neovim配置 =====${NC}"
    echo ''
}

# 显示错误并退出
function print_error() {
    echo -e "${RED}错误: $1${NC}"
    exit 1
}

# 检测系统类型
function detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    echo -e "${BLUE}检测到操作系统: $OS $VER${NC}"
}

# 安装依赖
function install_dependencies() {
    echo -e "${BLUE}[1/5]${NC} 安装必要的依赖项..."
    
    case $OS in
        Ubuntu|Debian|"Linux Mint"|"Kali GNU/Linux"|"Parrot GNU/Linux")
            echo -e "${CYAN}使用apt安装依赖...${NC}"
            sudo apt update
            sudo apt install -y git curl unzip wget build-essential cmake
            
            # 安装Neovim
            if ! command -v nvim &> /dev/null; then
                echo -e "${YELLOW}未检测到Neovim，正在安装...${NC}"
                sudo apt install -y software-properties-common
                sudo add-apt-repository -y ppa:neovim-ppa/unstable
                sudo apt update
                sudo apt install -y neovim
            fi
            
            # 编译工具
            sudo apt install -y gcc g++ clang clangd clang-format
            
            # 其他工具
            sudo apt install -y ripgrep fd-find nodejs npm
            
            # 安装lazygit (可选)
            if ! command -v lazygit &> /dev/null; then
                echo -e "${YELLOW}正在安装lazygit...${NC}"
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit lazygit.tar.gz
            fi
            ;;
            
        "Arch Linux"|Manjaro|EndeavourOS)
            echo -e "${CYAN}使用pacman安装依赖...${NC}"
            sudo pacman -Sy
            sudo pacman -S --needed git curl unzip wget base-devel cmake
            
            # 安装Neovim
            if ! command -v nvim &> /dev/null; then
                echo -e "${YELLOW}未检测到Neovim，正在安装...${NC}"
                sudo pacman -S --needed neovim
            fi
            
            # 编译工具
            sudo pacman -S --needed gcc clang clang-tools-extra
            
            # 其他工具
            sudo pacman -S --needed ripgrep fd nodejs npm lazygit
            ;;
            
        "Fedora Linux"|"CentOS Linux"|"Red Hat Enterprise Linux")
            echo -e "${CYAN}使用dnf安装依赖...${NC}"
            sudo dnf update -y
            sudo dnf install -y git curl unzip wget gcc gcc-c++ make cmake
            
            # 安装Neovim
            if ! command -v nvim &> /dev/null; then
                echo -e "${YELLOW}未检测到Neovim，正在安装...${NC}"
                sudo dnf install -y neovim
            fi
            
            # 编译工具
            sudo dnf install -y clang clang-tools-extra
            
            # 其他工具
            sudo dnf install -y ripgrep fd-find nodejs
            
            # 安装lazygit (可选)
            if ! command -v lazygit &> /dev/null; then
                echo -e "${YELLOW}正在安装lazygit...${NC}"
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit lazygit.tar.gz
            fi
            ;;
            
        *)
            echo -e "${YELLOW}未识别的操作系统: $OS${NC}"
            echo -e "${YELLOW}请手动安装以下依赖:${NC}"
            echo -e "- Neovim (0.9.0+)"
            echo -e "- Git"
            echo -e "- gcc/g++/clang/clangd/clang-format"
            echo -e "- ripgrep (文本搜索工具)"
            echo -e "- fd-find (文件查找工具)"
            echo -e "- nodejs & npm"
            echo -e "- lazygit (可选，Git交互工具)"
            ;;
    esac
    
    # 检查必要的依赖
    echo -e "${BLUE}检查核心依赖安装情况...${NC}"
    
    # 检查nvim
    if ! command -v nvim &> /dev/null; then
        print_error "未能安装 Neovim。请手动安装 Neovim 0.9.0 或更高版本后重试。"
    fi
    
    NVIM_VERSION=$(nvim --version | head -n 1 | cut -d " " -f 2)
    if [[ $(echo "$NVIM_VERSION 0.9.0" | awk '{print ($1 < $2)}') -eq 1 ]]; then
        print_error "Neovim 版本太低: $NVIM_VERSION, 需要 0.9.0 或更高版本。"
    fi
    
    # 检查git
    if ! command -v git &> /dev/null; then
        print_error "未能安装 Git。请手动安装 Git 后重试。"
    fi
    
    # 检查编译器
    if ! command -v gcc &> /dev/null && ! command -v clang &> /dev/null; then
        print_error "未能安装 C/C++ 编译器。请手动安装 gcc/g++ 或 clang 后重试。"
    fi
    
    # 检查clangd
    if ! command -v clangd &> /dev/null; then
        echo -e "${YELLOW}警告: 未能安装 clangd。C/C++ 语言服务器功能将受限。${NC}"
    fi
    
    # 检查clang-format
    if ! command -v clang-format &> /dev/null; then
        echo -e "${YELLOW}警告: 未能安装 clang-format。C/C++ 代码格式化功能将使用LSP默认格式化。${NC}"
    fi
    
    # 检查ripgrep (用于全文搜索)
    if ! command -v rg &> /dev/null; then
        echo -e "${YELLOW}警告: 未能安装 ripgrep。Telescope 全文搜索功能将受限。${NC}"
    fi
    
    # 检查fd (用于文件查找)
    if ! command -v fd &> /dev/null && ! command -v fdfind &> /dev/null; then
        echo -e "${YELLOW}警告: 未能安装 fd-find。Telescope 文件查找功能将使用备选方案。${NC}"
    fi
    
    # 检查Node.js (用于LSP服务器)
    if ! command -v node &> /dev/null; then
        echo -e "${YELLOW}警告: 未能安装 Node.js。某些LSP服务器功能可能不可用。${NC}"
    fi
    
    echo -e "${GREEN}✓ 依赖检查完成${NC}"
}

# 检查网络连接，特别是对GitHub的访问
function check_network() {
    echo -e "${BLUE}[2/5]${NC} 检查网络连接..."
    
    echo -e "尝试连接GitHub..."
    if curl -s --connect-timeout 5 https://github.com > /dev/null; then
        echo -e "${GREEN}✓ GitHub 连接正常${NC}"
    else
        echo -e "${YELLOW}警告: 无法连接到 GitHub。这可能导致插件安装失败。${NC}"
        echo -e "${YELLOW}建议:${NC}"
        echo -e "1. 请确保您的网络连接正常"
        echo -e "2. 如果您在中国大陆，建议使用代理或镜像站点"
        echo -e "3. 使用网络代理工具以加速访问 GitHub"
        
        read -p "是否继续安装? (y/n): " choice
        case "$choice" in
            y|Y ) echo "继续安装...";;
            * ) echo "安装已取消。"; exit 1;;
        esac
    fi
}

# 备份现有配置
function backup_config() {
    echo -e "${BLUE}[3/5]${NC} 备份现有的 Neovim 配置..."
    
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
    
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        echo -e "${GREEN}✓ 现有配置已备份到: $BACKUP_DIR${NC}"
    else
        echo -e "${GREEN}✓ 未发现现有配置，将直接安装${NC}"
    fi
    
    # 备份lazy.nvim目录（如果存在）
    LAZY_DIR="$HOME/.local/share/nvim/lazy"
    LAZY_BACKUP="$HOME/.local/share/nvim/lazy.bak.$(date +%Y%m%d%H%M%S)"
    
    if [ -d "$LAZY_DIR" ]; then
        mv "$LAZY_DIR" "$LAZY_BACKUP"
        echo -e "${GREEN}✓ 现有插件已备份到: $LAZY_BACKUP${NC}"
    fi
}

# 安装FuckVim
function install_fuckvim() {
    echo -e "${BLUE}[4/5]${NC} 安装 FuckVim..."
    
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    
    # 创建目录
    mkdir -p "$NVIM_CONFIG_DIR"
    
    # 复制文件
    cp -r ./init.lua "$NVIM_CONFIG_DIR/"
    cp -r ./lua "$NVIM_CONFIG_DIR/"
    [ -f ./lazy-lock.json ] && cp -r ./lazy-lock.json "$NVIM_CONFIG_DIR/"
    
    # 创建依赖目录
    mkdir -p "$HOME/.local/share/nvim/site/pack/packer/start"
    
    echo -e "${GREEN}✓ FuckVim 配置文件已安装${NC}"
}

# 优化插件安装速度
function optimize_plugin_speed() {
    echo -e "${BLUE}[5/5]${NC} 优化插件下载速度..."
    
    # 设置代理判断
    if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
        echo -e "${GREEN}✓ 已检测到系统代理设置，跳过优化${NC}"
        return
    fi
    
    # 设置git全局配置提高下载速度
    git config --global http.postBuffer 524288000
    
    echo -e "${GREEN}✓ Git 下载缓冲区已优化${NC}"
    
    # 提示用户可能需要代理
    echo -e "${YELLOW}提示: 如果插件下载过慢，可以使用以下命令启用代理:${NC}"
    echo -e "  export http_proxy=http://127.0.0.1:端口号"
    echo -e "  export https_proxy=http://127.0.0.1:端口号"
}

# 安装后的说明
function post_install() {
    echo -e "${GREEN}✓ FuckVim 已成功安装!${NC}"
    echo ""
    echo -e "${YELLOW}首次启动时，Neovim 将自动安装所有插件，这可能需要一些时间。${NC}"
    echo -e "${YELLOW}- 若插件下载失败，可能是因为网络问题，建议使用网络代理工具。${NC}"
    echo -e "${YELLOW}- 如果出现错误提示，请尝试重启Neovim再次运行。${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  - 输入 ${CYAN}nvim${NC} 启动 Neovim"
    echo -e "  - 按下 ${CYAN}空格${NC} 键查看可用命令"
    echo -e "  - 按下 ${CYAN}空格 + h${NC} 键查看详细帮助"
    echo -e "  - 按下 ${CYAN}RR${NC} (双击R) 可以快速重命名变量"
    echo -e "  - 按下 ${CYAN}F5${NC} 编译并运行当前代码"
    echo -e "  - 查看 README.md 获取更多信息"
    echo ""
    echo -e "${PURPLE}去你妈的，干就完了!${NC}"
}

# 主函数
function main() {
    show_logo
    detect_os
    install_dependencies
    check_network
    backup_config
    install_fuckvim
    optimize_plugin_speed
    post_install
}

# 命令行参数处理
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            echo "FuckVim 安装脚本用法:"
            echo "  ./INSTALL.sh         # 安装 FuckVim"
            echo "  ./INSTALL.sh --help  # 显示帮助信息"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            echo "使用 --help 查看帮助信息"
            exit 1
            ;;
    esac
    shift
done

# 执行主函数
main 