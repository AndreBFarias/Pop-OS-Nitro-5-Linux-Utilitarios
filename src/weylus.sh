#!/bin/bash

# Este é o Grimório Digital que automatiza a configuração do Tablet-PC
# Apenas a lógica, sem os comentários explicativos.

C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_NC='\033[0m'

function print_msg() {
  local color=$1
  local message=$2
  echo -e "${color}${message}${C_NC}"
}

set -e

print_msg $C_BLUE "========================================================"
print_msg $C_BLUE "  Iniciando o Ritual de Integração Tablet-PC...         "
print_msg $C_BLUE "========================================================"
sleep 2

#1
print_msg $C_YELLOW "\n[PASSO 1/5] Preparando o altar: atualizando o sistema e instalando dependências..."
sudo apt update
sudo apt install -y android-tools-adb curl wget libdbus-1-dev gettext libgtksourceview-4-dev python3-pydantic
print_msg $C_GREEN "[PASSO 1/5] Altar preparado com sucesso."
sleep 1

#2
print_msg $C_YELLOW "\n[PASSO 2/5] Forjando o portal: buscando o Weylus..."
WEYLUS_URL="https://github.com/H-M-H/Weylus/releases/download/v0.11.4/Weylus_0.11.4_amd64.deb"
print_msg $C_BLUE "Baixando Weylus de: $WEYLUS_URL"
wget -q --show-progress -O weylus_latest.deb "$WEYLUS_URL"
print_msg $C_YELLOW "Instalando Weylus..."
sudo dpkg -i weylus_latest.deb
print_msg $C_GREEN "[PASSO 2/5] Portal Weylus forjado com sucesso."
sleep 1

#3
print_msg $C_YELLOW "\n[PASSO 3/5] Criando o intérprete: buscando o Input Remapper..."
REMAPPER_URL="https://github.com/sezanzeb/input-remapper/releases/download/2.1.1/input-remapper-2.1.1.deb"
print_msg $C_BLUE "Baixando Input Remapper de: $REMAPPER_URL"
wget -q --show-progress -O input-remapper_latest.deb "$REMAPPER_URL"
print_msg $C_YELLOW "Instalando Input Remapper..."
sudo dpkg -i input-remapper_latest.deb
print_msg $C_GREEN "[PASSO 3/5] Intérprete Input Remapper criado com sucesso."
sleep 1

#4
print_msg $C_YELLOW "\n[PASSO 4/5] Harmonizando os feitiços: corrigindo quaisquer dependências quebradas..."
sudo apt install -f -y
print_msg $C_GREEN "[PASSO 4/5] Feitiços harmonizados."
sleep 1

#5
print_msg $C_YELLOW "\n[PASSO 5/5] Ativando o intérprete e limpando o altar..."
print_msg $C_BLUE "Ativando o serviço do Input Remapper para iniciar com o sistema..."
sudo systemctl enable --now input-remapper
print_msg $C_BLUE "Limpando os artefatos de instalação..."
rm weylus_latest.deb
rm input-remapper_latest.deb
print_msg $C_GREEN "[PASSO 5/5] Ritual de limpeza concluído."
sleep 1

print_msg $C_YELLOW "\nPRÓXIMOS PASSOS (AÇÃO MANUAL NECESSÁRIA):"
print_msg $C_NC "1. No seu tablet, ative a 'Depuração USB' nas 'Opções do Desenvolvedor'."
print_msg $C_NC "2. Abra o programa 'Input Remapper' no seu PC para configurar os botões da sua caneta."
print_msg $C_NC "3. Consulte o arquivo README.md para instruções detalhadas sobre a configuração do Input Remapper e o uso diário do Weylus."
print_msg $C_BLUE "\nQue a sua criatividade flua sem barreiras entre os mundos!"
