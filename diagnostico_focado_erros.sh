### ARQUIVO: diagnostico_focado_erros.sh ###
==================================================

# DESCRIÇÃO
# Um script de diagnóstico rápido e focado, projetado para identificar as causas mais comuns de problemas em um desktop Linux com GNOME.
# Diferente de um coletor geral, ele filtra ativamente por erros em logs do sistema, Xorg, pacotes e drivers.
# É uma ferramenta de primeira resposta para entender por que uma interface gráfica pode estar instável.

# COMENTÁRIOS
#1: Define o nome do arquivo de log com um timestamp para evitar sobrescrever execuções anteriores.
#2: Cria uma função 'log' que simplifica a escrita de cabeçalhos e a execução de comandos, redirecionando toda a saída para o arquivo de log e para o terminal.
#3: Inicia o log e registra informações básicas do sistema, como versão do kernel e da distribuição.
#4: Lista especificamente os serviços do systemd que falharam.
#5: Extrai do journal apenas as mensagens de erro com prioridade 3 (erros críticos) do boot atual.
#6: Filtra as mensagens do kernel (dmesg) para exibir apenas linhas contendo 'acpi', 'usb' ou 'error', focando em problemas de hardware comuns.
#7: Filtra o log do servidor gráfico Xorg, mostrando apenas as linhas marcadas como (EE) - Erro - ou (WW) - Aviso.
#8: Lista os pacotes que estão em um estado inconsistente no dpkg (ex: semi-instalados).
#9: Verifica as dependências da biblioteca do GNOME Shell para encontrar links quebrados.
#10: Lista os módulos de kernel carregados e os dispositivos PCI de vídeo com seus respectivos drivers em uso.
#11: Verifica a existência de arquivos de configuração críticos que podem afetar o boot e a interface gráfica.
#12: Tenta executar 'nvidia-smi' para obter um status detalhado da GPU NVIDIA.
#13: Tenta executar um dump das configurações de energia do driver da System76, útil para depurar problemas de bateria e performance em notebooks da marca.

# CÓDIGO
#!/bin/bash
#1
ARQUIVO_LOG="$HOME/diagnostico_focado_$(date +%Y-%m-%d_%H-%M-%S).log"
#2
log() {
    echo -e "\n========== $1 ==========" | tee -a "$ARQUIVO_LOG"
    shift
    "$@" &>> "$ARQUIVO_LOG"
}

echo "Iniciando diagnóstico focado em erros..." | tee "$ARQUIVO_LOG"
#3
log "INFORMAÇÕES DO SISTEMA" uname -a
log "VERSÃO DO KERNEL" uname -r
#4
log "SERVIÇOS COM FALHA" systemctl --failed
#5
log "ERROS CRÍTICOS DO JOURNAL" journalctl -p 3 -b -n 50
#6
log "FILTRO DMESG (ACPI|USB|ERROR)" sudo dmesg | grep -iE "acpi|usb|error"
#7
log "ERROS E AVISOS DO XORG" cat /var/log/Xorg.0.log | grep -iE "\(EE\)|\(WW\)"
#8
log "PACOTES COM PROBLEMAS NO DPKG" dpkg -l | grep -v '^ii'
#9
log "DEPENDÊNCIAS DO GNOME-SHELL" ldd $(which gnome-shell)
#10
log "MÓDULOS DO KERNEL" lsmod
log "DISPOSITIVOS DE VÍDEO (PCI)" lspci -nnk | grep -A3 -E 'VGA|3D|Display'
#11
log "VERIFICAÇÃO DE ARQUIVOS DE CONFIGURAÇÃO CRÍTICOS" bash -c '
  FILES=("/etc/X11/xorg.conf" "/etc/default/grub" "/etc/modprobe.d/blacklist-nouveau.conf")
  for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then echo "ENCONTRADO: $file"; else echo "AUSENTE: $file"; fi
  done'
#12
log "STATUS DA GPU (NVIDIA)" nvidia-smi
#13
log "CONFIGURAÇÕES DE ENERGIA (SYSTEM76)" sudo system76-power dump

echo -e "\nDiagnóstico finalizado. Arquivo de log salvo em: $ARQUIVO_LOG"

# CITAÇÃO
# "A verdade nunca prejudica uma causa que é justa." - Mahatma Gandhi


