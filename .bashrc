export LANG="en_US.utf8"
export TERM="xterm-256color"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
alias meteor-create='project_name=`basename ${PWD}` && meteor create ${project_name} && mv ${project_name}/{*,.*} ./ && rmdir ${project_name}'

alias ll="ls -lah"

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

#!/bin/bash

list_instances () {
  local insts="$(echo /data/vhosts/*/*/*/htdocs)"
  if [[ ${insts} == "/data/vhosts/*/*/*/htdocs" ]]; then
    insts="$(echo /data/vhosts/*/*/htdocs)"
  fi
  echo ${insts}
}

get_instance_fqdn () {
  echo $(echo ${1} | cut -d '/' -f 4,5,6 | tr '/' ${2:-'-'})
}

get_server_names () {
  echo $(grep "ServerName\|ServerAlias" ${1} | grep -viE ^# | awk '{$1=""; print $0}'| sed 's/^\s//' | sed -r 's/\s+/\n/g' | cut -d: -f1)
}

digx () {
  if $(is_ip ${1}); then
    local ip=${1}
  else
    local ip=$(dig +short ${1} | tail -n 1)
  fi
  dig +short -x ${ip}
}

is_ip () {
  if [[ ${1} =~ [[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+ ]]; then
    exit 0
  fi
  exit 1
}

get_last_server () {
  local names=($(get_server_names ${1}))
  echo ${names[-1]}
}

get_typo_version () {
  echo $(readlink ${1}/typo3_src | cut -d '/' -f 4,5)
}

display_table () {
  local n=0
  local m=4
  for arg in ${*}; do
    if [[ ${arg} =~ ^[0-9]+$ ]]; then
      m=${arg}
    else
      n=$(( ${n} + ${m} ))
      echo -n ${arg}
      echo -n $'\r'
      for x in $( seq 0 ${n} ); do
        echo -n $'\t'
      done
      echo -n " | "
    fi
  done
  echo ""
}

get_instance_dir () {
  local subdomain=`echo $1 | rev | cut -d. -f3- | rev`
  local domain=`echo $1 | rev | cut -d. -f2 | rev`
  local tld=`echo $1 | rev | cut -d. -f1 | rev`
  echo "/data/vhosts/${domain}/${tld}/${subdomain}/htdocs"
}

clear_cache () {
  inst=${1}
  if [[ ! ${inst} ]]; then
    inst=.
  elif [ ! -d ${inst} ]; then
    inst=$(get_instance_dir ${inst})
  fi
  cli_dispatch "som_clear_cache" ${inst}
}

cli_dispatch () {
  if [[ ${2} ]]; then
    cd ${2}
  fi
  sudo -u $(stat -c %U .) bash -c "${2-$(pwd)}/typo3/cli_dispatch.phpsh ${1}"
}

mark_status () {
  if (( ${1} > 399 )); then
    echo -e "\033[91m\033[4m${1}\033[0m";
  elif (( ${1} > 200 )); then
    echo -e "\033[93m${1}\033[0m"
  else
    echo -e "\033[32m${1}\033[0m";
  fi
}

host_status () {
  local x="$(curl -Lsw "%{http_code}" ${1})"
  echo "$(mark_status ${x: -3:3})"
}

# is_typo_instance -> path_to_htdocs -> exit
is_typo_instance () {
  if [[ $(get_typo_version ${1}) ]]; then
    exit 0
  else
    exit 1
  fi
}

fancy_list () {
  for inst in $(list_instances); do
    name="$(get_instance_fqdn ${inst})"
    if [ -f /etc/apache2/sites-enabled/${name}.conf ]; then
      typo_version="$(get_typo_version ${inst})"
      server=$(get_last_server /etc/apache2/sites-enabled/${name}.conf)

      display_table \
        3 "${name:-_}" \
        4 "${server:-_}" \
        3 "${typo_version:-_}" \
        1 "$(host_status ${server})"
    fi
  done
}

update_typo () {
  inst="$(get_instance_dir ${1})"
  cd ${inst} && rm typo3_src && ln -s /data/typo3_repository/${2} typo3_src
  clear_cache
}

clear_all_caches () {
  for inst in $(list_instances); do
    if $(is_typo_instance ${inst}); then
      clear_cache ${inst}
    fi
  done
}

install_ext () {
  cd $(get_instance_dir ${1}) && \
  cli_dispatch "extbase extension:install ${2}"
}

install_ext_all () {
  for inst in $(list_instances); do
    if $(is_typo_instance ${inst}); then
      cli_dispatch "extbase extension:install ${1}" ${inst}
    fi
  done
}

# exec_on_servers -> servers -> command -> void
exec_on_servers () {
  for server in ${1}; do
    echo "Executing on ${server}"
    exec_on_server ${server} "${2}"
  done
}

# sssh server command -> void
sssh () {
  if (( ${#passswd} < 1 )); then
    echo "I need a password!"
    read -s passswd
  fi
  ssh ${1} "echo '${passswd}' | sudo -S ${2}"
}

# exec_on_servers -> server -> command -> void
exec_on_server () {
  sssh ${1} "${2}"
}

# check_dns -> list_of_apache_confs
check_dns () {
  for conf in ${*}; do
    for name in $(get_server_names ${conf}); do
      if $(is_ip ${name}); then
        local ip="${name}"
      else
        local ip="$(dig +short ${name})"
      fi
      local resolve="$(dig +short -x ${ip} 2> /dev/null)"
      display_table \
        3 "${name:-_}" \
        3 "${resolve:-${ip}}" \
        1 "$(host_status ${name})"
    done
  done
}

if [[ "list" == $1 ]]; then
  fancy_list
fi

# update_typo -> domain -> version -> void
if [[ "update_typo" == $1 ]]; then
  update_typo ${2} ${3}
fi

# clear_cache -> domain
if [[ "clear" == $1 ]]; then
  clear_cache ${2}
fi

if [[ "clear_all" == $1 ]]; then
  clear_all_caches
fi

# install_ext instance_url ext_name -> void
if [[ "install_ext" == $1 ]]; then
  install_ext ${2} ${3}
fi

# install_ext_all ext_name -> void
if [[ "install_ext_all" == $1 ]]; then
  install_ext_all ${2}
fi

if [[ "exec_on_servers" == $1 ]]; then
  exec_on_servers "${2}" "${3}"
fi




