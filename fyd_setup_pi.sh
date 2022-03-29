cd /home/pi

echo Getting Image
wget -q https://github.com/Fydcoin/pi/raw/main/bitcoin.png

echo getting splash image

wget -q https://github.com/Fydcoin/pi/raw/main/fyd_icon.png

cp -r fyd_icon.png splash.png

sudo cp /home/pi/splash.png /usr/share/plymouth/themes/pix/splash.png

echo Changing menu icon
sudo cp /home/pi/bitcoin.png /usr/share/icons/PiXflat/32x32/places/rpi-logo.png

echo commenting lines in pix.script
sudo sed -e '/message_sprite = Sprite();/s/^/#/g' -i /usr/share/plymouth/themes/pix/pix.script
sudo sed -e '/message_sprite.SetPosition(screen_width * 0.1, screen_height * 0.9, 10000);/s/^/#/g' -i /usr/share/plymouth/themes/pix/pix.script
sudo sed -e '/my_image = Image.Text(text, 1, 1, 1);/s/^/#/g' -i /usr/share/plymouth/themes/pix/pix.script
sudo sed -e '/message_sprite.SetImage(my_image);/s/^/#/g' -i /usr/share/plymouth/themes/pix/pix.script

sudo sed -i '1 i\disable_splash=1' /boot/config.txt

sudo sed -i "1 s|$| logo.nologo vt.global_cursor_default=0|" /boot/cmdline.txt

sudo systemctl disable getty@tty1.service

cp /lib/firmware/raspberrypi/bootloader/beta/pieeprom-2020-09-03.bin pieeprom.bin

rpi-eeprom-config pieeprom.bin > config.txt

sudo sed -i 's/DISABLE_HDMI=0/DISABLE_HDMI=1/g' config.txt

rpi-eeprom-config --out pieeprom-out.bin --config config.txt pieeprom.bin

sudo rpi-eeprom-update -d -f ./pieeprom-out.bin


echo Installing Unified Remote
wget -O urserver.deb http://www.unifiedremote.com/d/rpi-deb
sudo dpkg -i urserver.deb
sudo /opt/urserver/urserver-start

mkdir Bootstrap
cd Bootstrap
echo -e "Downloading Bootstrap \n"
wget https://github.com/Fydcoin/FYDCoin/releases/download/V2.0.0/BootStrap_oct25.zip
echo -e "Bootstrap Downloaded\n"

unzip BootStrap_oct25.zip

cd /home/pi/
wget -q https://github.com/Fydcoin/pi/raw/main/resp_deb.zip

unzip resp_deb.zip
cd resp_deb
rm -rf resp_deb.zip
chmod 777 fyd*
./fydd -daemon
sleep 10

./fyd-cli stop

cd ..

cd Bootstrap/BootStrap_oct25/
echo -e "Copying Bootstrap for quick sync \n"

cp -r blocks/ /home/pi/.fyd/.
cp -r chainstate/ /home/pi/.fyd/.
cp -r peers.dat /home/pi/.fyd/.

cd /home/pi/Desktop
echo -e "Download desktop image"
wget -q https://www.dropbox.com/s/anwjef473hr214k/fyd-qt
chmod 777 fyd-qt

echo -e "Cleaning up Desktop, Removing unwanted files::"
rm -rf Bootstrap

echo -e "Use fyd-qt to run Desktop Wallet !!"
