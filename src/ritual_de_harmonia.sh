#!/bin/bash

#
#   Script para unificar a aparência do Pop!_OS (Nativo e Flatpak)
#   e resolver conflitos de atalho para aplicativos como Ulauncher.
#
#   Para usar:
#   1. Altere as variáveis na seção #2 com os nomes dos seus temas.
#   2. Salve o arquivo (ex: ritual_harmonia.sh).
#   3. Dê permissão de execução: chmod +x ritual_harmonia.sh
#   4. Execute: ./ritual_harmonia.sh

# 2
GTK_THEME="Lavanda-Dark"
CURSOR_THEME="Bibata-Modern-Ice"
ICON_THEME="Numix-Roxo"
SHELL_THEME="Lavanda-Dark" 

# 3
set -e
echo "🔮 Iniciando o Ritual de Harmonia e Liberação..."
echo "----------------------------------------------------"

# 4
echo "📰 Movendo temas para os diretórios públicos do sistema..."
if [ -d "$HOME/.themes/$GTK_THEME" ]; then
    sudo cp -r "$HOME/.themes/$GTK_THEME" /usr/share/themes/
    echo "✔️ Tema de interface '$GTK_THEME' tornado público."
else
    echo "⚠️  Aviso: Tema '$GTK_THEME' não encontrado em ~/.themes. Pulando cópia."
fi
if [ -d "$HOME/.icons/$CURSOR_THEME" ]; then
    sudo cp -r "$HOME/.icons/$CURSOR_THEME" /usr/share/icons/
    echo "✔️ Tema de cursor '$CURSOR_THEME' tornado público."
else
    echo "⚠️  Aviso: Tema de cursor '$CURSOR_THEME' não encontrado em ~/.icons. Pulando cópia."
fi
if [ -d "$HOME/.icons/$ICON_THEME" ]; then
    sudo cp -r "$HOME/.icons/$ICON_THEME" /usr/share/icons/
    echo "✔️ Tema de ícones '$ICON_THEME' tornado público."
else
    echo "⚠️  Aviso: Tema de ícones '$ICON_THEME' não encontrado em ~/.icons. Pulando cópia."
fi

# 5
echo "👑 Decretando a nova aparência para o sistema nativo..."
gsettings set org.gnome.desktop.interface gtk-theme "'$GTK_THEME'"
gsettings set org.gnome.desktop.interface cursor-theme "'$CURSOR_THEME'"
gsettings set org.gnome.desktop.interface icon-theme "'$ICON_THEME'"
gsettings set org.gnome.shell.extensions.user-theme name "'$SHELL_THEME'"
echo "✔️ Aparência nativa unificada."

# 6
echo "⛓️  Forçando os reclusos Flatpaks a adotarem a nova aparência..."
sudo flatpak override --system --filesystem=/usr/share/icons
flatpak override --user --filesystem=/usr/share/icons
sudo flatpak override --system --filesystem=/usr/share/themes
flatpak override --user --filesystem=/usr/share/themes
echo "✔️ Permissões de sistema de arquivos para Flatpaks concedidas."
sudo flatpak override --system --env=GTK_THEME="$GTK_THEME"
flatpak override --user --env=GTK_THEME="$GTK_THEME"
sudo flatpak override --system --env=XCURSOR_THEME="$CURSOR_THEME"
flatpak override --user --env=XCURSOR_THEME="$CURSOR_THEME"
sudo flatpak override --system --env=ICON_THEME="$ICON_THEME"
flatpak override --user --env=ICON_THEME="$ICON_THEME"
echo "✔️ Temas aplicados à força nos Flatpaks."

# 7
# ---  do Atalho do Ulauncher ---
echo "🔑 Resolvendo o conflito de atalhos para o Ulauncher..."
gsettings set org.gnome.mutter overlay-key "'<Control><Super>x'"
echo "✔️ Atalho nativo realocado para 'Ctrl+Super+X'. O caminho está livre."

# 8
echo "----------------------------------------------------"
echo "✅ Ritual concluído com sucesso!"
echo "Para que tudo tenha efeito:"
echo "1. Reinicie seus aplicativos Flatpak abertos."
echo "2. FAÇA LOGOUT E LOGIN na sua sessão para que o atalho seja liberado."
echo "----------------------------------------------------"
