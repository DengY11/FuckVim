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

# 检查依赖项
function check_requirements() {
    echo -e "${BLUE}[1/4]${NC} 检查必要的依赖项..."
    
    # 检查nvim
    if ! command -v nvim &> /dev/null; then
        print_error "未找到 neovim。请先安装 neovim 0.9.0 或更高版本。"
    fi
    
    NVIM_VERSION=$(nvim --version | head -n 1 | cut -d " " -f 2)
    if [[ $(echo "$NVIM_VERSION 0.9.0" | awk '{print ($1 < $2)}') -eq 1 ]]; then
        print_error "Neovim 版本太低: $NVIM_VERSION, 需要 0.9.0 或更高版本。"
    fi
    
    # 检查git
    if ! command -v git &> /dev/null; then
        print_error "未找到 Git。请先安装 Git。"
    fi
    
    # 检查编译器
    if ! command -v gcc &> /dev/null && ! command -v clang &> /dev/null; then
        echo -e "${YELLOW}警告: 未找到 C/C++ 编译器 (gcc/g++ 或 clang)，编译功能将不可用。${NC}"
    fi
    
    # 检查可选依赖
    if ! command -v node &> /dev/null; then
        echo -e "${YELLOW}警告: 未找到 Node.js，某些LSP功能可能不可用。${NC}"
    fi
    
    if ! command -v lazygit &> /dev/null; then
        echo -e "${YELLOW}警告: 未找到 lazygit，Git 界面功能将不可用。${NC}"
    fi
    
    if ! command -v rg &> /dev/null; then
        echo -e "${YELLOW}警告: 未找到 ripgrep，搜索功能将受限。${NC}"
    fi
    
    echo -e "${GREEN}✓ 依赖检查完成${NC}"
}

# 备份现有配置
function backup_config() {
    echo -e "${BLUE}[2/4]${NC} 备份现有的 Neovim 配置..."
    
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
    
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        echo -e "${GREEN}✓ 现有配置已备份到: $BACKUP_DIR${NC}"
    else
        echo -e "${GREEN}✓ 未发现现有配置，将直接安装${NC}"
    fi
}

# 安装FuckVim
function install_fuckvim() {
    echo -e "${BLUE}[3/4]${NC} 安装 FuckVim..."
    
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    
    # 创建目录
    mkdir -p "$NVIM_CONFIG_DIR"
    
    # 复制文件
    cp -r ./* "$NVIM_CONFIG_DIR/"
    
    echo -e "${GREEN}✓ FuckVim 配置文件已安装${NC}"
}

# 安装后的说明
function post_install() {
    echo -e "${BLUE}[4/4]${NC} 完成安装..."
    echo -e "${GREEN}✓ FuckVim 已成功安装!${NC}"
    echo ""
    echo -e "${YELLOW}首次启动时，Neovim 将自动安装所有插件，这可能需要一些时间。${NC}"
    echo ""
    echo -e "使用方法:"
    echo -e "  - 输入 ${CYAN}nvim${NC} 启动 Neovim"
    echo -e "  - 按下 ${CYAN}空格${NC} 键查看可用命令"
    echo -e "  - 按下 ${CYAN}空格 + h${NC} 键查看详细帮助"
    echo ""
    echo -e "${PURPLE}去你妈的，干就完了!${NC}"
}

# 主函数
function main() {
    show_logo
    check_requirements
    backup_config
    install_fuckvim
    post_install
}

# 执行主函数
main 