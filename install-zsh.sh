#!/bin/bash

# Atualiza a lista de pacotes disponíveis
sudo apt update

# Instala o zsh
sudo apt install zsh -y

# Verifica se a instalação foi bem-sucedida
if [ ! -f /bin/zsh ]; then
    echo "Erro: ZSH não foi instalado corretamente."
    exit 1
fi
echo "zsh foi instalado com sucesso!"

# Instala o Oh My Zsh sem alterar o shell padrão
echo "Instalando o Oh My Zsh..."
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Verifica se o Oh My Zsh foi instalado corretamente
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh não foi instalado corretamente. Verifique o processo de instalação."
    exit 1
fi
echo "Oh My Zsh instalado com sucesso!"

# Configuração do tema Spaceship
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/themes"
echo "Instalando o Spaceship Prompt..."
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Configura o .zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "$HOME/.zshrc"

# Configuração personalizada do Spaceship
cat <<EOT >> ~/.zshrc

# Configuração personalizada do Spaceship Prompt
SPACESHIP_PROMPT_ORDER=(
  user dir host git hg exec_time line_sep vi_mode jobs exit_code char
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
EOT

# Instala zsh-autosuggestions
mkdir -p "$ZSH_CUSTOM/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

# Configura plugins
if grep -q "plugins=" "$HOME/.zshrc"; then
    sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions)/' "$HOME/.zshrc"
else
    echo 'plugins=(git zsh-autosuggestions)' >> "$HOME/.zshrc"
fi

# Define o ZSH como shell padrão (AGORA NO FINAL, APÓS TODAS INSTALAÇÕES)
echo "Alterando o shell padrão para ZSH..."
sudo chsh -s /bin/zsh $USER

echo -e "\nConfiguração concluída com sucesso!"
echo "===================================="
echo "Para aplicar as alterações:"
echo "1. Feche TODOS os terminais abertos"
echo "2. Abra um novo terminal"
echo "3. Execute 'exec zsh' se necessário"
echo "===================================="
echo "Para verificar:"
echo "  echo \$SHELL       # Deve mostrar /bin/zsh"
echo "  ps -p \$\$          # Deve mostrar zsh na última coluna"
