### ARQUIVO: reparo_completo_sistema.sh ###
==================================================

# DESCRIÇÃO
# Um script de reparo abrangente para sistemas baseados em Debian/Ubuntu, com foco especial em Pop!_OS.
# Ele executa uma sequência de fases: limpeza profunda do sistema de pacotes, reparo de drivers (com foco em System76/NVIDIA), verificação e reinstalação de pacotes essenciais, restauração de temas e uma verificação final.
# O objetivo é restaurar um sistema instável a um estado funcional.

# COMENTÁRIOS
#1: Define variáveis de cor para melhorar a legibilidade da saída no terminal.
#2: Define o nome do arquivo de log e um diretório temporário para operações de limpeza.
#3: Lista de pacotes de drivers da System76 a serem verificados/reinstalados.
#4: Função de inicialização: cria o diretório temporário e redireciona toda a saída (stdout e stderr) para o terminal e para o arquivo de log.
#5: Inicia a fase de limpeza: força a configuração de pacotes pendentes, corrige dependências quebradas e remove pacotes órfãos.
#6: Limpa o cache de pacotes baixados (.deb) e remove as listas de pacotes para forçar uma atualização limpa.
#7: Procura por atalhos de aplicativos (.desktop) que apontam para executáveis inexistentes e os remove.
#8: Reconstrói os bancos de dados de aplicativos e atualiza as listas de pacotes.
#9: Inicia a fase de reparo de drivers: tenta adicionar o PPA da System76. Se falhar, tenta instalar as dependências e adicionar a chave manualmente antes de tentar novamente.
#10: Itera sobre a lista de pacotes de drivers, tentando reinstalá-los. Se a reinstalação falhar, ele purga o pacote e tenta uma instalação limpa.
#11: Verifica se uma GPU NVIDIA está presente. Se estiver, tenta executar nvidia-smi para confirmar que os drivers estão funcionando.
#12: Define uma lista de pacotes considerados essenciais para a interface gráfica e o sistema base.
#13: Itera sobre os pacotes essenciais. Se um pacote não estiver instalado, ele é purgado (para remover arquivos de configuração) e reinstalado.
#14: Realiza uma atualização de distribuição para resolver quaisquer problemas complexos de dependência e executa uma correção final de pacotes quebrados.
#15: Inicia a fase de reparo de temas: reinstala temas e ícones padrão do GNOME.
#16: Reconstrói os caches de ícones para garantir que o sistema exiba os ícones corretos.
#17: Reseta as configurações da interface GNOME e do Shell para o usuário atual, revertendo para os padrões de fábrica.
#18: Inicia a verificação final: checa se o alvo gráfico do systemd está ativo.
#19: Verifica se o executável do GNOME Shell existe.
#20: Executa uma checagem de integridade geral do apt.
#21: Executa as funções na sequência correta: inicialização, limpeza, reparo de drivers, pacotes, temas e verificação final.
#22: Informa o usuário sobre os próximos passos e remove o diretório temporário.

# CÓDIGO
#!/bin/bash
#1
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

#2
LOG_FILE="log_reparo_completo.log"
TEMP_DIR="/tmp/reparo_sistema"
#3
PKG_LIST=("system76-driver" "system76-power" "system76-driver-nvidia" "nvidia-settings")

#4
init() {
    echo -e "${BLUE}=== INICIANDO REPARO PROFUNDO DO SISTEMA ===${NC}"
    mkdir -p "$TEMP_DIR"
    exec > >(tee -a "$LOG_FILE") 2>&1
}

