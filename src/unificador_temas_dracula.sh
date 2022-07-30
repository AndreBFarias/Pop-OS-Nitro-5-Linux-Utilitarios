### ARQUIVO: unificador_temas_dracula.sh ###
==================================================

# DESCRIÇÃO
# Este script automatiza o processo de unificação de um tema visual (neste caso, Dracula) em todo o sistema, incluindo aplicações Flatpak.
# Ele copia os temas (ícones, cursores, GTK) de um diretório local do usuário para um diretório de sistema, tornando-os disponíveis para todos os usuários.
# Em seguida, aplica essas configurações via gsettings para aplicações nativas e usa overrides do Flatpak para forçar o tema em aplicações isoladas.

# COMENTÁRIOS
#1: Garante que o script pare se houver algum erro.
#2: Copia o tema de cursor do diretório do usuário para o diretório de sistema /usr/share/icons, se ele existir.
#3: Faz o mesmo para o tema de ícones.
#4: Faz o mesmo para o tema de interface GTK, copiando para /usr/share/themes.
#5: Usa o comando 'gsettings' para definir o tema de cursor, ícones e GTK para as aplicações nativas do GNOME.
#6: Concede permissão para que as aplicações Flatpak (tanto as de usuário quanto as de sistema) acessem os diretórios de temas do sistema.
#7: Define variáveis de ambiente para o Flatpak, forçando o uso do tema especificado para cursores, ícones e GTK em todas as aplicações Flatpak.
#8: Cria uma cópia local do atalho do LibreOffice Start Center e adiciona a linha 'NoDisplay=true' para ocultá-lo do menu de aplicativos, uma preferência de organização visual.
#9: Informa ao usuário que o processo foi concluído e que um reinício de sessão pode ser necessário.

# CÓDIGO
#!/bin/bash
#1
set -e

echo "Iniciando processo de unificação de temas visuais..."
echo "----------------------------------------------------"

echo "Disponibilizando temas para todo o sistema..."
#2
if [ -d "$HOME/.icons/Dracula-cursors" ]; then
    sudo cp -r "$HOME/.icons/Dracula-cursors" /usr/share/icons/
    echo "Tema de cursor 'Dracula-cursors' copiado para o sistema."
fi
#3
if [ -d "$HOME/.icons/DraculaCustom" ]; then
    sudo cp -r "$HOME/.icons/DraculaCustom" /usr/share/icons/
    echo "Tema de ícones 'DraculaCustom' copiado para o sistema."
fi
#4
if [ -d "$HOME/.themes/Dracula-standard-buttons" ]; then
    sudo cp -r "$HOME/.themes/Dracula-standard-buttons" /usr/share/themes/
    echo "Tema de interface 'Dracula-standard-buttons' copiado para o sistema."
fi
echo "----------------------------------------------------"

echo "Aplicando tema para aplicações nativas (gsettings)..."
#5
gsettings set org.gnome.desktop.interface cursor-theme 'Dracula-cursors'
gsettings set org.gnome.desktop.interface icon-theme 'DraculaCustom'
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula-standard-buttons'
echo "----------------------------------------------------"

echo "Aplicando tema para aplicações isoladas (Flatpak)..."
#6
sudo flatpak override --system --filesystem=/usr/share/icons
flatpak override --user --filesystem=/usr/share/icons
sudo flatpak override --system --filesystem=/usr/share/themes
flatpak override --user --filesystem=/usr/share/themes
#7
sudo flatpak override --system --env=XCURSOR_THEME=Dracula-cursors
flatpak override --user --env=XCURSOR_THEME=Dracula-cursors
sudo flatpak override --system --env=ICON_THEME=DraculaCustom
flatpak override --user --env=ICON_THEME=DraculaCustom
sudo flatpak override --system --env=GTK_THEME=Dracula-standard-buttons
flatpak override --user --env=GTK_THEME=Dracula-standard-buttons
echo "----------------------------------------------------"

echo "Ocultando ícone do LibreOffice Start Center..."
#8
mkdir -p "$HOME/.local/share/applications"
if [ -f "/usr/share/applications/libreoffice-startcenter.desktop" ]; then
    cp /usr/share/applications/libreoffice-startcenter.desktop "$HOME/.local/share/applications/"
    echo "NoDisplay=true" >> "$HOME/.local/share/applications/libreoffice-startcenter.desktop"
    echo "Atalho do LibreOffice oculto do menu de aplicações."
fi
echo "----------------------------------------------------"
#9
echo "Processo de unificação concluído."
echo "Reinicie aplicações abertas (especialmente Flatpaks) para ver o efeito."

