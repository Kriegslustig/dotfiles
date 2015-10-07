
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
alias meteor-create='project_name=`basename ${PWD}` && meteor create ${project_name} && mv ${project_name}/{*,.*} ./ && rmdir ${project_name}'
