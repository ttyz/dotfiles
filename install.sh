#/bin/bash +x
# dotfiles install script
self=$(dirname $0)

command -v ansible-playbook >/dev/null 2>&1 || {
    echo >&2 "Installing ansible"
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible
}

ansible-playbook -K ${self}/ansible/local.yml

# install composer tools

if [ ! -d ${HOME}/.composer ]; then
	mkdir ${HOME}/.composer
fi

ln -svf $(realpath ${self}/composer)/* ${HOME}/.composer
composer global install

# install python tools
ln -svf $(realpath ${self}/pypack.txt) ${HOME}/.config
cat ${self}/pypack.txt | xargs -n1 pipsi install

# install .config
if [ ! -d ${HOME}/.config ]; then
	mkdir ${HOME}/.config
fi

#install tmux plugins
if [ -d ${HOME}/.tmux ]; then
	echo Removing ${HOME}/.tmux
	rm -rf ${HOME}/.tmux
fi
ln -sfv $(pwd)/tmux ${HOME}/.tmux

for file in $(ls ${self}/config/); do
	ln -sf $(realpath ${self}/config/${file}) ${HOME}/.config
done

# Link the inputrc
ln -sfv $(pwd)/inputrc ${HOME}/.inputrc

# Link the bashrc
ln -sfv $(pwd)/bashrc ${HOME}/.bashrc

# Link the tmux config
ln -sfv $(pwd)/tmux.conf ${HOME}/.tmux.conf

# Link the wget config
ln -sfv $(pwd)/wgetrc ${HOME}/.wgetrc
