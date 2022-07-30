### ARQUIVO: ajuste_backlight_acpi.sh ###
==================================================

# DESCRIÇÃO
# Este script ajusta o controle de brilho da tela (backlight) forçando o uso do driver ACPI 'native'.
# É uma solução comum para notebooks, especialmente o Acer Nitro 5, onde a opção 'vendor' pode causar congelamentos ou falhas no controle de brilho.
# O objetivo é garantir que o sistema operacional tenha controle direto e estável sobre a iluminação do painel.

# COMENTÁRIOS
#1: Remove a opção 'acpi_backlight=vendor' das configurações de boot do kernelstub. Esta opção pode entrar em conflito com o hardware de certos notebooks.
#2: Adiciona a opção 'acpi_backlight=native', que entrega ao kernel o controle direto do backlight, geralmente resultando em maior compatibilidade.
#3: Imprime a configuração atual do kernelstub no terminal, permitindo que o usuário confirme que as alterações foram aplicadas corretamente.

# CÓDIGO
#!/bin/bash
#1
sudo kernelstub --remove-options "acpi_backlight=vendor"
#2
sudo kernelstub --add-options "acpi_backlight=native"
#3
echo "Configuracao de backlight ajustada. Verifique abaixo:"
sudo kernelstub --print-config

# CITAÇÃO
# "A coisa sã e sóbria a fazer é pegar no pau pela ponta certa." - G.K. Chesterton


==================================================
### ARQUIVO: ajuste_backlight_acpi.sh ###
==================================================

# DESCRIÇÃO
# Este script ajusta o controle de brilho da tela (backlight) forçando o uso do driver ACPI 'native'.
# É uma solução comum para notebooks, especialmente o Acer Nitro 5, onde a opção 'vendor' pode causar congelamentos ou falhas no controle de brilho.
# O objetivo é garantir que o sistema operacional tenha controle direto e estável sobre a iluminação do painel.

# COMENTÁRIOS
#1: Remove a opção 'acpi_backlight=vendor' das configurações de boot do kernelstub. Esta opção pode entrar em conflito com o hardware de certos notebooks.
#2: Adiciona a opção 'acpi_backlight=native', que entrega ao kernel o controle direto do backlight, geralmente resultando em maior compatibilidade.
#3: Imprime a configuração atual do kernelstub no terminal, permitindo que o usuário confirme que as alterações foram aplicadas corretamente.

# CÓDIGO
#!/bin/bash
#1
sudo kernelstub --remove-options "acpi_backlight=vendor"
#2
sudo kernelstub --add-options "acpi_backlight=native"
#3
echo "Configuracao de backlight ajustada. Verifique abaixo:"
sudo kernelstub --print-config

# CITAÇÃO
# "A coisa sã e sóbria a fazer é pegar no pau pela ponta certa." - G.K. Chesterton


==================================================
