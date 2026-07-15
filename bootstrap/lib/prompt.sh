# 在安装软件或修改系统设置前进行确认。
confirm() {
  local message="$1"

  printf "%s [y/N] " "$message"
  read -r reply
  case "$reply" in
  y | Y | yes | YES) return 0 ;;
  *) return 1 ;;
  esac
}
