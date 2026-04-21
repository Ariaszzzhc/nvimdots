#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
MINIMAL=0
SYNC_NVIM=1

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Install this Neovim config and the external tools it expects.

Options:
  --dry-run   Print commands without running them.
  --minimal   Install only core editor tools.
  --no-sync   Do not start Neovim after installing packages.
  -h, --help  Show this help.
USAGE
}

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --minimal)
      MINIMAL=1
      ;;
    --no-sync)
      SYNC_NVIM=0
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

have() {
  command -v "$1" >/dev/null 2>&1
}

print_command() {
  printf '+'
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf '\n'
}

run() {
  if ((DRY_RUN)); then
    print_command "$@"
    return
  fi

  "$@"
}

sudo_run() {
  if ((DRY_RUN)); then
    if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
      print_command "$@"
    else
      print_command sudo "$@"
    fi
    return
  fi

  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

try_sudo_run() {
  if ! sudo_run "$@"; then
    warn "Command failed: $*"
    return 1
  fi
}

install_optional_packages() {
  local installer="$1"
  shift

  if ((MINIMAL)); then
    return
  fi

  for package in "$@"; do
    log "Installing optional package: $package"
    case "$installer" in
      brew)
        if ! run brew install "$package"; then
          warn "Optional Homebrew package failed: $package"
        fi
        ;;
      apt)
        try_sudo_run env DEBIAN_FRONTEND=noninteractive apt-get install -y "$package" || true
        ;;
      dnf)
        try_sudo_run dnf install -y "$package" || true
        ;;
      pacman)
        try_sudo_run pacman -S --needed --noconfirm "$package" || true
        ;;
    esac
  done
}

install_npm_tools() {
  if ((MINIMAL)); then
    return
  fi

  if ! have npm; then
    warn "npm is unavailable; skipping prettier and @biomejs/biome npm install"
    return
  fi

  log "Installing npm formatters"
  if ! run npm install -g prettier @biomejs/biome; then
    warn "npm global install failed. Install prettier and @biomejs/biome manually if needed."
  fi
}

install_macos() {
  if ! have brew; then
    warn "Homebrew is required on macOS: https://brew.sh"
    exit 1
  fi

  log "Installing macOS packages with Homebrew"
  run brew install neovim git ripgrep fd fzf bat
  install_optional_packages brew git-delta zoxide gh stylua deno biome prettier lua-language-server llvm cmake

  if ! have clangd && have brew; then
    local llvm_prefix
    llvm_prefix="$(brew --prefix llvm 2>/dev/null || true)"
    if [[ -n "$llvm_prefix" && -x "$llvm_prefix/bin/clangd" ]]; then
      ensure_alias clangd "$llvm_prefix/bin/clangd"
    fi
  fi
}

install_debian_like() {
  log "Installing Debian/Ubuntu packages with apt"
  sudo_run apt-get update
  sudo_run env DEBIAN_FRONTEND=noninteractive apt-get install -y neovim git ripgrep fd-find fzf bat curl unzip
  install_optional_packages apt git-delta zoxide gh clangd cmake nodejs npm lua-language-server build-essential
  install_npm_tools
}

install_fedora() {
  log "Installing Fedora packages with dnf"
  sudo_run dnf install -y neovim git ripgrep fd-find fzf bat curl unzip
  install_optional_packages dnf git-delta zoxide gh stylua deno biome prettier lua-language-server clang-tools-extra cmake nodejs npm make gcc gcc-c++
  install_npm_tools
}

install_arch() {
  log "Installing Arch packages with pacman"
  sudo_run pacman -Syu --needed --noconfirm neovim git ripgrep fd fzf bat curl unzip
  install_optional_packages pacman git-delta zoxide github-cli stylua deno biome prettier lua-language-server clang cmake nodejs npm base-devel
  install_npm_tools
}

ensure_alias() {
  local command_name="$1"
  local source_name="$2"
  local local_bin="$HOME/.local/bin"
  local target="$local_bin/$command_name"
  local source_path

  if have "$command_name"; then
    return
  fi

  if [[ -x "$source_name" ]]; then
    source_path="$source_name"
  elif have "$source_name"; then
    source_path="$(command -v "$source_name")"
  else
    return
  fi

  if [[ -e "$target" ]]; then
    warn "$target already exists; leaving it unchanged"
    return
  fi

  run mkdir -p "$local_bin"
  run ln -s "$source_path" "$target"
  warn "Created $target -> $source_name. Make sure $local_bin is in PATH."
}

detect_linux_installer() {
  if [[ ! -r /etc/os-release ]]; then
    warn "Cannot detect Linux distribution: /etc/os-release is missing"
    exit 1
  fi

  # shellcheck disable=SC1091
  . /etc/os-release

  case "${ID:-}" in
    ubuntu | debian)
      install_debian_like
      ensure_alias fd fdfind
      ensure_alias bat batcat
      ;;
    fedora)
      install_fedora
      ;;
    arch)
      install_arch
      ;;
    *)
      case " ${ID_LIKE:-} " in
        *" debian "*)
          install_debian_like
          ensure_alias fd fdfind
          ensure_alias bat batcat
          ;;
        *" fedora "*)
          install_fedora
          ;;
        *" arch "*)
          install_arch
          ;;
        *)
          warn "Unsupported Linux distribution: ${PRETTY_NAME:-unknown}"
          exit 1
          ;;
      esac
      ;;
  esac
}

install_packages() {
  case "$(uname -s)" in
    Darwin)
      install_macos
      ;;
    Linux)
      detect_linux_installer
      ;;
    *)
      warn "Unsupported OS: $(uname -s)"
      exit 1
      ;;
  esac
}

physical_path() {
  cd "$1" 2>/dev/null && pwd -P
}

install_config_link() {
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  local target="$config_home/nvim"
  local repo_real
  local target_real

  repo_real="$(physical_path "$repo_dir")"

  if [[ -e "$target" ]]; then
    target_real="$(physical_path "$target" || true)"
    if [[ "$target_real" == "$repo_real" ]]; then
      log "Config directory already points to this repo"
      return
    fi

    warn "Config target already exists: $target"
    warn "Leaving it unchanged. Move it aside if you want this script to link the repo."
    return
  fi

  log "Linking config to $target"
  run mkdir -p "$config_home"
  run ln -s "$repo_dir" "$target"
}

sync_neovim() {
  if ((SYNC_NVIM == 0)); then
    return
  fi

  if ! have nvim; then
    warn "nvim is unavailable; skipping plugin sync and healthcheck"
    return
  fi

  log "Starting Neovim once to install plugins and run :checkhealth config"
  run nvim --headless "+checkhealth config" "+qa"
}

install_packages
install_config_link
sync_neovim
