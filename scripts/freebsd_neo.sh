#!/bin/sh
#
# Warning! Do not use! 
# I wrote this script in 2005 so it is oboslete.
# I have spent a lot of great time using FreeBSD ;)
#
# Plik: neo
#
# Info:
#  Skrypt startowy  (rc) połączenia dla użytkowników Neostrady.
#
# Parametry:
#  start            - połącz się
#  restart          - restart połączenia (cron)
#  beonline         - stara się zapewnić nieprzerwane połączenie (cron)
#  stop             - zatrzymaj połączenie
#
# Zmienne:  
#  modem_driver     - określa położenie firmware'u
#  ppp_flags        - parametry polecenia ppp
#  modem_run_flags  - parametry polecenia modem_run
#  ...
#
# Konfiguracja:
#  echo 'neo_enable="yes"' >> /etc/rc.conf
#  echo 'modem_driver="/etc/ppp/st330"' >> /etc/rc.conf 
#
# Konfiguracja cron'a:
# */5     *       *       *       *       root    /etc/rc.d/neo beonline
#
# Komentarz: 
#  Paremetry "start" oraz "stop" służą do rozpoczęcia i zakończenia połaczenia.
#  Parametr restart przeznaczony jest do okresowego restartowania połaczenia
#  używając cron'a (tylko z założenia), natomiast "beonline" służy 
#  do restartowania połączenia w przypadku jego utraty (ping), aktualizacji (ppp -ddial) 
#  i również przeznaczony jest dla cron'a.
#
#  Konfiguracja wymaga skopiowania skrytpu do katalogu /etc/rc.d/ 
#  i zdefiniowania w pliku /etc/rc.conf zmiennych neo_enable oraz modem_driver.
#  
#  Dla skryptów startowych wymagających wcześniejszego połączenia z siecią
#  należy zmodyfikować regułę REQUIRE dodając parametr neo.
#
#  milosz.galazka@gmail.com
#
#
# PROVIDE: neo 
# REQUIRE: netif mountcrit local
# KEYWORD: nojail
#

. /etc/rc.subr

modem_driver=${modem_driver:-"/etc/ppp/st330"}

name="neo"
rcvar=`set_rcvar`
extra_commands="beonline" 
start_cmd="neo_start"
stop_cmd="neo_stop"
restart_cmd="neo_start"
beonline_cmd="neo_beonline"


#Polecenia
sh_command=${sh_command:-"/bin/sh"}
kill_command=${kill_command:-"/bin/kill"}
basename_command=${basename:-"/usr/bin/basename"}
xauth_command=${xauth_command:-"/usr/X11R6/bin/xauth"}
hostname_command=${hostname_command:-"/bin/hostname"}
domainname_command=${domainname_command:-"/bin/domainname"}
grep_command=${grep_command:-"/usr/bin/grep"}
ifconfig_command=${ifconfig_command:-"/sbin/ifconfig"}
awk_command=${awk_command:-"/usr/bin/awk"}
expr_command=${expr_command:-"/bin/expr"}
route_command=${route_command:-"/sbin/route"}
chown_command=${chown_command:-"/usr/sbin/chown"}
rm_command=${rm_command:-"/bin/rm"}

modem_run_command=${modem_run_command:-"/usr/sbin/modem_run"}
modem_run_flags=${modem_run_flags:-"-f"}

ppp_command=${ppp_command:-"/usr/sbin/ppp"}
ppp_flags=${ppp_flags:-"-quiet -ddial adsl"}
ppp_iface=${ppp_iface:-"tun0"}

ping_command=${ping_command:-"/sbin/ping"}
ping_flags=${ping_flags:-"-c1"}
ping_host=${ping_host:-"www.wp.pl"}

# Funkcja odpowiedzialna za restart firewall'a
# Wymaga dostrojenia do własnych potrzeb
neo_firewall(){
 $sh_command /etc/rc.firewall
}

# Funkcja odpowiedzialna za wczytanie firmware'u
neo_driver_load(){
 local modem_run_check

 modem_run_check=`check_process $modem_run_command`
 echo -n "Neo driver: "
 if [ -z "$modem_run_check" ]; then
  echo "loading"
  $modem_run_command $modem_run_flags $modem_driver >/dev/null
 else
  echo "already loaded"
 fi
}

# Funkcja sprawdzająca, czy mamy połączenie 
# sprawdzając proces ppp
neo_connection_check(){
 local ppp_check
 
 ppp_check=`check_process $ppp_command`
 if [ -n "$ppp_check" ]; then
  echo "wait"
 fi
}

# Funkcja wywołująca ppp
neo_connection_start(){
 $ppp_command $ppp_flags  2>/dev/null
}

