#!/bin/bash
echo "Iniciando a rotina..."
date +%d/%m/%y
echo "Removendo lixo da cadeia"
sudo rm -rf /home/pi/Documents/Freechains_2/chains/#transfer
echo "Conectando no forum publico #transfer:"
freechains chains join "#transfer"
echo "Criacao das credenciais do usuario o Node 1..."
node1userpubprivkey=`freechains crypto pubpvt "user node 1"`
node1userprivkey=`echo $node1userpubprivkey | cut -d" " -f2`
node1userpubkey=`echo $node1userpubprivkey | cut -d" " -f1`
echo "A chave privada do usuario do Node1: $node1userprivkey";
echo "A chave publica do usuario do Node1: $node1userpubkey";
#echo "gerando o arquivo soundfree.uue a partir do soundfree2.mp4 usando o uuencode"
#uuencode /home/pi/Documents/Freechains_2/soundfree2.mp4 /home/pi/Documents/Freechains_2/soundRecp.mp4 > /home/pi/Documents/Freechains_2/soundfree.uue
echo "Dividindo o arquivo em blocos de 100K"
split -b 100k -d /home/pi/Documents/Freechains_2/soundfree2.mp4 /home/pi/Documents/Freechains_2/x
echo "Postando na cadeia #transfer com o usuario do node1 a o arquivo midia"
blocks=`ls /home/pi/Documents/Freechains_2/x* | wc -l`
declare -a postchecksum
for ((index=0;index < blocks;index++)) do
    if [ $index -lt 10 ]; 
    then
      postchecksum[index]=`freechains chain "#transfer" post file /home/pi/Documents/Freechains_2/x0$index --sign="$node1userprivkey"`
      echo ${postchecksum[index]}
    else
      postchecksum[index]=`freechains chain "#transfer" post file /home/pi/Documents/Freechains_2/x$index --sign="$node1userprivkey"`
      echo ${postchecksum[index]}
    fi
done
echo "Postando payload de cada bloco"
printf '%s\n' "${postchecksum[@]}"
echo "Reps do usuario do Node1:"
freechains chain "#transfer" reps "$node1userpubkey"
#echo "Obtendo da cadeia o arquivo soundfree.uue"
#freechains chain "#transfer" get payload "$postchecksum" > /home/pi/Documents/Freechains_2/chains/#transfer/temp.uue
echo "Fim da rotina"