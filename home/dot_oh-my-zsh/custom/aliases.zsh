alias vi="nvim"
alias fastfetch="clear; fastfetch"


# Chuyển thư mục nhanh với fzf
fcd() {
  local file
  file=$(fzf) && cd "$(dirname "$file")"
}

fv() {
  local file
  file=$(fzf) && vi "$file"
}

# ===================================
# Eza Alias
# ===================================

if (( $+commands[eza] )); then
  unalias ls ll la lt 2>/dev/null

  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --group-directories-first --git'
  alias la='eza -a --icons=auto --group-directories-first'
  alias lt='eza --tree --icons=auto --group-directories-first'
fi

# ===================================
# Chezmoi wrapper
# ===================================
chezmoi() {
    case "$1" in
        push)
            # Kiểm tra xem chezmoi đã có lệnh `push` native chưa
            if command chezmoi push --help &>/dev/null; then
                echo -e "\033[1;33m[WARNING] Chezmoi đã có lệnh 'push' native! Đang chuyển sang lệnh hệ thống...\033[0m"
                command chezmoi "$@"
            else
                shift # Bỏ tham số "push"
                local msg="${1:-Update dotfiles}"
                command chezmoi git add . && \
                command chezmoi git -- commit -m "$msg" && \
                command chezmoi git -- push -u origin main
            fi
            ;;
        pull)
            if command chezmoi pull --help &>/dev/null; then
                echo -e "\033[1;33m[WARNING] Chezmoi đã có lệnh 'pull' native! Đang chuyển sang lệnh hệ thống...\033[0m"
                command chezmoi "$@"
            else
                command chezmoi git -- pull -u origin main
                command chezmoi apply
            fi
            ;;
        link)
            if command chezmoi link --help &>/dev/null; then
                echo -e "\033[1;33m[WARNING] Chezmoi đã có lệnh 'link' native! Đang chuyển sang lệnh hệ thống...\033[0m"
                command chezmoi "$@"
            else

                shift
                command chezmoi add "$@"
                command chezmoi apply
            fi
            ;;
        unlink)
            if command chezmoi unlink --help &>/dev/null; then
                echo -e "\033[1;33m[WARNING] Chezmoi đã có lệnh 'unlink' native! Đang chuyển sang lệnh hệ thống...\033[0m"
                command chezmoi "$@"
            else

                shift
                # Duyệt qua danh sách các file truyền vào
                for target in "$@"; do
                    # Nếu target là symlink, chép đè file thực lên trước để tránh broken symlink
                    if [ -L "$target" ]; then
                        local real_file
                        real_file=$(readlink -f "$target")
                        cp --remove-destination "$real_file" "$target"
                    fi
                done
                # Chạy chezmoi forget để xoá quản lý trong repo
                command chezmoi forget --force "$@"
            fi
            ;;
        *)
            command chezmoi "$@"
            ;;
    esac
}

# ===================================
# Chezmoi-root wrapper
# ===================================
chezmoi-root() {
  local root_dir="${CHEZMOI_ROOT_DIR:-$HOME/.local/share/chezmoi/root}"
  local config_file="$HOME/.config/chezmoi/root.toml"

  case "$1" in
    push)
      # Kiểm tra xem chezmoi đã có lệnh `push` native chưa
      if command chezmoi push --help &>/dev/null; then
        echo -e "\033[1;33m[WARNING] Chezmoi-root đã có lệnh 'push' native! Đang chuyển sang lệnh hệ thống...\033[0m"
        sudo chezmoi "$@" --config "$config_file"
      else
        shift # Bỏ tham số "push"
        local msg="${1:-Update dotfiles}"
        cd "$root_dir" && \
        command git add . && \
        command git commit -m "$msg" && \
        command git push -u origin main
        cd ~
      fi
      ;;

    pull)
      if command chezmoi-root pull --help &>/dev/null; then
        echo -e "\033[1;33m[WARNING] Chezmoi-root đã có lệnh 'pull' native! Đang chuyển sang lệnh hệ thống...\033[0m"
        sudo chezmoi "$@" --config "$config_file"
      else
        cd "$root_dir" && \
        command git pull origin main && \
        sudo chezmoi apply --config "$config_file"
        cd ~
      fi
      ;;

    cd)
      cd "$root_dir"
      ;;

    *)
      sudo chezmoi "$@" --config "$config_file"
      ;;
  esac
}
