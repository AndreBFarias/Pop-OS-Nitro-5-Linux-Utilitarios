==================================================
### ARQUIVO: oraculo_do_kernel.sh ###
==================================================

# DESCRIÇÃO
# Este script atua como um assistente para modificar as opções de boot do kernel de forma segura.
# Primeiro, ele executa um diagnóstico completo para identificar o bootloader em uso (systemd-boot ou GRUB), a GPU, e as opções de kernel atuais.
# Em seguida, apresenta um conjunto de opções otimizadas (curadas para evitar conflitos) e pede a confirmação explícita do usuário antes de aplicá-las usando a ferramenta apropriada (kernelstub).

# COMENTÁRIOS
#1: Definição de cores para melhorar a legibilidade da saída do terminal.
#2: A função de diagnóstico. Ela é o "Oráculo" do script.
#3: Detecta qual bootloader está em uso, focando no 'kernelstub', que é o padrão do Pop!_OS.
#4: Exibe informações críticas: o bootloader detectado, a GPU primária e os drivers em uso.
#5: Mostra as opções de boot que estão atualmente configuradas, para que o usuário possa comparar o "antes" e o "depois".
#6: A lista de parâmetros de kernel propostos. Note que o conflito 'acpi_backlight' foi resolvido, mantendo apenas a versão 'native'.
#7: O coração da lógica. O script executa o diagnóstico, exibe o estado atual e o estado proposto, e então pausa, aguardando a confirmação explícita do usuário para prosseguir com a alteração, que é uma operação de risco.
#8: A função de aplicação. Se o usuário confirmar, esta função é chamada.
#9: Garante que a opção conflitante 'acpi_backlight=vendor' seja removida, caso exista, antes de adicionar as novas.
#10: Itera sobre cada opção da lista e a adiciona individualmente usando 'kernelstub'. Isso é mais seguro e verboso do que adicionar uma única string gigante.
#11: Após aplicar todas as mudanças, exibe a nova configuração final e lembra o usuário da necessidade de reiniciar o sistema para que as alterações tenham efeito.

# CÓDIGO
#!/bin/bash
#1
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

#2
funcao_oraculo() {
    echo -e "${BLUE}=== ORÁCULO DO KERNEL: FASE DE DIAGNÓSTICO ===${NC}"
    #3
    if command -v kernelstub &> /dev/null; then
        BOOTLOADER="systemd-boot (via kernelstub)"
    elif command -v update-grub &> /dev/null; then
        BOOTLOADER="GRUB (via update-grub)"
    else
        BOOTLOADER="Desconhecido"
    fi
    echo -e "${YELLOW}Bootloader Detectado:${NC} $BOOTLOADER"
    #4
    echo -e "\n${YELLOW}Informações de GPU:${NC}"
    lspci -k | grep -A 2 -E "(VGA|3D)"
    #5
    echo -e "\n${YELLOW}Opções de Boot Atuais (Configuradas):${NC}"
    if [[ "$BOOTLOADER" == "systemd-boot (via kernelstub)" ]]; then
        kernelstub --print-config | grep "Kernel Boot Options"
    else
        grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub
    fi
    echo -e "${BLUE}==============================================${NC}"
}

#8
funcao_aplicar_mudancas() {
    echo -e "\n${YELLOW}Iniciando aplicação dos novos parâmetros...${NC}"
    #9
    echo "Garantindo a remoção de parâmetros conflitantes..."
    sudo kernelstub --remove-options "acpi_backlight=vendor"
    
    #10
    for opt in "${PARAMS_PROPOSTOS[@]}"; do
        echo "Adicionando: $opt"
        sudo kernelstub --add-options "$opt"
    done
    
    #11
    echo -e "\n${GREEN}Novos parâmetros aplicados com sucesso!${NC}"
    echo -e "${YELLOW}Configuração Final:${NC}"
    sudo kernelstub --print-config
    echo -e "\n${RED}É ESSENCIAL REINICIAR O SISTEMA para que as mudanças tenham efeito.${NC}"
}

# --- LÓGICA PRINCIPAL ---
funcao_oraculo

#6
PARAMS_PROPOSTOS=(
    "quiet"
    "loglevel=0"
    "systemd.show_status=false"
    "splash"
    "nvidia-drm.modeset=1"
    "acpi_rev_override=1"
    "acpi_enforce_resources=lax"
    "acpi_osi=Linux"
    "acpi_backlight=native"
    "nvidia.NVreg_UsePageAttributeTable=1"
)

echo -e "\n${YELLOW}O Oráculo propõe os seguintes parâmetros de boot:${NC}"
printf " %s" "${PARAMS_PROPOSTOS[@]}"
echo -e "\n"

#7
read -p $'\e[1;33mDeseja aplicar estas mudanças ao seu sistema? Esta ação é de alto nível e modificará o boot. (s/N): \e[0m' confirmacao

if [[ "$confirmacao" =~ ^[sS]$ ]]; then
    if command -v kernelstub &> /dev/null; then
        funcao_aplicar_mudancas
    else
        echo -e "${RED}ERRO: Este script, na sua forma atual, só suporta modificação via 'kernelstub' (padrão do Pop!_OS). Nenhuma alteração foi feita.${NC}"
        exit 1
    fi
else
    echo -e "\nOperação cancelada pelo usuário. O sistema permanece inalterado."
fi

# CITAÇÃO
# "O que está em cima é como o que está embaixo, e o que está embaixo é como o que está em cima." - O Caibalion