# Funkcja zatrzymująca ppp
neo_connection_stop(){
 local ppp_pid

 ppp_pid=`check_process $ppp_command`
 if [ -n "$ppp_pid" ]; then
  $kill_command $sig_stop $ppp_pid 2>/dev/null
  wait_for_pids $ppp_pid > /dev/null
 fi
}

# Funkcja pobierająca adres ip
# Zwraca pusty string w przypadku niepowodzenia
neo_ip_get(){
 local ip="";
 local ppp_loop=1
 while [ -z "$ip" ] && [ "$ppp_loop" -le 12 ]; do
         sleep 4
         ip=`$ifconfig_command $ppp_iface | $grep_command netmask | $awk_command '/inet/ {print $2}'`
  ppp_loop=`$expr_command $ppp_loop \+ 1`
 done

 if [ "$ppp_loop" -eq "13" ]; then
  echo ""
  exit 1
 fi
 echo $ip
}

# Funkcja odpowiedzialna za czynności po wykonaniu połączenia
# Wymaga dostrojenia do własnych potrzeb
neo_postconfigure(){

 # Pobierz adres IP
 local ip=""
 local hostname=""
 local name_stat=""
 
 ip=`neo_ip_get`

 while [ -z "$ip" ]; do
  echo "Error"
  sleep 10
  exit 1
 done

 echo "IP: " $ip

 # Firewall
 echo "Firewall: configuring"
 neo_firewall 2> /dev/null

 # Pobranie nowej nazwy hosta oraz wywołanie poleceń
 # hostname, domainname
 hostname=""
 while [ -z "$hostname" ]; do
         hostname=`$route_command get $ip | $awk_command  '/route/ {print $3}'`
        
         if [ -n $hostname ]; then       
                 name_stat=`echo $hostname | $grep_command "tpnet.pl"`
                 if [ -z "$name_stat" ]; then
                         hostname=${hostname}.neoplus.adsl.tpnet.pl
                 fi
         else
                 sleep 2
         fi
 done

 echo "Hostname: " $hostname

 $hostname_command $hostname
 $domainname_command $hostname

 # Restart określonych usług po zmianie adresu IP
 #if [ -n "$ppp_restarted" ]; then
 #fi

 # X'y + xauth
 # Aktualizacja .Xauthority
 local xauth_file=/home/milosz/.Xauthority

 local mcookie=`dd if=/dev/urandom bs=16 count=1 2>/dev/null | hexdump -e \\"%08x\\"`
 $rm_command $xauth_file
 $xauth_command -f $xauth_file add $hostname:0 MIT-MAGIC_COOKIE-1 $mcookie 2>/dev/null
 $xauth_command -f $xauth_file add $hostname/unix:0 MIT-MAGIC-COOKIE-1 $mcookie 2>/dev/null

 $chown_command milosz:milosz $xauth_file
}

# Funkcja oficjalnie rozpoczynająca połączenie
neo_start()
{
 local ppp_loop=1
 local ppp_check=""
 local ip=""

 if [ -f "$modem_driver" ]; then
  neo_driver_load
  ppp_check=`neo_connection_check`

  echo -n "Connection: "
  
  if [ -n "$ppp_check" ]; then
   echo "restarting"
   neo_connection_stop
   ppp_restarted=1
   while [ "$ppp_check" = "wait" ]; do 
    if [ "$ppp_loop" -eq "13" ]; then
     echo "Error: IP address not assigned"
     sleep 10
     exit 1
    fi
    sleep 3
    ppp_check=`neo_connection_check`
    ppp_loop=`$expr_command $ppp_loop \+ 1`
   done
  else
   echo "starting"
  fi
  neo_connection_start
  ip=`neo_ip_get`
  echo $ip > /var/run/neo_ip
  neo_postconfigure
 fi 
}

# Funkcja oficjalnie zatrzymująca połączenie
neo_stop(){
 echo "Connection: stopped"
 neo_connection_stop 2>/dev/null
}

# Funkcja sprawdzająca stan połączenia (ping)
neo_ping_check(){
 local ping_check
 ping_check=`$ping_command $ping_flags ${ping_host} 2>/dev/null | $grep_command "1 packets"` 2>/dev/null
 echo $ping_check
}

# Funkcja odpowiedzialna za wznawianie utraconego połączenia
neo_beonline(){
 local ping_check=""
 local ip=""
 local neo_ip
 ping_check=`neo_ping_check` > /dev/null
 if [ -z "$ping_check" ]; then
  echo "Connection lost!"
  neo_start
 else
  ip=`neo_ip_get`
  if [ -f /var/run/neo_ip ] && [ -n `cat /var/run/neo_ip` ]; then
   neo_ip=`cat /var/run/neo_ip`
   if [ "$ip" !=  "$neo_ip" ]; then
    echo $ip > /var/run/neo_ip
    ppp_restarted=1
    neo_postconfigure
   fi
  else
   neo_start
  fi
  
 fi
}

load_rc_config $name
run_rc_command "$1"