# CITAÇÃO
# "A beleza é a harmonia entre o propósito e a forma." - Alvar Aalto


==================================================
### ARQUIVO: unificador_temas_dracula.sh ###
==================================================

# DESCRIÇÃO
# Este script automatiza o processo de unificação de um tema visual (neste caso, Dracula) em todo o sistema, incluindo aplicações Flatpak.
# Ele copia os temas (ícones, cursores, GTK) de um diretório local do usuário para um diretório de sistema, tornando-os disponíveis para todos os usuários.
# Em seguida, aplica essas configurações via gsettings para aplicações nativas e usa overrides do Flatpak para forçar o tema em aplicações isoladas.

# COMENTÁRIOS
#1: Garante que o script pare se houver algum erro.
#2: Copia o tema de cursor do diretório do usuário para o diretório de sistema /usr/share/icons, se ele existir.
#3: Faz o mesmo para o tema de ícones.
#4: Faz o mesmo para o tema de interface GTK, copiando para /usr/share/themes.
#5: Usa o comando 'gsettings' para definir o tema de cursor, ícones e GTK para as aplicações nativas do GNOME.
#6: Concede permissão para que as aplicações Flatpak (tanto as de usuário quanto as de sistema) acessem os diretórios de temas do sistema.
#7: Define variáveis de ambiente para o Flatpak, forçando o uso do tema especificado para cursores, ícones e GTK em todas as aplicações Flatpak.
#8: Cria uma cópia local do atalho do LibreOffice Start Center e adiciona a linha 'NoDisplay=true' para ocultá-lo do menu de aplicativos, uma preferência de organização visual.
#9: Informa ao usuário que o processo foi concluído e que um reinício de sessão pode ser necessário.

# CÓDIGO
#!/bin/bash
#1
set -e

echo "Iniciando processo de unificação de temas visuais..."
echo "----------------------------------------------------"

echo "Disponibilizando temas para todo o sistema..."
#2
if [ -d "$HOME/.icons/Dracula-cursors" ]; then
    sudo cp -r "$HOME/.icons/Dracula-cursors" /usr/share/icons/
    echo "Tema de cursor 'Dracula-cursors' copiado para o sistema."
fi
#3
if [ -d "$HOME/.icons/DraculaCustom" ]; then
    sudo cp -r "$HOME/.icons/DraculaCustom" /usr/share/icons/
    echo "Tema de ícones 'DraculaCustom' copiado para o sistema."
fi
#4
if [ -d "$HOME/.themes/Dracula-standard-buttons" ]; then
    sudo cp -r "$HOME/.themes/Dracula-standard-buttons" /usr/share/themes/
    echo "Tema de interface 'Dracula-standard-buttons' copiado para o sistema."
fi
echo "----------------------------------------------------"

echo "Aplicando tema para aplicações nativas (gsettings)..."
#5
gsettings set org.gnome.desktop.interface cursor-theme 'Dracula-cursors'
gsettings set org.gnome.desktop.interface icon-theme 'DraculaCustom'
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula-standard-buttons'
echo "----------------------------------------------------"

echo "Aplicando tema para aplicações isoladas (Flatpak)..."
#6
sudo flatpak override --system --filesystem=/usr/share/icons
flatpak override --user --filesystem=/usr/share/icons
sudo flatpak override --system --filesystem=/usr/share/themes
flatpak override --user --filesystem=/usr/share/themes
#7
sudo flatpak override --system --env=XCURSOR_THEME=Dracula-cursors
flatpak override --user --env=XCURSOR_THEME=Dracula-cursors
sudo flatpak override --system --env=ICON_THEME=DraculaCustom
flatpak override --user --env=ICON_THEME=DraculaCustom
sudo flatpak override --system --env=GTK_THEME=Dracula-standard-buttons
flatpak override --user --env=GTK_THEME=Dracula-standard-buttons
echo "----------------------------------------------------"

echo "Ocultando ícone do LibreOffice Start Center..."
#8
mkdir -p "$HOME/.local/share/applications"
if [ -f "/usr/share/applications/libreoffice-startcenter.desktop" ]; then
    cp /usr/share/applications/libreoffice-startcenter.desktop "$HOME/.local/share/applications/"
    echo "NoDisplay=true" >> "$HOME/.local/share/applications/libreoffice-startcenter.desktop"
    echo "Atalho do LibreOffice oculto do menu de aplicações."
fi
echo "----------------------------------------------------"
#9
echo "Processo de unificação concluído."
echo "Reinicie aplicações abertas (especialmente Flatpaks) para ver o efeito."

# CITAÇÃO
# "A beleza é a harmonia entre o propósito e a forma." - Alvar Aalto


==================================================
