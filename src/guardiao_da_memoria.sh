#!/bin/bash
#1: Define variáveis de cor para uma saída mais legível no terminal.
#2: Verifica se o 'earlyoom' já está instalado. A verificação é feita de forma silenciosa.
#3: Se o 'earlyoom' não for encontrado, ele é instalado via APT.
#4: Usa o 'systemctl' para garantir que o serviço do 'earlyoom' esteja habilitado (para iniciar no boot) e ativo (para iniciar imediatamente).
#5: Verifica o status do serviço para confirmar ao usuário que o guardião está de fato em seu posto e vigiando.
#6: Fornece uma mensagem final clara, confirmando que a proteção está ativa.

#1
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== INVOCANDO O GUARDIÃO DA MEMÓRIA (EARLYOOM) ===${NC}"

#2
if ! command -v earlyoom &> /dev/null; then
    echo -e "${YELLOW}[1/3] Guardião não encontrado. Convocando pacotes...${NC}"
    #3
    sudo apt update
    sudo apt install -y earlyoom
else
    echo -e "${GREEN}[1/3] Guardião 'earlyoom' já presente no reino.${NC}"
fi

#4
echo -e "${YELLOW}[2/3] Designando o guardião para a vigília eterna...${NC}"
sudo systemctl enable --now earlyoom

#5
echo -e "${YELLOW}[3/3] Verificando o posto de vigia...${NC}"
if systemctl is-active --quiet earlyoom; then
    echo -e "${GREEN}Status: O guardião está ativo e vigilante.${NC}"
else
    echo -e "${RED}ERRO: O guardião não respondeu ao chamado. Verifique o status com 'systemctl status earlyoom'.${NC}"
fi

#6
echo -e "\n${GREEN}=== PROTEÇÃO CONTRA CONGELAMENTO ATIVADA ===${NC}"