==================================================
### ARQUIVO: diagnostico_focado_erros.sh ###
==================================================

# DESCRIÇÃO
# Um script de diagnóstico rápido e focado, projetado para identificar as causas mais comuns de problemas em um desktop Linux com GNOME.
# Diferente de um coletor geral, ele filtra ativamente por erros em logs do sistema, Xorg, pacotes e drivers.
# É uma ferramenta de primeira resposta para entender por que uma interface gráfica pode estar instável.

# COMENTÁRIOS
#1: Define o nome do arquivo de log com um timestamp para evitar sobrescrever execuções anteriores.
#2: Cria uma função 'log' que simplifica a escrita de cabeçalhos e a execução de comandos, redirecionando toda a saída para o arquivo de log e para o terminal.
#3: Inicia o log e registra informações básicas do sistema, como versão do kernel e da distribuição.
#4: Lista especificamente os serviços do systemd que falharam.
#5: Extrai do journal apenas as mensagens de erro com prioridade 3 (erros críticos) do boot atual.
#6: Filtra as mensagens do kernel (dmesg) para exibir apenas linhas contendo 'acpi', 'usb' ou 'error', focando em problemas de hardware comuns.
#7: Filtra o log do servidor gráfico Xorg, mostrando apenas as linhas marcadas como (EE) - Erro - ou (WW) - Aviso.
#8: Lista os pacotes que estão em um estado inconsistente no dpkg (ex: semi-instalados).
#9: Verifica as dependências da biblioteca do GNOME Shell para encontrar links quebrados.
#10: Lista os módulos de kernel carregados e os dispositivos PCI de vídeo com seus respectivos drivers em uso.
#11: Verifica a existência de arquivos de configuração críticos que podem afetar o boot e a interface gráfica.
#12: Tenta executar 'nvidia-smi' para obter um status detalhado da GPU NVIDIA.
#13: Tenta executar um dump das configurações de energia do driver da System76, útil para depurar problemas de bateria e performance em notebooks da marca.

# CÓDIGO
#!/bin/bash
#1
ARQUIVO_LOG="$HOME/diagnostico_focado_$(date +%Y-%m-%d_%H-%M-%S).log"
#2
log() {
    echo -e "\n========== $1 ==========" | tee -a "$ARQUIVO_LOG"
    shift
    "$@" &>> "$ARQUIVO_LOG"
}

echo "Iniciando diagnóstico focado em erros..." | tee "$ARQUIVO_LOG"
#3
log "INFORMAÇÕES DO SISTEMA" uname -a
log "VERSÃO DO KERNEL" uname -r
#4
log "SERVIÇOS COM FALHA" systemctl --failed
#5
log "ERROS CRÍTICOS DO JOURNAL" journalctl -p 3 -b -n 50
#6
log "FILTRO DMESG (ACPI|USB|ERROR)" sudo dmesg | grep -iE "acpi|usb|error"
#7
log "ERROS E AVISOS DO XORG" cat /var/log/Xorg.0.log | grep -iE "\(EE\)|\(WW\)"
#8
log "PACOTES COM PROBLEMAS NO DPKG" dpkg -l | grep -v '^ii'
#9
log "DEPENDÊNCIAS DO GNOME-SHELL" ldd $(which gnome-shell)
#10
log "MÓDULOS DO KERNEL" lsmod
log "DISPOSITIVOS DE VÍDEO (PCI)" lspci -nnk | grep -A3 -E 'VGA|3D|Display'
#11
log "VERIFICAÇÃO DE ARQUIVOS DE CONFIGURAÇÃO CRÍTICOS" bash -c '
  FILES=("/etc/X11/xorg.conf" "/etc/default/grub" "/etc/modprobe.d/blacklist-nouveau.conf")
  for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then echo "ENCONTRADO: $file"; else echo "AUSENTE: $file"; fi
  done'
#12
log "STATUS DA GPU (NVIDIA)" nvidia-smi
#13
log "CONFIGURAÇÕES DE ENERGIA (SYSTEM76)" sudo system76-power dump

echo -e "\nDiagnóstico finalizado. Arquivo de log salvo em: $ARQUIVO_LOG"

# CITAÇÃO
# "A verdade nunca prejudica uma causa que é justa." - Mahatma Gandhi


==================================================
