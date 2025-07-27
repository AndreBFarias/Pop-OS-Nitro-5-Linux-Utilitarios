### ARQUIVO: instalador_extensoes_gnome.sh ###
==================================================

# DESCRIÇÃO
# Um script para automatizar a instalação de um conjunto pré-definido de extensões do GNOME Shell.
# Ele utiliza a ferramenta de linha de comando 'gnome-shell-extension-installer', que deve ser instalada previamente.
# A lista de extensões é definida por seus IDs no site extensions.gnome.org.

# COMENTÁRIOS
#1: Define um array contendo os IDs numéricos de todas as extensões a serem instaladas. Muitos são extensões padrão do Pop!_OS.
#2: Itera sobre cada ID no array.
#3: Executa o comando de instalação para cada ID, usando a flag '--yes' para aceitar automaticamente a confirmação e agilizar o processo.

# CÓDIGO
#!/bin/bash
#1
EXTS=(
  6     # Apps Menu
  16    # Auto Move Windows
  3072  # Cosmic Dock (System76)
  3080  # Cosmic Workspaces
  15    # DING (Desktop Icons NG)
  7     # Removable Drive Menu
  1160  # Pop Shell
  3193  # System76 Power
  19    # User Themes
)
#2
for id in "${EXTS[@]}"; do
  #3
  gnome-shell-extension-installer "$id" --yes
done

echo "Instalação de extensões do GNOME Shell concluída."

# CITAÇÃO
# "O progresso é impossível sem mudança; e aqueles que não conseguem mudar as suas mentes não conseguem mudar nada." - George Bernard Shaw

==================================================
### ARQUIVO: instalador_extensoes_gnome.sh ###
==================================================

# DESCRIÇÃO
# Um script para automatizar a instalação de um conjunto pré-definido de extensões do GNOME Shell.
# Ele utiliza a ferramenta de linha de comando 'gnome-shell-extension-installer', que deve ser instalada previamente.
# A lista de extensões é definida por seus IDs no site extensions.gnome.org.

# COMENTÁRIOS
#1: Define um array contendo os IDs numéricos de todas as extensões a serem instaladas. Muitos são extensões padrão do Pop!_OS.
#2: Itera sobre cada ID no array.
#3: Executa o comando de instalação para cada ID, usando a flag '--yes' para aceitar automaticamente a confirmação e agilizar o processo.

# CÓDIGO
#!/bin/bash
#1
EXTS=(
  6     # Apps Menu
  16    # Auto Move Windows
  3072  # Cosmic Dock (System76)
  3080  # Cosmic Workspaces
  15    # DING (Desktop Icons NG)
  7     # Removable Drive Menu
  1160  # Pop Shell
  3193  # System76 Power
  19    # User Themes
)
#2
for id in "${EXTS[@]}"; do
  #3
  gnome-shell-extension-installer "$id" --yes
done

echo "Instalação de extensões do GNOME Shell concluída."

# CITAÇÃO
# "O progresso é impossível sem mudança; e aqueles que não conseguem mudar as suas mentes não conseguem mudar nada." - George Bernard Shaw

==================================================
