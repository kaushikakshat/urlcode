#!/bin/zsh
# ─────────────────────────────────────────────
#  URL-Encoder-Decoder.sh — URL encode/decode (macOS)
#  Usage:  ./URL-Encoder-Decoder.sh -e|-d [-p] [text]
#          echo 'text' | ./URL-Encoder-Decoder.sh -e
# ─────────────────────────────────────────────

mode=""
preserve=false
OPTIND=1

while getopts ":edph" opt; do
  case $opt in
    e) mode="encode" ;;
    d) mode="decode" ;;
    p) preserve=true ;;
    h)
      echo ""
      echo "  URL-Encoder-Decoder — URL encode/decode with clipboard copy (macOS)"
      echo ""
      echo "  Usage:"
      echo "    ./URL-Encoder-Decoder.sh -e 'hello world'                    →  hello%20world"
      echo "    ./URL-Encoder-Decoder.sh -d 'hello%20world'                  →  hello world"
      echo "    ./URL-Encoder-Decoder.sh -e -p 'https://x.com?q=hello world' →  preserves :/?=&#"
      echo "    echo 'text' | ./URL-Encoder-Decoder.sh -e                    →  pipe input"
      echo ""
      echo "  Flags:"
      echo "    -e   Encode"
      echo "    -d   Decode"
      echo "    -p   Preserve URL structure chars when encoding ( :/?#[]@!\$&'()*+,;= )"
      echo "    -h   Show this help"
      echo ""
      exit 0 ;;
    \?)
      echo "Unknown flag: -$OPTARG. Run with -h for help." >&2
      exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# Require a mode flag
if [[ -z "$mode" ]]; then
  echo "Specify -e to encode or -d to decode. Run with -h for help." >&2
  exit 1
fi

# Accept input from argument(s) or stdin pipe
if [[ $# -gt 0 ]]; then
  input="$*"
elif [[ ! -t 0 ]]; then
  input=$(cat)
else
  echo "No input provided. Pass text as an argument or pipe it in." >&2
  exit 1
fi

# Encode or decode via Python 3 (ships with macOS)
if [[ "$mode" == "encode" ]]; then
  safe_chars=""
  $preserve && safe_chars=":/?#[]@!\$&'()*+,;="
  result=$(URLCODE_INPUT="$input" URLCODE_SAFE="$safe_chars" python3 -c "
import urllib.parse, os
text = os.environ['URLCODE_INPUT']
safe = os.environ.get('URLCODE_SAFE', '')
print(urllib.parse.quote(text, safe=safe), end='')
")
else
  result=$(URLCODE_INPUT="$input" python3 -c "
import urllib.parse, os
text = os.environ['URLCODE_INPUT']
print(urllib.parse.unquote(text), end='')
")
fi

# Print result and copy to clipboard
printf '%s\n' "$result"
printf '%s' "$result" | pbcopy
printf '\033[32m✓ Copied to clipboard\033[0m\n' >&2
