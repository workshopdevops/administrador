#!/bin/sh
############

function stop (){
echo " Listando Containers ativos:"
docker ps --format "table {{.ID}}   {{.Names}}"
sleep 2
echo "-------------------------------------------------"
echo
echo " Os containers a seguir serao parados e removidos:" ; docker ps --format "table {{.Names}}" | tail -n1
echo
echo " Parando..." ; docker ps -qa | while read line ; do docker stop $line ; done && echo "OK" || echo "ERRO"
sleep 2
echo
echo " Removendo Containers parados:" ; docker rm -v $(docker ps -a -q -f status=exited) 2>/dev/null && echo "OK" || echo "ERRO nao ha containers parados."
sleep 2
echo
echo " Removendo imagens do projeto workshop" ; docker images | grep "$laboratorio" | awk '{print$3}' | while read line ; do docker rmi $line ; done && echo "OK" || echo "Nao ha imagens para remocao."
echo
echo " *** Pronto! ***"
echo
}

function status (){
echo " STATUS DO DOCKER no ambiente $laboratorio"
docker ps
echo
}

function start (){
echo "Construindo imagem de Apache e carregando codigo de desenvolvimento..."
docker build -t apache/$laboratorio . && echo "Imagem Criada com Sucesso!" || echo "Erro ao criar imagem"
echo
docker run --name $laboratorio -p 80:80 -d apache/$laboratorio && echo "Container construido com Sucesso!" || echo "ERRO ao construir container"
echo
}

function main
{
        case $1 in
                status) status;;
                stop) stop;;
                start) start;;
                *) echo ; echo "Erro! Necessario especificar uma das operacoes -> start; stop; status"; echo
        esac
} #end main
clear
# Le a entrada
read -p " Informe o nome do seu laboratorio: " laboratorio
echo
read -p " Informe a acao [ status | start | stop ]: " acao
clear
echo " Voce escolheu $acao para o ambiente $laboratorio"
echo " Executando..."
sleep 4
echo
main $acao $laboratorio
