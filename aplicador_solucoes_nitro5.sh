### ARQUIVO: aplicador_solucoes_nitro5.sh ###
==================================================

# DESCRIÇÃO
# Um script multifuncional que aplica um conjunto de correções específicas para o notebook Acer Nitro 5 rodando Linux.
# As correções incluem: ajuste de permissões de brilho, criação de uma entrada de boot para o Windows, modificação de parâmetros do kernel para corrigir portas USB e a instalação/configuração do Spicetify para o Spotify.
# É um "kit de primeiros socorros" para problemas comuns neste modelo de hardware.

# COMENTÁRIOS
#1: Garante que o script pare imediatamente se algum comando falhar.
#2: Encontra o caminho do dispositivo de controle de brilho e ajusta suas permissões para permitir que o usuário o modifique sem 'sudo'.
#3: Define o brilho para um valor padrão (300) ao executar o script.
#4: Verifica se uma entrada de boot para o Windows já existe no systemd-boot.
#5: Se não existir, cria o arquivo de configuração, adiciona o título e o caminho para o bootloader do Windows.
#6: Atualiza o systemd-boot para que ele reconheça a nova entrada.
#7: Procura pela linha de parâmetros padrão do kernel no arquivo de configuração do GRUB.
#8: Substitui a linha padrão, adicionando 'usbcore.autosuspend=-1' (desativa o auto-suspend das USBs, corrigindo problemas de desconexão) e 'iommu=soft' (melhora a compatibilidade de virtualização de hardware).
#9: Atualiza a configuração do GRUB para aplicar as mudanças.
#10: Corrige as permissões da pasta de instalação do Spotify para permitir que ferramentas como o Spicetify modifiquem seus arquivos.
#11: Aplica a configuração do Spicetify.
#12: Clona os repositórios de temas (Catppuccin/Sleek e Dracula) para o Spicetify, caso ainda não existam.
#13: Define o tema atual e aplica as mudanças, estilizando o cliente Spotify.
#14: Fornece um resumo final das ações e lembra o usuário de reiniciar.

# CÓDIGO
#!/bin/bash
#1
set -e

echo "[1/4] Ajustando controle de brilho da tela..."
#2
BRIGHT_PATH=$(ls /sys/class/backlight | head -n1)
if [[ -n "$BRIGHT_PATH" ]]; then
    sudo chmod a+w "/sys/class/backlight/$BRIGHT_PATH/brightness"
    #3
    echo 300 | sudo tee "/sys/class/backlight/$BRIGHT_PATH/brightness" > /dev/null
    echo "Permissões de brilho ajustadas para /sys/class/backlight/$BRIGHT_PATH"
else
    echo "Aviso: Nenhum dispositivo de controle de brilho detectado."
fi

echo -e "\n[2/4] Adicionando entrada UEFI do Windows no systemd-boot..."
WINDOWS_ENTRY=/boot/efi/loader/entries/windows.conf
#4
if [[ ! -f "$WINDOWS_ENTRY" ]]; then
    #5
    echo "title Windows" | sudo tee "$WINDOWS_ENTRY" > /dev/null
    echo "efi /EFI/Microsoft/Boot/bootmgfw.efi" | sudo tee -a "$WINDOWS_ENTRY" > /dev/null
    #6
    sudo bootctl update
    echo "Entrada de boot para o Windows criada com sucesso."
else
    echo "Entrada de boot para o Windows já existente."
fi

echo -e "\n[3/4] Ajustando parâmetros do kernel para correção de USB..."
GRUB_FILE="/etc/default/grub"
#7
if grep -q "quiet splash" "$GRUB_FILE"; then
    #8
    sudo sed -i 's/quiet splash/quiet splash usbcore.autosuspend=-1 iommu=soft/' "$GRUB_FILE"
    #9
    sudo update-grub
    echo "Parâmetros do kernel ajustados. Reinicie para aplicar."
else
    echo "Aviso: Padrão 'quiet splash' não encontrado em $GRUB_FILE para edição."
fi

