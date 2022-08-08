#!/bin/bash
# A Sentinela que garante a paz no reino.

# Aguarda alguns segundos para a área de trabalho carregar completamente.
sleep 10

# Força o coração da Nvidia a bater com força total.
nvidia-settings -a '[gpu:0]/GpuPowerMizerMode=1'

# Ordena ao reino que permaneça em modo de Desempenho.
system76-power profile performance

