PAIR_KEY_WIDTH=0
declare -a PAIR_KEYS=()
declare -a PAIR_VALUES=()

pair_reset() {
  PAIR_KEY_WIDTH=0
  PAIR_KEYS=()
  PAIR_VALUES=()
}

pair_add() {
  local key
  local value
  key=$1
  value=${2:-}
  PAIR_KEYS+=("$key")
  PAIR_VALUES+=("$value")
  if ((${#key} > PAIR_KEY_WIDTH)); then
    PAIR_KEY_WIDTH=${#key}
  fi
}

pair_print() {
  local index
  local key
  local value
  for ((index = 0; index < ${#PAIR_KEYS[@]}; index++)); do
    key=${PAIR_KEYS[$index]}
    value=${PAIR_VALUES[$index]}
    printf "%-${PAIR_KEY_WIDTH}s %s\n" "$key" "$value"
  done
}
