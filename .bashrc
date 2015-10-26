
export LANG="en_US.utf8"
export TERM="xterm-256color"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
alias meteor-create='project_name=`basename ${PWD}` && meteor create ${project_name} && mv ${project_name}/{*,.*} ./ && rmdir ${project_name}'

digx () {
  echo "-> $(dig +short -x $(dig +short ${1}))"
}

getRandomArticle () {
  echo -n $(curl -sL https://en.wikipedia.org/wiki/Special:Random | grep '<h1' | cut -d ">" -f 2 | cut -d "<" -f 1 | cut -d " " -f 1)
}

genPasswd () {
  length=${1-4}
  x=0
  while (( ${length} > ${x} )); do
    getRandomArticle
    x=$(( ${x} + 1 ))
  done
  echo ""
}

