rc="source "$(pwd)"/run-control.sh"
echo $rc >> ~/.zshrc
echo $rc >> ~/.bash_profile

# Setup alias and add it to rc
echo "source ~/.alias.sh" >> ~/.zshrc
echo "source ~/.alias.sh" >> ~/.bash_profile

echo "source ~/.custom.sh" >> ~/.zshrc
echo "source ~/.custom.sh" >> ~/.bash_profile
