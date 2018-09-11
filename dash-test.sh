test() {
  set -x

  FILE="white space"
  local _file=$FILE
  if [ "$FILE" != "$_file" ]; then 
    echo Shell failed.
    exit 1
  fi
}

test