deep_clean() {
    echo -e "\n${YELLOW}## FASE 1: LIMPEZA RADICAL DE PACOTES ##${NC}"
    #5
    echo -e "${BLUE}Removendo pacotes quebrados e corrigindo dependências...${NC}"
    sudo dpkg --configure -a
    sudo apt-get install -f -y
    sudo apt-get autoremove --purge -y
    #6
    echo -e "${BLUE}Limpando cache de pacotes...${NC}"
    sudo rm -rf /var/cache/apt/archives/*.deb
    sudo rm -rf /var/lib/apt/lists/*
    #7
    echo -e "${BLUE}Verificando e removendo atalhos de aplicativos inválidos...${NC}"
    sudo updatedb
    locate .desktop | while read f; do
        if [ ! -f "$(grep 'Exec=' "$f" | cut -d= -f2 | cut -d' ' -f1)" ]; then
            echo -e "${RED}Removendo atalho quebrado: $f${NC}"
            sudo rm -f "$f"
        fi
    done
    #8
    echo -e "${BLUE}Reconstruindo bases de dados e atualizando listas...${NC}"
    sudo update-desktop-database
    sudo apt-get update
}

fix_drivers() {
    echo -e "\n${YELLOW}## FASE 2: REPARO DE DRIVERS ##${NC}"
    #9
    echo -e "${BLUE}Configurando repositórios System76...${NC}"
    sudo add-apt-repository -y ppa:system76-dev/stable > /dev/null 2>&1 || {
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:system76-dev/stable
    }
    #10
    for pkg in "${PKG_LIST[@]}"; do
        echo -e "${BLUE}Verificando/Reparando o pacote: $pkg${NC}"
        sudo apt-get install --reinstall -y --allow-downgrades "$pkg" || {
            sudo apt-get purge -y "$pkg"
            sudo apt-get install -y "$pkg"
        }
    done
    #11
    echo -e "${BLUE}Verificando drivers NVIDIA...${NC}"
    if lspci | grep -q "NVIDIA"; then
        nvidia-smi || echo -e "${RED}Falha crítica ao verificar drivers NVIDIA!${NC}"
    fi
}

fix_packages() {
    echo -e "\n${YELLOW}## FASE 3: REPARO DE PACOTES ESSENCIAIS ##${NC}"
    #12
    ESSENTIAL_PKGS=(ubuntu-desktop gnome-shell gdm3 plymouth systemd dbus apt dpkg snapd flatpak)
    #13
    for pkg in "${ESSENTIAL_PKGS[@]}"; do
        echo -e "${BLUE}Verificando pacote essencial: $pkg${NC}"
        dpkg -s "$pkg" > /dev/null 2>&1 || {
            echo -e "${RED}Pacote ausente. Reinstalando: $pkg${NC}"
            sudo apt-get install --reinstall -y "$pkg"
        }
    done
    #14
    echo -e "${BLUE}Corrigindo dependências de forma ampla...${NC}"
    sudo apt-get dist-upgrade -y
    sudo apt --fix-broken install -y
}

fix_themes() {
    echo -e "\n${YELLOW}## FASE 4: RESTAURAÇÃO DE TEMAS E INTERFACE ##${NC}"
    #15
    echo -e "${BLUE}Restaurando temas e ícones padrão...${NC}"
    sudo apt-get install --reinstall -y gnome-themes-extra adwaita-icon-theme-full
    #16
    echo -e "${BLUE}Reconstruindo caches de ícones...${NC}"
    sudo gtk-update-icon-cache -f /usr/share/icons/*
    #17
    echo -e "${BLUE}Restaurando configurações de interface para o padrão...${NC}"
    CURRENT_USER=$(logname)
    sudo -u "$CURRENT_USER" gsettings reset-recursively org.gnome.desktop.interface
    sudo -u "$CURRENT_USER" gsettings reset-recursively org.gnome.shell
}

final_check() {
    echo -e "\n${YELLOW}## VERIFICAÇÃO FINAL DE INTEGRIDADE ##${NC}"
    #18
    echo -e "${BLUE}Testando se o alvo gráfico está ativo...${NC}"
    systemctl is-active graphical.target | grep -q "active" || echo -e "${RED}ERRO: O sistema pode não iniciar em modo gráfico!${NC}"
    #19
    echo -e "${BLUE}Verificando a existência do GNOME Shell...${NC}"
    [ -x "$(command -v gnome-shell)" ] || echo -e "${RED}ERRO: GNOME Shell não encontrado!${NC}"
    #20
    echo -e "${BLUE}Verificando a integridade do APT...${NC}"
    sudo apt-get check || echo -e "${RED}ERRO: Problemas de integridade de pacotes encontrados!${NC}"
}

#21
init
deep_clean
fix_drivers
fix_packages
fix_themes
final_check

echo -e "\n${GREEN}=== PROCESSO DE REPARO CONCLUÍDO ===${NC}"
echo -e "Recomendações:"
echo -e "1. Revise o log de operações em: ${YELLOW}$LOG_FILE${NC}"
echo -e "2. Reinicie o sistema para aplicar todas as alterações."
#22
rm -rf "$TEMP_DIR"
exit 0

# CITAÇÃO
# "A ordem é a primeira lei do céu." - Alexander Pope


==================================================
### ARQUIVO: reparo_completo_sistema.sh ###
==================================================

# DESCRIÇÃO
# Um script de reparo abrangente para sistemas baseados em Debian/Ubuntu, com foco especial em Pop!_OS.
# Ele executa uma sequência de fases: limpeza profunda do sistema de pacotes, reparo de drivers (com foco em System76/NVIDIA), verificação e reinstalação de pacotes essenciais, restauração de temas e uma verificação final.
# O objetivo é restaurar um sistema instável a um estado funcional.

# COMENTÁRIOS
#1: Define variáveis de cor para melhorar a legibilidade da saída no terminal.
#2: Define o nome do arquivo de log e um diretório temporário para operações de limpeza.
#3: Lista de pacotes de drivers da System76 a serem verificados/reinstalados.
#4: Função de inicialização: cria o diretório temporário e redireciona toda a saída (stdout e stderr) para o terminal e para o arquivo de log.
#5: Inicia a fase de limpeza: força a configuração de pacotes pendentes, corrige dependências quebradas e remove pacotes órfãos.
#6: Limpa o cache de pacotes baixados (.deb) e remove as listas de pacotes para forçar uma atualização limpa.
#7: Procura por atalhos de aplicativos (.desktop) que apontam para executáveis inexistentes e os remove.
#8: Reconstrói os bancos de dados de aplicativos e atualiza as listas de pacotes.
#9: Inicia a fase de reparo de drivers: tenta adicionar o PPA da System76. Se falhar, tenta instalar as dependências e adicionar a chave manualmente antes de tentar novamente.
#10: Itera sobre a lista de pacotes de drivers, tentando reinstalá-los. Se a reinstalação falhar, ele purga o pacote e tenta uma instalação limpa.
#11: Verifica se uma GPU NVIDIA está presente. Se estiver, tenta executar nvidia-smi para confirmar que os drivers estão funcionando.
#12: Define uma lista de pacotes considerados essenciais para a interface gráfica e o sistema base.
#13: Itera sobre os pacotes essenciais. Se um pacote não estiver instalado, ele é purgado (para remover arquivos de configuração) e reinstalado.
#14: Realiza uma atualização de distribuição para resolver quaisquer problemas complexos de dependência e executa uma correção final de pacotes quebrados.
#15: Inicia a fase de reparo de temas: reinstala temas e ícones padrão do GNOME.
#16: Reconstrói os caches de ícones para garantir que o sistema exiba os ícones corretos.
#17: Reseta as configurações da interface GNOME e do Shell para o usuário atual, revertendo para os padrões de fábrica.
#18: Inicia a verificação final: checa se o alvo gráfico do systemd está ativo.
#19: Verifica se o executável do GNOME Shell existe.
#20: Executa uma checagem de integridade geral do apt.
#21: Executa as funções na sequência correta: inicialização, limpeza, reparo de drivers, pacotes, temas e verificação final.
#22: Informa o usuário sobre os próximos passos e remove o diretório temporário.

# CÓDIGO
#!/bin/bash
#1
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

#2
LOG_FILE="log_reparo_completo.log"
TEMP_DIR="/tmp/reparo_sistema"
#3
PKG_LIST=("system76-driver" "system76-power" "system76-driver-nvidia" "nvidia-settings")

#4
init() {
    echo -e "${BLUE}=== INICIANDO REPARO PROFUNDO DO SISTEMA ===${NC}"
    mkdir -p "$TEMP_DIR"
    exec > >(tee -a "$LOG_FILE") 2>&1
}

deep_clean() {
    echo -e "\n${YELLOW}## FASE 1: LIMPEZA RADICAL DE PACOTES ##${NC}"
    #5
    echo -e "${BLUE}Removendo pacotes quebrados e corrigindo dependências...${NC}"
    sudo dpkg --configure -a
    sudo apt-get install -f -y
    sudo apt-get autoremove --purge -y
    #6
    echo -e "${BLUE}Limpando cache de pacotes...${NC}"
    sudo rm -rf /var/cache/apt/archives/*.deb
    sudo rm -rf /var/lib/apt/lists/*
    #7
    echo -e "${BLUE}Verificando e removendo atalhos de aplicativos inválidos...${NC}"
    sudo updatedb
    locate .desktop | while read f; do
        if [ ! -f "$(grep 'Exec=' "$f" | cut -d= -f2 | cut -d' ' -f1)" ]; then
            echo -e "${RED}Removendo atalho quebrado: $f${NC}"
            sudo rm -f "$f"
        fi
    done
    #8
    echo -e "${BLUE}Reconstruindo bases de dados e atualizando listas...${NC}"
    sudo update-desktop-database
    sudo apt-get update
}

fix_drivers() {
    echo -e "\n${YELLOW}## FASE 2: REPARO DE DRIVERS ##${NC}"
    #9
    echo -e "${BLUE}Configurando repositórios System76...${NC}"
    sudo add-apt-repository -y ppa:system76-dev/stable > /dev/null 2>&1 || {
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:system76-dev/stable
    }
    #10
    for pkg in "${PKG_LIST[@]}"; do
        echo -e "${BLUE}Verificando/Reparando o pacote: $pkg${NC}"
        sudo apt-get install --reinstall -y --allow-downgrades "$pkg" || {
            sudo apt-get purge -y "$pkg"
            sudo apt-get install -y "$pkg"
        }
    done
    #11
    echo -e "${BLUE}Verificando drivers NVIDIA...${NC}"
    if lspci | grep -q "NVIDIA"; then
        nvidia-smi || echo -e "${RED}Falha crítica ao verificar drivers NVIDIA!${NC}"
    fi
}

fix_packages() {
    echo -e "\n${YELLOW}## FASE 3: REPARO DE PACOTES ESSENCIAIS ##${NC}"
    #12
    ESSENTIAL_PKGS=(ubuntu-desktop gnome-shell gdm3 plymouth systemd dbus apt dpkg snapd flatpak)
    #13
    for pkg in "${ESSENTIAL_PKGS[@]}"; do
        echo -e "${BLUE}Verificando pacote essencial: $pkg${NC}"
        dpkg -s "$pkg" > /dev/null 2>&1 || {
            echo -e "${RED}Pacote ausente. Reinstalando: $pkg${NC}"
            sudo apt-get install --reinstall -y "$pkg"
        }
    done
    #14
    echo -e "${BLUE}Corrigindo dependências de forma ampla...${NC}"
    sudo apt-get dist-upgrade -y
    sudo apt --fix-broken install -y
}

fix_themes() {
    echo -e "\n${YELLOW}## FASE 4: RESTAURAÇÃO DE TEMAS E INTERFACE ##${NC}"
    #15
    echo -e "${BLUE}Restaurando temas e ícones padrão...${NC}"
    sudo apt-get install --reinstall -y gnome-themes-extra adwaita-icon-theme-full
    #16
    echo -e "${BLUE}Reconstruindo caches de ícones...${NC}"
    sudo gtk-update-icon-cache -f /usr/share/icons/*
    #17
    echo -e "${BLUE}Restaurando configurações de interface para o padrão...${NC}"
    CURRENT_USER=$(logname)
    sudo -u "$CURRENT_USER" gsettings reset-recursively org.gnome.desktop.interface
    sudo -u "$CURRENT_USER" gsettings reset-recursively org.gnome.shell
}

final_check() {
    echo -e "\n${YELLOW}## VERIFICAÇÃO FINAL DE INTEGRIDADE ##${NC}"
    #18
    echo -e "${BLUE}Testando se o alvo gráfico está ativo...${NC}"
    systemctl is-active graphical.target | grep -q "active" || echo -e "${RED}ERRO: O sistema pode não iniciar em modo gráfico!${NC}"
    #19
    echo -e "${BLUE}Verificando a existência do GNOME Shell...${NC}"
    [ -x "$(command -v gnome-shell)" ] || echo -e "${RED}ERRO: GNOME Shell não encontrado!${NC}"
    #20
    echo -e "${BLUE}Verificando a integridade do APT...${NC}"
    sudo apt-get check || echo -e "${RED}ERRO: Problemas de integridade de pacotes encontrados!${NC}"
}

#21
init
deep_clean
fix_drivers
fix_packages
fix_themes
final_check

echo -e "\n${GREEN}=== PROCESSO DE REPARO CONCLUÍDO ===${NC}"
echo -e "Recomendações:"
echo -e "1. Revise o log de operações em: ${YELLOW}$LOG_FILE${NC}"
echo -e "2. Reinicie o sistema para aplicar todas as alterações."
#22
rm -rf "$TEMP_DIR"
exit 0

# CITAÇÃO
# "A ordem é a primeira lei do céu." - Alexander Pope


==================================================
