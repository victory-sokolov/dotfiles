# Installing Tutorial: https://itsfoss.com/install-postgresql-ubuntu/

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install postgresql postgresql-contrib

# Add the GPG key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update