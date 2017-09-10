#Psql 
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

#Docker
source ~/.docker_aliases

#Codacy Aliases
alias jmp-db='/Users/dreigada/Workspace/codacy-scripts/dbs/srv_db.sh $@'
alias ds='while true; do TEXT=$(docker stats --no-stream $(docker ps --format="{{.Names}}")); sleep 0.1; clear; echo "$TEXT"; done'
alias jump='~/Workspace/codacy-scripts/network.sh'
alias inv='~/Workspace/codacy-scripts/inventory/servers.py'


#My Aliases
alias editBashrc='vim ~/.dreigadarc/shells/sources/dreigada.sh'
alias sshRouter='ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss -c 3des-cbc meo@192.168.1.254'
alias brewu='brew update && brew upgrade && brew cleanup && brew cask cleanup && brew prune && brew doctor'
