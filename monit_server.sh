#! /usr/bin/env bash

if [[ -e monit.txt ]]
  then
     rm monit.txt 
  else
     echo "non esiste monit.txt"
fi

if [[ -e monit.html ]]
  then
     rm monit.html 
  else
     echo "non esiste monit.html"
fi

monit(){
echo "chi è loggato"
w
echo "primi trenta processi che consumano memoria"
top -bc -o +%MEM | head -n 30| column -t
echo "primi trenta processi per durata"
top -bc -o TIME+ | head -30
echo "temperatura"
tail -10 temp_*.txt
echo "rete"
ifstat  1 10
echo "spazio disco (df -h)"
df -h
}

# ssh s01 "bash -s" -- < ./monit_server.sh 

monit_ssh(){
echo "--------------------------"
echo "       SERVER 72          "
echo "--------------------------"
#"ssh -t   bash --noprofile" serve per non vedere il banner che ho impostato per tutti gli utenti 
ssh -t 72 bash --noprofile << EOF
    $(typeset -f monit)
    monit
EOF
echo "--------------------------"
echo "       SERVER 73          "
echo "--------------------------"
ssh -t 73 bash --noprofile << EOF
    $(typeset -f monit)
    monit
EOF
echo "--------------------------"
echo "       SERVER 74          "
echo "--------------------------"
ssh -t 74  bash --noprofile << EOF
    $(typeset -f monit)
    monit
EOF
echo "--------------------------"
echo "       SERVER 75          "
echo "--------------------------"
ssh -t 75  bash --noprofile << EOF
    $(typeset -f monit)
    monit
EOF
echo "--------------------------"
echo "       NUOVOSTORAGE       "
echo "--------------------------"
ssh -t ns  bash --noprofile << EOF
    $(typeset -f monit)
    monit
EOF
echo "--------------------------"
echo "        STORAGE 01        "
echo "--------------------------"
ssh -t s01 bash --noprofile << EOF
    $(typeset -f monit)
    monit
EOF

#ssh barcellona << EOF
#    $(typeset -f monit)
#    monit
#EOF


}

#./monit_server.sh >> monit.txt; textutil -convert html monit.txt -output monit.html; open monit.html

monit_ssh >> monit.txt; textutil -convert html -font Times -fontsize 20  monit.txt -output monit.html; open monit.html

