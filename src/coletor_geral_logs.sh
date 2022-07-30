### ARQUIVO: coletor_geral_logs.sh ###
==================================================

# DESCRIÇÃO
# Este script é um coletor de logs abrangente, projetado para reunir uma vasta quantidade de informações de diagnóstico do sistema.
# Ele cria um diretório versionado por data e hora e salva dezenas de logs diferentes, cobrindo hardware, drivers, sistema de arquivos, bootloader e serviços.
# É ideal para depuração remota ou para arquivar o estado do sistema antes de uma grande mudança.

# COMENTÁRIOS
#1: Garante que o script pare em caso de erro, trate variáveis não definidas como erro e propague o status de saída de pipelines.
#2: Define um diretório de destino único para os logs, baseado na data e hora.
#3: Coleta logs gerais do sistema: erros do journal, mensagens do kernel (dmesg) e serviços que falharam ao iniciar.
#4: Coleta informações sobre módulos do kernel carregados, dispositivos PCI, tabelas ACPI e provedores de vídeo. O '|| true' previne que o script pare se um comando falhar (ex: em sistemas sem interface gráfica).
#5: Coleta informações sobre o sistema de arquivos, uso de disco, memória e pacotes quebrados.
#6: Coleta informações do bootloader (EFI Boot Manager e systemd-boot) e do sistema de arquivos (blkid e fstab).
#7: Verifica se o comando 'inxi' está instalado e, se estiver, gera um relatório de hardware extremamente detalhado. Caso contrário, registra que 'inxi' não foi encontrado.
#8: Lista todos os serviços do systemd que estão habilitados para iniciar no boot.
#9: Informa ao usuário que a coleta foi concluída e onde os arquivos foram salvos.

# CÓDIGO
#!/bin/bash
#1
set -euo pipefail
#2
DATA=$(date +"%Y-%m-%d_%H-%M-%S")
DESTINO="$HOME/diagnostico_sistema/$DATA"
mkdir -p "$DESTINO"
echo "Criando diretório para logs: $DESTINO"
echo "Iniciando coleta de logs do sistema..."

#3
journalctl -p 3 -b > "$DESTINO/journal_erros.log"
dmesg > "$DESTINO/dmesg_completo.log"
dmesg | grep -iE 'acpi|usb|fail|x509|nvidia|amdgpu|amd|nvme|firmware' > "$DESTINO/dmesg_filtrado.log"
systemctl --failed > "$DESTINO/systemd_failed.log"

#4
lsmod > "$DESTINO/lsmod.log"
lspci -nnk > "$DESTINO/lspci.log"
cat /proc/acpi/wakeup > "$DESTINO/acpi_wakeup.log" 2>/dev/null || true
xrandr --listproviders > "$DESTINO/xrandr.log" 2>/dev/null || true

#5
df -h > "$DESTINO/uso_disco.log"
free -h > "$DESTINO/memoria.log"
dpkg -l | grep -v '^ii' > "$DESTINO/pacotes_quebrados.log"
mount | column -t > "$DESTINO/unidades_montadas.log"

#6
efibootmgr -v > "$DESTINO/efibootmgr.log" 2>/dev/null || true
bootctl status > "$DESTINO/bootctl_status.log" 2>/dev/null || true
ls -f /boot/efi/loader/entries/ 2>/dev/null > "$DESTINO/systemd_boot_entries.log" || true
blkid > "$DESTINO/blkid.log"
cat /etc/fstab > "$DESTINO/fstab.log"

#7
command -v inxi >/dev/null && inxi -Fxxxrz > "$DESTINO/inxi_completo.log" || echo "Comando 'inxi' não encontrado." > "$DESTINO/inxi_nao_encontrado.log"

#8
systemctl list-unit-files --state=enabled > "$DESTINO/servicos_habilitados.log"

#9
echo "Coleta de logs concluída. Arquivos salvos em: $DESTINO"

# CITAÇÃO
# "O que não é medido não pode ser gerenciado." - Peter Drucker

