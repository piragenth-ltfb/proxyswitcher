#!/bin/bash
function turnOff() {
  gsettings set org.gnome.system.proxy mode 'none' ;
  grep PATH /etc/environment > temp.txt;
  cat temp.txt > /etc/environment;
  printf "" > /etc/apt/apt.conf.d/00aptproxy;
  rm -rf temp.txt;
}

function turnOn(){
  gsettings set org.gnome.system.proxy mode 'manual' ;
  gsettings set org.gnome.system.proxy.http host 'home-server.local';
  gsettings set org.gnome.system.proxy.http port 3128;


  grep PATH /etc/environment > temp.txt;
  printf \
  "http_proxy=http://home-server.local:3128/\n\
  https_proxy=http://home-server.local:3128/\n\
  ftp_proxy=http://home-server.local:3128/\n\
  no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n\
  HTTP_PROXY=http://home-server.local:3128/\n\
  HTTPS_PROXY=http://home-server.local:3128/\n\
  FTP_PROXY=http://home-server.local:3128/\n\
  NO_PROXY=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n" >> temp.txt;

  cat temp.txt > /etc/environment;


  printf \
  "Acquire::http::proxy \"http://home-server.local:3142/\";\n\
  Acquire::ftp::proxy \"ftp://home-server.local:3142/\";\n\
  Acquire::https::proxy \"http://home-server.local:3142/\";\n" > /etc/apt/apt.conf.d/00aptproxy;

  rm -rf temp.txt;
}

if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root";
  exit 1;
fi

if [ $# -eq 1 ]; then
  if [ $1 = "off" ]
    then
    echo "Turning off proxy...";
    turnOff;
    sleep 2;
    echo "Done";
    exit 0;
  else
    echo "Use $0 off : to turn off proxy.";
    exit 1;
  fi
#customadded start
fi
#custom added end

#elif [ $# -eq 2 ]
#  then
#  echo "Setting up proxy with host : $1 and port $2..."
#  turnOn $1 $2
#  sleep 2;
#  echo "Done";
#  exit 0;
#else
#  printf "To set up proxy :\n";
#  printf "Usage : $0 <proxy_ip> <proxy_port>\n";
#  printf "To turn off proxy :\n";
#  printf "Usage : $0 off\n";
#fi
turnOn
