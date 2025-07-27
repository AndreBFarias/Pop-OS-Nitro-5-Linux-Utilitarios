# Pop-OS-Nitro-5-Linux-Utilitarios

Uma coleção de scripts `.sh` e feitiços digitais para resolver problemas pontuais (e alguns nem tão pontuais assim) no Pop!_OS, com um carinho especial para os sofredores que, como eu, possuem um Acer Nitro 5.

Use da forma que quiser. Várias dessas soluções foram criadas na base do ódio e da pesquisa em fóruns obscuros, então creio que possam ajudar a poupar sua sanidade.

---

### Kit de Sobrevivência (Reparo e Soluções Críticas)

> ### `reparo_completo_sistema.sh`
> O botão de pânico nuclear. Para quando tudo mais falhou e você está a um passo de formatar o PC e instalar o Windows de volta. Este ritual de reparo profundo faz uma limpeza radical, reinstala drivers, pacotes essenciais, corrige dependências e tenta trazer seu Pop!_OS de volta do além. Use como último recurso e com fé.

> ### `aplicador_solucoes_nitro5.sh`
> O canivete suíço para qualquer dono de um Acer Nitro 5 no Linux. Ele corrige o controle de brilho que não funciona, ressuscita suas portas USB que morrem do nada, cria a entrada de boot do Windows que o Pop!_OS esqueceu de fazer, e de quebra ainda dá um jeito no Spotify pra você usar o Spicetify. Use e sinta a paz que a Acer não te deu.

> ### `restaurador_audio_pipewire.sh`
> Serve exatamente pra isso: arrumar os drivers de som. Ele exorciza os espectros ectoplásmicos que fazem seu microfone soar como se estivesse dentro de uma garrafa, impede que as ventoinhas do notebook façam cosplay de um tufão na sua chamada e coloca o PipeWire de volta no seu devido lugar.

### Diagnóstico e Inventário

> ### `coletor_geral_logs.sh`
> Quando seu sistema está com uma doença misteriosa e você precisa levá-lo no "Dr. House" de algum fórum gringo. Este script funciona como uma ressonância magnética: ele coleta absolutamente TUDO sobre seu sistema e organiza numa pasta pra você poder enviar pra quem entende do assunto (ou fingir que entende).

> ### `diagnostico_focado_erros.sh`
> Se o coletor geral é uma ressonância magnética, este aqui é o termômetro. Ele faz uma varredura rápida e focada nos pontos vitais: erros de boot, serviços que falharam, problemas no servidor gráfico... Perfeito pra ter uma ideia do tamanho do estrago sem se afogar em mil linhas de log.

> ### `gerador_inventario_software.sh`
> Você sequer lembra de tudo que já instalou nessa máquina desde 2018? Este é o "Inquisidor". Ele vasculha seu sistema em busca não só dos pacotes oficiais (APT, Flatpak, Snap), mas também de AppImages perdidas e programas instalados na mão. Descubra os fantasmas que habitam seu disco rígido.

> ### `verificador_integridade_pre-boot.sh`
> Fez uma alteração crítica no sistema e agora está com medo de reiniciar? Este é o seu "amuleto de proteção". Ele faz uma checagem final nos componentes vitais do boot e da interface gráfica pra te dar um pingo a mais de confiança antes de apertar o botão de "reiniciar" e começar a rezar.

### Utilitários de Sistema e Arquivos

> ### `arquiteto_de_diretorios.sh`
> Sua pasta de "Downloads" parece uma zona de guerra? Este é o arquiteto que vai trazer ordem ao caos. É um assistente interativo que te ajuda a organizar tudo em pastas bonitinhas. O melhor de tudo? Ele tem um modo de simulação pra você ver o resultado antes de mover qualquer coisa e um gerenciador de duplicatas que usa a lixeira. À prova de leigos e de arrependimentos.

> ### `backup_particao_efi.sh`
> A partição EFI é o porteiro do seu sistema. Se ele sumir, você não entra. Este script é sua apólice de seguro digital: ele cria um backup versionado do porteiro e de todas as chaves dele. Reze pra nunca precisar usar, mas tenha-o sempre por perto.

> ### `exportador_lista_pacotes.sh`
> Vai formatar ou quer replicar seu ambiente em outra máquina? Este script é o "cartório" do seu sistema. Ele gera um manifesto completo de tudo que você tem instalado via APT, Flatpak e Snap. Praticamente uma certidão de nascimento do seu setup para facilitar futuras reinstalações.

> ### `removedor_seguro_diretorio.sh`
> Para aquele momento de "tenho certeza que posso apagar isso... eu acho". Em vez de usar o `rm -rf` e se arrepender para sempre, este script (que serve como um modelo) move o diretório alvo para a lixeira do sistema. Te dá a satisfação da limpeza com a segurança de poder voltar atrás.

### Customização e Estética

> ### `unificador_temas_dracula.sh`
> Você instala seu tema gótico trevoso favorito, e os apps em Flatpak continuam parecendo o Windows 95. Este feitiço de unificação força TODO o sistema a obedecer sua escolha estética, aplicando o tema de ícones, cursor e GTK até na alma dos Flatpaks rebeldes.

> ### `instalador_extensoes_gnome.sh`
> Deixar o GNOME puro é como comer arroz sem feijão: funciona, mas falta alma. Este script instala uma lista curada de extensões essenciais (a maioria do próprio Pop!_OS) de uma só vez, pra deixar seu desktop funcional e bonito sem precisar peregrinar pelo site do GNOME.

> ### `ajuste_backlight_acpi.sh`
> Sabe quando o controle de brilho do seu notebook resolve tirar férias e te deixa no escuro (ou cego)? Este script dá um tapa no ACPI e o força a usar o modo 'native', que geralmente resolve o problema de uma vez por todas. Seus olhos agradecem.

---

Se gostar de algo, deixa uma estrela aí. Cada script desses tem umas boas horas de pesquisa e raiva investidas, como se eu fosse um engenheiro da Acer tentando consertar os próprios produtos, mas sem receber nada em troca. =D

