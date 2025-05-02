#!/bin/bash

# Atualiza a lista de pacotes disponíveis
sudo apt update

# Instala o zsh
sudo apt install zsh -y

# Verifica se a instalação foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "zsh foi instalado com sucesso!"
else
    echo "Houve um erro durante a instalação do zsh."
    exit 1
fi

# Instala o Oh My Zsh sem alterar o shell padrão
echo "Instalando o Oh My Zsh..."
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Verifica se o Oh My Zsh foi instalado corretamente
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh instalado com sucesso!"
else
    echo "Oh My Zsh não foi instalado corretamente. Verifique o processo de instalação."
    exit 1
fi

# Define o zsh como shell padrão manualmente
if [ -f /bin/zsh ]; then
    echo "Alterando o shell padrão para zsh..."
    chsh -s /bin/zsh
    echo "ZSH definido como shell padrão."
else
    echo "ZSH não foi encontrado. Verifique a instalação."
    exit 1
fi

# Cria o diretório de temas personalizados do Oh My Zsh, se não existir
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes" ]; then
    echo "Criando diretório de temas personalizados..."
    mkdir -p "$ZSH_CUSTOM/themes"
fi

# Instala o Spaceship Prompt
if [ -d "$ZSH_CUSTOM/themes" ]; then
    echo "Instalando o Spaceship Prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    echo "Spaceship Prompt instalado com sucesso!"
else
    echo "Diretório de temas do Oh My Zsh não encontrado. Verifique se o Oh My Zsh está instalado corretamente."
    exit 1
fi

# Configura o Spaceship Prompt como tema padrão
if [ -f "$HOME/.zshrc" ]; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "$HOME/.zshrc"
    echo "Spaceship Prompt configurado como tema padrão."
else
    echo "Arquivo .zshrc não encontrado. Verifique a instalação do Oh My Zsh."
    exit 1
fi

# Adiciona a configuração personalizada do Spaceship ao final do arquivo ~/.zshrc
echo "Adicionando configuração personalizada do Spaceship ao ~/.zshrc..."
cat <<EOT >> ~/.zshrc

# Configuração personalizada do Spaceship Prompt
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
EOT

# Cria o diretório de plugins personalizados do Oh My Zsh, se não existir
if [ ! -d "$ZSH_CUSTOM/plugins" ]; then
    echo "Criando diretório de plugins personalizados..."
    mkdir -p "$ZSH_CUSTOM/plugins"
fi

# Instala o zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins" ]; then
    echo "Instalando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    echo "zsh-autosuggestions instalado com sucesso!"
else
    echo "Diretório de plugins do Oh My Zsh não encontrado. Verifique se o Oh My Zsh está instalado corretamente."
    exit 1
fi

# Adiciona o zsh-autosuggestions aos plugins no arquivo ~/.zshrc
if [ -f "$HOME/.zshrc" ]; then
    if grep -q "plugins=" "$HOME/.zshrc"; then
        # Se a linha de plugins já existe, adiciona zsh-autosuggestions
        sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions)/' "$HOME/.zshrc"
    else
        # Se a linha de plugins não existe, cria uma nova
        echo 'plugins=(git zsh-autosuggestions)' >> "$HOME/.zshrc"
    fi
    echo "zsh-autosuggestions adicionado aos plugins no ~/.zshrc."
else
    echo "Arquivo .zshrc não encontrado. Verifique a instalação do Oh My Zsh."
    exit 1
fi

echo "Configuração concluída! Reinicie o terminal para aplicar as alterações."
# Verifica se o ZSH foi instalado corretamente
if [ -f /bin/zsh ]; then
    echo "ZSH instalado com sucesso!"
else
    echo "Erro: ZSH não foi instalado corretamente."
    exit 1
fi

# Define o ZSH como shell padrão
echo "Alterando o shell padrão para ZSH..."
chsh -s /bin/zsh

# Verifica se a alteração foi bem-sucedida
if [ "$(echo $SHELL)" = "/bin/zsh" ]; then
    echo "ZSH definido como shell padrão com sucesso!"
else
    echo "Erro: Não foi possível definir o ZSH como shell padrão."
    exit 1
fi

echo "Reinicie o terminal para aplicar as alterações."
