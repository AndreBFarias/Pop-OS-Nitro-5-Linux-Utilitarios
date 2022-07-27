### ARQUIVO: verificador_integridade_pre-boot.sh ###
==================================================

# DESCRIÇÃO
# Um script de verificação final, projetado para ser executado antes de uma reinicialização crítica.
# Ele verifica componentes essenciais do sistema de boot e da interface gráfica para aumentar a confiança de que o sistema voltará a funcionar normalmente.
# As verificações incluem kernel, estrutura de diretórios, EFI, systemd, serviço gráfico e pacotes quebrados.

# COMENTÁRIOS
#1: Mostra a versão do kernel em uso.
#2: Lista o conteúdo do diretório raiz para uma verificação visual rápida da estrutura.
#3: Verifica se o diretório /boot/efi existe e lista seu conteúdo.
#4: Procura por configurações do GRUB, se aplicável.
#5: Lista os 'targets' do systemd para garantir que o alvo gráfico (graphical.target) está presente.
#6: Verifica o status do Gerenciador de Display (GDM ou LightDM) para confirmar que o serviço de login está configurado.
#7: Mostra os erros registrados no boot anterior, o que pode indicar problemas persistentes.
#8: Usa o 'debsums' (se instalado) para verificar a integridade dos arquivos de pacotes instalados contra seus checksums MD5.
#9: Usa 'efibootmgr' (se instalado) para listar as entradas de boot configuradas na UEFI.
#10: Oferece a opção de simular uma reinicialização para o ambiente gráfico, fechando a sessão atual e testando se o 'graphical.target' pode ser ativado.

# CÓDIGO
#!/bin/bash
echo "Verificando integridade do sistema antes de reiniciar..."

echo -e "\n[KERNEL]"
#1
uname -r

echo -e "\n[ESTRUTURA DA RAIZ]"
#2
ls -l /

echo -e "\n[BOOT EFI]"
#3
ls /boot/efi 2>/dev/null || echo "Diretório /boot/efi não encontrado."

echo -e "\n[CONFIG GRUB]"
#4
grep GRUB /etc/default/grub 2>/dev/null || echo "Arquivo de configuração do GRUB não encontrado."

echo -e "\n[TARGETS SYSTEMD]"
#5
systemctl list-units --type=target | grep graphical

echo -e "\n[SERVIÇO DE INTERFACE GRÁFICA]"
#6
systemctl status gdm 2>/dev/null || systemctl status lightdm 2>/dev/null || echo "Serviço GDM ou LightDM não encontrado."

echo -e "\n[ERROS DO BOOT ANTERIOR]"
#7
journalctl -b -1 -p err || echo "Nenhum log de erros do boot anterior encontrado."

echo -e "\n[INTEGRIDADE DE PACOTES (DEBSUMS)]"
#8
if command -v debsums &> /dev/null; then
    sudo debsums -s || echo "Nenhum pacote quebrado encontrado."
else
    echo "Comando 'debsums' não instalado. Pule esta verificação."
fi

echo -e "\n[ENTRADAS DE BOOT EFI]"
#9
if command -v efibootmgr &> /dev/null; then
    sudo efibootmgr
else
    echo "Comando 'efibootmgr' não instalado. Pule esta verificação."
fi

#10
echo -e "\n[TESTE DE BOOT GRÁFICO]"
read -p "Deseja simular um reinício para o modo gráfico? (Isso encerrará sua sessão atual) [s/N]: " resp
if [[ "$resp" =~ ^[sS]$ ]]; then
    sudo systemctl isolate graphical.target
else
    echo "Simulação de boot pulada."
fi

echo -e "\nVerificação concluída."

# CITAÇÃO
# "Confie, mas verifique." - Ronald Reagan


==================================================
### ARQUIVO: verificador_integridade_pre-boot.sh ###
==================================================

# DESCRIÇÃO
# Um script de verificação final, projetado para ser executado antes de uma reinicialização crítica.
# Ele verifica componentes essenciais do sistema de boot e da interface gráfica para aumentar a confiança de que o sistema voltará a funcionar normalmente.
# As verificações incluem kernel, estrutura de diretórios, EFI, systemd, serviço gráfico e pacotes quebrados.

# COMENTÁRIOS
#1: Mostra a versão do kernel em uso.
#2: Lista o conteúdo do diretório raiz para uma verificação visual rápida da estrutura.
#3: Verifica se o diretório /boot/efi existe e lista seu conteúdo.
#4: Procura por configurações do GRUB, se aplicável.
#5: Lista os 'targets' do systemd para garantir que o alvo gráfico (graphical.target) está presente.
#6: Verifica o status do Gerenciador de Display (GDM ou LightDM) para confirmar que o serviço de login está configurado.
#7: Mostra os erros registrados no boot anterior, o que pode indicar problemas persistentes.
#8: Usa o 'debsums' (se instalado) para verificar a integridade dos arquivos de pacotes instalados contra seus checksums MD5.
#9: Usa 'efibootmgr' (se instalado) para listar as entradas de boot configuradas na UEFI.
#10: Oferece a opção de simular uma reinicialização para o ambiente gráfico, fechando a sessão atual e testando se o 'graphical.target' pode ser ativado.

# CÓDIGO
#!/bin/bash
echo "Verificando integridade do sistema antes de reiniciar..."

echo -e "\n[KERNEL]"
#1
uname -r

echo -e "\n[ESTRUTURA DA RAIZ]"
#2
ls -l /

echo -e "\n[BOOT EFI]"
#3
ls /boot/efi 2>/dev/null || echo "Diretório /boot/efi não encontrado."

echo -e "\n[CONFIG GRUB]"
#4
grep GRUB /etc/default/grub 2>/dev/null || echo "Arquivo de configuração do GRUB não encontrado."

echo -e "\n[TARGETS SYSTEMD]"
#5
systemctl list-units --type=target | grep graphical

echo -e "\n[SERVIÇO DE INTERFACE GRÁFICA]"
#6
systemctl status gdm 2>/dev/null || systemctl status lightdm 2>/dev/null || echo "Serviço GDM ou LightDM não encontrado."

echo -e "\n[ERROS DO BOOT ANTERIOR]"
#7
journalctl -b -1 -p err || echo "Nenhum log de erros do boot anterior encontrado."

echo -e "\n[INTEGRIDADE DE PACOTES (DEBSUMS)]"
#8
if command -v debsums &> /dev/null; then
    sudo debsums -s || echo "Nenhum pacote quebrado encontrado."
else
    echo "Comando 'debsums' não instalado. Pule esta verificação."
fi

echo -e "\n[ENTRADAS DE BOOT EFI]"
#9
if command -v efibootmgr &> /dev/null; then
    sudo efibootmgr
else
    echo "Comando 'efibootmgr' não instalado. Pule esta verificação."
fi

#10
echo -e "\n[TESTE DE BOOT GRÁFICO]"
read -p "Deseja simular um reinício para o modo gráfico? (Isso encerrará sua sessão atual) [s/N]: " resp
if [[ "$resp" =~ ^[sS]$ ]]; then
    sudo systemctl isolate graphical.target
else
    echo "Simulação de boot pulada."
fi

echo -e "\nVerificação concluída."

# CITAÇÃO
# "Confie, mas verifique." - Ronald Reagan


==================================================
