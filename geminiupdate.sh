#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}

sudo systemctl stop subspaced subspaced-farmer
sudo systemctl disable subspaced subspaced-farmer

rm -rf /usr/local/bin/subspace*

wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-1b-2022-june-05/subspace-node-ubuntu-x86_64-gemini-1b-2022-june-05
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-1b-2022-june-05/subspace-farmer-ubuntu-x86_64-gemini-1b-2022-june-05
sudo mv subspace* /usr/local/bin/
sudo chmod +x /usr/local/bin/subspace*

echo "---------------------------------------------------"
echo -e "\e[32mStep 4: Starting Node & Farmer: \e[0m" && sleep 2

systemctl daemon-reload
sudo systemctl start subspaced subspaced-farmer

rm $HOME/geminiupdate.sh
