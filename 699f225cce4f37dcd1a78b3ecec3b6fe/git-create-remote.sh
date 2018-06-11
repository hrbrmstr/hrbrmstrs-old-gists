# This function will walk you through the creation of a remote repository on github 
# without wasting your precious time going to the website :)
# how:
#   - source it in your (bash|zsh)rc 
#   - change the alias at the bottom of the script to your needs
#   - call it, follow instructions... profit
function createRemoteGitRepository() {
  local RED='\033[0;31m'
  local NC='\033[0m' # No Color
  local GITHUB_USER=''
  local NAME=''
  local DESC=''
  local PRIVATE=false

  # get repository username REQUIRED
  while true; do
    read "GITHUB_USER?Write GitHub username (required): "
    if [[ ! -n $GITHUB_USER ]]; then
      printf "${RED}The github username can't be empty, try again${NC}\n"
      continue
    else
      break
    fi
  done

  # get repository name REQUIRED
  while true; do
    read "NAME?Write the repository name (required): "
    if [[ ! -n $NAME ]]; then
      printf "${RED}The name of the repository can't be empty, try again${NC}\n"
      continue
    else
      break
    fi
  done

  read "DESC?Write a description for the repo (optional): "

  while true; do
    read "PRIVATE?Is the repository private? (y/N): "
    case $PRIVATE in
      [Yy]* )
        PRIVATE=true
        break
        ;;
      [Nn]* )
        PRIVATE=false
        break
        ;;
      * ) printf "${RED}Please answer Y or N.${NC}\n";;
    esac
  done

  printf "\n"
  echo "Review your data"
  echo "________________"
  echo "username: $GITHUB_USER"
  echo "name: $NAME"
  echo "description: $DESC"
  echo "is private ripository? $PRIVATE"
  printf "\n"


  while true; do
    read "CONTINUE?Do you want to continue? (y/N): "
    case $CONTINUE in
        [Yy]* )
          echo "calling github api..."
          payload="{\"name\":\"$NAME\",\"description\":\"$DESC\",\"private\":$PRIVATE}"
          curl -u $GITHUB_USER https://api.github.com/user/repos -d "$payload"
          return true
          break
          ;;
        [Nn]* )
          echo "Bye"
          return false
          break
          ;;
        * ) printf "${RED}Please answer Y or N.${NC}\n";;
    esac
  done
}
alias git-remote-create='createRemoteGitRepository'