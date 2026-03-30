#!/bin/bash

# 获取当前脚本所在的绝对路径
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# 需要自动安装的依赖软件列表
DEPENDENCIES=("zsh" "tmux" "vim" "git" "curl")

# 需要建立软链接的配置文件列表
FILES=(".vimrc" ".tmux.conf" ".zshrc" ".bashrc" ".profile" ".gitconfig")

echo "========================================"
echo "🚀 开始全自动部署 dotfiles 环境..."
echo "========================================"

# ---------------------------------------------------------
# 阶段一：环境依赖检测与安装
# ---------------------------------------------------------
echo -e "\n[1/4] 🔍 检测并安装缺失的软件包..."

# 自动推断包管理器
if command -v apt-get >/dev/null; then
    PKG_MANAGER="sudo apt-get install -y"
elif command -v brew >/dev/null; then
    PKG_MANAGER="brew install"
elif command -v pacman >/dev/null; then
    PKG_MANAGER="sudo pacman -S --noconfirm"
elif command -v dnf >/dev/null; then
    PKG_MANAGER="sudo dnf install -y"
else
    PKG_MANAGER=""
    echo "⚠️  未能识别系统的包管理器（apt/brew/pacman/dnf），请稍后手动安装缺失的软件！"
fi

for pkg in "${DEPENDENCIES[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "📦 正在安装缺失的依赖: $pkg ..."
        if [ -n "$PKG_MANAGER" ]; then
            $PKG_MANAGER "$pkg"
        else
            echo "❌ 无法自动安装 $pkg，请手动处理。"
        fi
    else
        echo "✅ $pkg 已安装"
    fi
done

# ---------------------------------------------------------
# 阶段二：安装 Oh My Zsh (如果不存在)
# ---------------------------------------------------------
echo -e "\n[2/4] 🐚 检测 Oh My Zsh 环境..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🚀 未发现 Oh My Zsh，正在后台静默安装..."
    # 关键：RUNZSH=no 和 CHSH=no 确保安装完成后不会自动进入 zsh 从而中断我们的脚本
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✅ Oh My Zsh 安装完成！"
else
    echo "✅ Oh My Zsh 已安装"
fi

# ---------------------------------------------------------
# 阶段三：部署 Dotfiles (备份与软链接)
# ---------------------------------------------------------
echo -e "\n[3/4] 🔗 部署配置文件..."
for file in "${FILES[@]}"; do
    TARGET="$HOME/$file"
    SOURCE="$DOTFILES_DIR/$file"

    if [ ! -e "$SOURCE" ]; then
        echo "⚠️  仓库中未找到 $file，跳过。"
        continue
    fi

    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        if [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
            echo "✅ $file 已经是正确的软链接。"
            continue
        fi

        mkdir -p "$BACKUP_DIR"
        echo "📦 备份旧文件: $file -> $BACKUP_DIR/"
        mv "$TARGET" "$BACKUP_DIR/"
    fi

    echo "🔗 创建链接: ~/$file -> $SOURCE"
    ln -sf "$SOURCE" "$TARGET"
done

# ---------------------------------------------------------
# 阶段四：切换默认 Shell
# ---------------------------------------------------------
echo -e "\n[4/4] 🔄 检查默认 Shell..."
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "⚠️  当前默认 Shell 不是 Zsh。"
    echo "👉 正在尝试切换默认 Shell 为 Zsh (可能会要求输入当前用户的密码)..."
    chsh -s "$(command -v zsh)"
    echo "✅ 切换完成！(需要重新登录或重启终端才能生效)"
else
    echo "✅ 当前默认 Shell 已经是 Zsh"
fi

echo -e "\n========================================"
echo "🎉 所有环境部署完毕！"
if [ -d "$BACKUP_DIR" ]; then
    echo "💡 你的旧配置文件已安全备份在: $BACKUP_DIR"
fi
echo "👉 请关闭当前终端并重新打开，或者输入 'exec zsh' 立即体验新环境！"
echo "========================================"
