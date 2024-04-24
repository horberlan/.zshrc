# Use powerline
USE_POWERLINE="true"

# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

#load env to run tte
alias lff="sh ~/.config/lf/lf-run.sh"

source envname/bin/activate

#log username
get_joke() {
  local response=$(curl --silent --location 'https://official-joke-api.appspot.com/random_joke')
  local setup=$(echo "$response" | jq -r '.setup')
  local punchline=$(echo "$response" | jq -r '.punchline')

  echo "$setup" | tte rain
  echo "... $punchline" | tte print
}

history_file="$HOME/.zhistory"

# here i conditionate a console log: if is the first terminal zsh of the day, run a figlet ASCII and tte (https://github.com/ChrisBuilds/terminaltexteffects), otherwise run a simple joke to make it mor happy

if [ -f "$history_file" ]; then
  last_modified=$(stat -c %Y "$history_file")
  today=$(date +%s)
  start_of_day=$(date -d 'today 00:00:00' +%s)

  if [ "$last_modified" -lt "$start_of_day" ]; then
    figlet -f /usr/share/figlet/fonts/Bloody "Welcome, $USER%" | tte decrypt --typing-speed 800 --ciphertext-colors 008000 00cb00 00ff00 --final-gradient-stops 00cb00 --final-gradient-steps 10 --final-gradient-direction vertical &
    disown
  else
    get_joke &
    disown
  fi
else
  echo "history file not found."
fi

