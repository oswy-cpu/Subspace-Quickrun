#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}

sudo systemctl stop subspaced subspaced-farmer
sudo systemctl disable subspaced-node subspaced-farmer
sleep 2
rm -rf /usr/local/bin/subspace*
echo "---------------------------------------------------"
echo -e "\e[32mЩас конфиг пофиксим: \e[0m" && sleep 2
rm /etc/systemd/system/subspaced.service
sleep 3

source ~/.bash_profile
sleep 1

sudo tee <<EOF >/dev/null /etc/systemd/system/subspaced.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-node) --chain gemini-1 --wasm-execution compiled --execution wasm --pruning 1024 --keep-blocks 1024 --validator --name $SUBSPACE_NODENAME
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" >/dev/null /etc/systemd/system/


echo "---------------------------------------------------"
echo -e "\e[32mКачаю новую версию: \e[0m" && sleep 2

wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-08/subspace-node-ubuntu-x86_64-gemini-1b-2022-jun-08
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-08/subspace-farmer-ubuntu-x86_64-gemini-1b-2022-jun-08
sudo mv subspace* /usr/local/bin/
sudo chmod +x /usr/local/bin/subspace*

echo "---------------------------------------------------"
echo -e "\e[32mЗапускаю: \e[0m" && sleep 2

sudo systemctl restart systemd-journald
systemctl daemon-reload
sudo systemctl start subspaced subspaced-farmer
sudo systemctl restart subspaced
sleep 10
sudo systemctl restart subspaced-farmer

echo "==================================================="
echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `service subspaced status | grep active` =~ "running" ]]; then
  echo -e "Your Subspace node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice subspaced status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Subspace node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
sleep 2
echo "==================================================="
echo -e '\n\e[42mCheck farmer status\e[0m\n' && sleep 1
if [[ `service subspaced-farmer status | grep active` =~ "running" ]]; then
  echo -e "Your Subspace farmer \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice subspaced-farmer status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Subspace farmer \e[31mwas not installed correctly\e[39m, please reinstall."
fi

rm $HOME/geminiupdate.sh
