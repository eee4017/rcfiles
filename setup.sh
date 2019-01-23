#!/bin/sh

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |       Frank Lin's .rcfile install script       | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\______________________________________________\\|"
echo ""

# install oh-my-zsh
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O /tmp/install.sh
sh /tmp/install.sh

# zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/peterhurford/up.zsh ~/.oh-my-zsh/custom/plugins/up

# copy rcfiles
cp vim/vimrc $HOME/.vimrc
cp zsh/zshrc $HOME/.zshrc
cp tmux/tmux.conf $HOME/.tmux.conf