echo -e "\n[4/4] Corrigindo e estilizando Spotify com Spicetify..."
#10
sudo chmod -R a+wr /usr/share/spotify /usr/share/spotify/Apps > /dev/null 2>&1 || echo "Aviso: Não foi possível alterar permissões do Spotify (talvez não esteja instalado)."
#11
spicetify backup apply > /dev/null 2>&1 || echo "Aviso: Falha ao aplicar configurações do Spicetify."
#12
mkdir -p ~/.config/spicetify/Themes
(cd ~/.config/spicetify/Themes && [[ ! -d "Sleek" ]] && git clone https://github.com/catppuccin/spicetify.git Sleek)
(cd ~/.config/spicetify/Themes && [[ ! -d "Dracula" ]] && git clone https://github.com/morpheusthewhite/spicetify-dracula-theme.git Dracula)
#13
spicetify config current_theme Dracula > /dev/null
spicetify apply > /dev/null
echo "Spicetify configurado com o tema Dracula."

#14
echo -e "\nProcesso concluído. Reinicie o sistema para aplicar todas as mudanças."

# CITAÇÃO
# "A experiência não é o que acontece com um homem; é o que um homem faz com o que lhe acontece." - Aldous Huxley


==================================================
### ARQUIVO: aplicador_solucoes_nitro5.sh ###
==================================================

# DESCRIÇÃO
# Um script multifuncional que aplica um conjunto de correções específicas para o notebook Acer Nitro 5 rodando Linux.
# As correções incluem: ajuste de permissões de brilho, criação de uma entrada de boot para o Windows, modificação de parâmetros do kernel para corrigir portas USB e a instalação/configuração do Spicetify para o Spotify.
# É um "kit de primeiros socorros" para problemas comuns neste modelo de hardware.

# COMENTÁRIOS
#1: Garante que o script pare imediatamente se algum comando falhar.
#2: Encontra o caminho do dispositivo de controle de brilho e ajusta suas permissões para permitir que o usuário o modifique sem 'sudo'.
#3: Define o brilho para um valor padrão (300) ao executar o script.
#4: Verifica se uma entrada de boot para o Windows já existe no systemd-boot.
#5: Se não existir, cria o arquivo de configuração, adiciona o título e o caminho para o bootloader do Windows.
#6: Atualiza o systemd-boot para que ele reconheça a nova entrada.
#7: Procura pela linha de parâmetros padrão do kernel no arquivo de configuração do GRUB.
#8: Substitui a linha padrão, adicionando 'usbcore.autosuspend=-1' (desativa o auto-suspend das USBs, corrigindo problemas de desconexão) e 'iommu=soft' (melhora a compatibilidade de virtualização de hardware).
#9: Atualiza a configuração do GRUB para aplicar as mudanças.
#10: Corrige as permissões da pasta de instalação do Spotify para permitir que ferramentas como o Spicetify modifiquem seus arquivos.
#11: Aplica a configuração do Spicetify.
#12: Clona os repositórios de temas (Catppuccin/Sleek e Dracula) para o Spicetify, caso ainda não existam.
#13: Define o tema atual e aplica as mudanças, estilizando o cliente Spotify.
#14: Fornece um resumo final das ações e lembra o usuário de reiniciar.

# CÓDIGO
#!/bin/bash
#1
set -e

echo "[1/4] Ajustando controle de brilho da tela..."
#2
BRIGHT_PATH=$(ls /sys/class/backlight | head -n1)
if [[ -n "$BRIGHT_PATH" ]]; then
    sudo chmod a+w "/sys/class/backlight/$BRIGHT_PATH/brightness"
    #3
    echo 300 | sudo tee "/sys/class/backlight/$BRIGHT_PATH/brightness" > /dev/null
    echo "Permissões de brilho ajustadas para /sys/class/backlight/$BRIGHT_PATH"
else
    echo "Aviso: Nenhum dispositivo de controle de brilho detectado."
fi

echo -e "\n[2/4] Adicionando entrada UEFI do Windows no systemd-boot..."
WINDOWS_ENTRY=/boot/efi/loader/entries/windows.conf
#4
if [[ ! -f "$WINDOWS_ENTRY" ]]; then
    #5
    echo "title Windows" | sudo tee "$WINDOWS_ENTRY" > /dev/null
    echo "efi /EFI/Microsoft/Boot/bootmgfw.efi" | sudo tee -a "$WINDOWS_ENTRY" > /dev/null
    #6
    sudo bootctl update
    echo "Entrada de boot para o Windows criada com sucesso."
else
    echo "Entrada de boot para o Windows já existente."
fi

echo -e "\n[3/4] Ajustando parâmetros do kernel para correção de USB..."
GRUB_FILE="/etc/default/grub"
#7
if grep -q "quiet splash" "$GRUB_FILE"; then
    #8
    sudo sed -i 's/quiet splash/quiet splash usbcore.autosuspend=-1 iommu=soft/' "$GRUB_FILE"
    #9
    sudo update-grub
    echo "Parâmetros do kernel ajustados. Reinicie para aplicar."
else
    echo "Aviso: Padrão 'quiet splash' não encontrado em $GRUB_FILE para edição."
fi

echo -e "\n[4/4] Corrigindo e estilizando Spotify com Spicetify..."
#10
sudo chmod -R a+wr /usr/share/spotify /usr/share/spotify/Apps > /dev/null 2>&1 || echo "Aviso: Não foi possível alterar permissões do Spotify (talvez não esteja instalado)."
#11
spicetify backup apply > /dev/null 2>&1 || echo "Aviso: Falha ao aplicar configurações do Spicetify."
#12
mkdir -p ~/.config/spicetify/Themes
(cd ~/.config/spicetify/Themes && [[ ! -d "Sleek" ]] && git clone https://github.com/catppuccin/spicetify.git Sleek)
(cd ~/.config/spicetify/Themes && [[ ! -d "Dracula" ]] && git clone https://github.com/morpheusthewhite/spicetify-dracula-theme.git Dracula)
#13
spicetify config current_theme Dracula > /dev/null
spicetify apply > /dev/null
echo "Spicetify configurado com o tema Dracula."

#14
echo -e "\nProcesso concluído. Reinicie o sistema para aplicar todas as mudanças."

# CITAÇÃO
# "A experiência não é o que acontece com um homem; é o que um homem faz com o que lhe acontece." - Aldous Huxley


==================================================