==================================================
### ARQUIVO: coletor_geral_logs.sh ###
==================================================

# DESCRIÇÃO
# Este script é um coletor de logs abrangente, projetado para reunir uma vasta quantidade de informações de diagnóstico do sistema.
# Ele cria um diretório versionado por data e hora e salva dezenas de logs diferentes, cobrindo hardware, drivers, sistema de arquivos, bootloader e serviços.
# É ideal para depuração remota ou para arquivar o estado do sistema antes de uma grande mudança.

# COMENTÁRIOS
#1: Garante que o script pare em caso de erro, trate variáveis não definidas como erro e propague o status de saída de pipelines.
#2: Define um diretório de destino único para os logs, baseado na data e hora.
#3: Coleta logs gerais do sistema: erros do journal, mensagens do kernel (dmesg) e serviços que falharam ao iniciar.
#4: Coleta informações sobre módulos do kernel carregados, dispositivos PCI, tabelas ACPI e provedores de vídeo. O '|| true' previne que o script pare se um comando falhar (ex: em sistemas sem interface gráfica).
#5: Coleta informações sobre o sistema de arquivos, uso de disco, memória e pacotes quebrados.
#6: Coleta informações do bootloader (EFI Boot Manager e systemd-boot) e do sistema de arquivos (blkid e fstab).
#7: Verifica se o comando 'inxi' está instalado e, se estiver, gera um relatório de hardware extremamente detalhado. Caso contrário, registra que 'inxi' não foi encontrado.
#8: Lista todos os serviços do systemd que estão habilitados para iniciar no boot.
#9: Informa ao usuário que a coleta foi concluída e onde os arquivos foram salvos.

# CÓDIGO
#!/bin/bash
#1
set -euo pipefail
#2
DATA=$(date +"%Y-%m-%d_%H-%M-%S")
DESTINO="$HOME/diagnostico_sistema/$DATA"
mkdir -p "$DESTINO"
echo "Criando diretório para logs: $DESTINO"
echo "Iniciando coleta de logs do sistema..."

#3
journalctl -p 3 -b > "$DESTINO/journal_erros.log"
dmesg > "$DESTINO/dmesg_completo.log"
dmesg | grep -iE 'acpi|usb|fail|x509|nvidia|amdgpu|amd|nvme|firmware' > "$DESTINO/dmesg_filtrado.log"
systemctl --failed > "$DESTINO/systemd_failed.log"

#4
lsmod > "$DESTINO/lsmod.log"
lspci -nnk > "$DESTINO/lspci.log"
cat /proc/acpi/wakeup > "$DESTINO/acpi_wakeup.log" 2>/dev/null || true
xrandr --listproviders > "$DESTINO/xrandr.log" 2>/dev/null || true

#5
df -h > "$DESTINO/uso_disco.log"
free -h > "$DESTINO/memoria.log"
dpkg -l | grep -v '^ii' > "$DESTINO/pacotes_quebrados.log"
mount | column -t > "$DESTINO/unidades_montadas.log"

#6
efibootmgr -v > "$DESTINO/efibootmgr.log" 2>/dev/null || true
bootctl status > "$DESTINO/bootctl_status.log" 2>/dev/null || true
ls -f /boot/efi/loader/entries/ 2>/dev/null > "$DESTINO/systemd_boot_entries.log" || true
blkid > "$DESTINO/blkid.log"
cat /etc/fstab > "$DESTINO/fstab.log"

#7
command -v inxi >/dev/null && inxi -Fxxxrz > "$DESTINO/inxi_completo.log" || echo "Comando 'inxi' não encontrado." > "$DESTINO/inxi_nao_encontrado.log"

#8
systemctl list-unit-files --state=enabled > "$DESTINO/servicos_habilitados.log"

#9
echo "Coleta de logs concluída. Arquivos salvos em: $DESTINO"

# CITAÇÃO
# "O que não é medido não pode ser gerenciado." - Peter Drucker

==================================================
