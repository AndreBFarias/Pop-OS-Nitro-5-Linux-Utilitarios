### ARQUIVO: gerador_inventario_software.sh ###
==================================================

# DESCRIÇÃO
# Este script gera um inventário completo de todo o software instalado no sistema, abrangendo múltiplos gerenciadores de pacotes e instalações manuais.
# Ele cataloga pacotes APT, Flatpak, Snap, e também busca por AppImages e binários em locais comuns como /opt e /usr/local/bin.
# O resultado é um único arquivo de log, chamado de "inventário de almas", que fornece uma visão panorâmica de tudo que está instalado.

# COMENTÁRIOS
#1: Define o nome do arquivo de log com um timestamp para unicidade.
#2: Cria uma função para adicionar um cabeçalho formatado ao arquivo de log, melhorando a organização.
#3: Inicia o arquivo de log com um cabeçalho geral.
#4: Lista todos os pacotes instalados via APT.
#5: Lista todas as aplicações instaladas via Flatpak.
#6: Verifica se o comando 'snap' existe. Se sim, lista as aplicações Snap. Se não, registra que o sistema Snap não está presente.
#7: Realiza uma busca por arquivos .AppImage nos diretórios /home e /opt. Avisa o usuário que esta operação pode ser demorada.
#8: Lista o conteúdo dos diretórios /opt e /usr/local/bin, que são locais comuns para a instalação manual de software.
#9: Finaliza o relatório e informa ao usuário onde o arquivo de inventário foi salvo.

# CÓDIGO
#!/bin/bash
#1
LOG_FILE="$HOME/inventario_software_$(date +'%Y-%m-%d_%H-%M-%S').log"
#2
log_header() {
  echo "" | tee -a "$LOG_FILE"
  echo "--- $1 ---" | tee -a "$LOG_FILE"
  echo "" | tee -a "$LOG_FILE"
}
#3
echo "Relatório de Inventário de Software - Gerado em $(date)" > "$LOG_FILE"

#4
log_header "PACOTES DO SISTEMA (APT)"
apt list --installed 2>/dev/null >> "$LOG_FILE"
#5
log_header "PACOTES ISOLADOS (FLATPAK)"
flatpak list 2>/dev/null >> "$LOG_FILE"
#6
log_header "PACOTES ISOLADOS (SNAP)"
if command -v snap &> /dev/null; then
  snap list 2>/dev/null >> "$LOG_FILE"
else
  echo "O sistema Snap não foi encontrado." >> "$LOG_FILE"
fi
#7
log_header "APLICAÇÕES PORTÁTEIS (APPIMAGE)"
echo "Buscando por arquivos .AppImage em /home e /opt..." | tee -a "$LOG_FILE"
find /home /opt -type f -name "*.AppImage" 2>/dev/null >> "$LOG_FILE"
#8
log_header "INSTALAÇÕES MANUAIS"
echo "--> Conteúdo de /opt:" >> "$LOG_FILE"
ls -l /opt >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "--> Conteúdo de /usr/local/bin:" >> "$LOG_FILE"
ls -l /usr/local/bin >> "$LOG_FILE"
#9
echo "" | tee -a "$LOG_FILE"
echo "--- FIM DO RELATÓRIO ---" | tee -a "$LOG_FILE"
echo "O inventário foi salvo em: $LOG_FILE"

# CITAÇÃO
# "Se você conhece o inimigo e conhece a si mesmo, não precisa temer o resultado de cem batalhas." - Sun Tzu


==================================================
### ARQUIVO: gerador_inventario_software.sh ###
==================================================

# DESCRIÇÃO
# Este script gera um inventário completo de todo o software instalado no sistema, abrangendo múltiplos gerenciadores de pacotes e instalações manuais.
# Ele cataloga pacotes APT, Flatpak, Snap, e também busca por AppImages e binários em locais comuns como /opt e /usr/local/bin.
# O resultado é um único arquivo de log, chamado de "inventário de almas", que fornece uma visão panorâmica de tudo que está instalado.

# COMENTÁRIOS
#1: Define o nome do arquivo de log com um timestamp para unicidade.
#2: Cria uma função para adicionar um cabeçalho formatado ao arquivo de log, melhorando a organização.
#3: Inicia o arquivo de log com um cabeçalho geral.
#4: Lista todos os pacotes instalados via APT.
#5: Lista todas as aplicações instaladas via Flatpak.
#6: Verifica se o comando 'snap' existe. Se sim, lista as aplicações Snap. Se não, registra que o sistema Snap não está presente.
#7: Realiza uma busca por arquivos .AppImage nos diretórios /home e /opt. Avisa o usuário que esta operação pode ser demorada.
#8: Lista o conteúdo dos diretórios /opt e /usr/local/bin, que são locais comuns para a instalação manual de software.
#9: Finaliza o relatório e informa ao usuário onde o arquivo de inventário foi salvo.

# CÓDIGO
#!/bin/bash
#1
LOG_FILE="$HOME/inventario_software_$(date +'%Y-%m-%d_%H-%M-%S').log"
#2
log_header() {
  echo "" | tee -a "$LOG_FILE"
  echo "--- $1 ---" | tee -a "$LOG_FILE"
  echo "" | tee -a "$LOG_FILE"
}
#3
echo "Relatório de Inventário de Software - Gerado em $(date)" > "$LOG_FILE"

#4
log_header "PACOTES DO SISTEMA (APT)"
apt list --installed 2>/dev/null >> "$LOG_FILE"
#5
log_header "PACOTES ISOLADOS (FLATPAK)"
flatpak list 2>/dev/null >> "$LOG_FILE"
#6
log_header "PACOTES ISOLADOS (SNAP)"
if command -v snap &> /dev/null; then
  snap list 2>/dev/null >> "$LOG_FILE"
else
  echo "O sistema Snap não foi encontrado." >> "$LOG_FILE"
fi
#7
log_header "APLICAÇÕES PORTÁTEIS (APPIMAGE)"
echo "Buscando por arquivos .AppImage em /home e /opt..." | tee -a "$LOG_FILE"
find /home /opt -type f -name "*.AppImage" 2>/dev/null >> "$LOG_FILE"
#8
log_header "INSTALAÇÕES MANUAIS"
echo "--> Conteúdo de /opt:" >> "$LOG_FILE"
ls -l /opt >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "--> Conteúdo de /usr/local/bin:" >> "$LOG_FILE"
ls -l /usr/local/bin >> "$LOG_FILE"
#9
echo "" | tee -a "$LOG_FILE"
echo "--- FIM DO RELATÓRIO ---" | tee -a "$LOG_FILE"
echo "O inventário foi salvo em: $LOG_FILE"

# CITAÇÃO
# "Se você conhece o inimigo e conhece a si mesmo, não precisa temer o resultado de cem batalhas." - Sun Tzu


==================================================
