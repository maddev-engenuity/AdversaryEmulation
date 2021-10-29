echo "[*] Setting background image for attacker user"
image_path=$(pwd)
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $image_path/attacker-background.png
