sudo apt update
sudo apt upgrade
sudo apt autoremove --purge
sudo apt clean
rm -rf ~/.cache/
sudo journalctl --vacuum-time=2days
