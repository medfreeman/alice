# README

## Requirements
The app expects the following file to exist:

```
# /config/local_env.yml
SECRET:       a4c7741b15a5e23a249c7390cbf3a8b853d8721c4b7b6be8bbe37ef96ec96cae9b04fb634b0b384390de9949cbdeddc3e51044ca531432ff0c7dc202763ff6dc

ASSET_HOST:   http://arpc167.epfl.ch:8080
FTP_SERVER:   arpc167.epfl.ch
FTP_USERNAME: username
FTP_PASSWORD: password
SQL_HOST:     arpc167.epfl.ch
SQL_USERNAME: sql_username
SQL_PASSWORD: sql_password

SMTP_ADDRESS: mail.epfl.ch
DOMAIN:       aliceblogs.epfl.ch:8080
```

It expects mysql to be installed, too.

## Installation instructions:
```
sudo apt-get install ruby
sudo apt-get install git git-core

git clone https://github.com/rubygems/rubygems
cd rubygems/
sudo ruby setup.rb
cd ..

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.profile
source ~/.bashrc
type rbenv

git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install -l

sudo apt-get install curl build-essential zlibc zlib1g-dev zlib1g libcurl4-openssl-dev libssl-dev (libopenssl-ruby) libapr1-dev libaprutil1-dev libreadline6 libreadline6-dev

rbenv install 2.1.5

git clone https://github.com/walidvb/alice.git
cd alice/

gem install bundler
source ~/.bashrc
echo -e 'gem: --no-ri --no-rdoc\n' >> ~/.gemrc
bundle install


# Install our PGP key and add HTTPS support for APT
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install apt-transport-https ca-certificates

# Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

# Install Passenger + Nginx
sudo apt-get install nginx nginx-extras passenger

sudo ln -s /home/aliceblogs/alice/nginx/production.conf /etc/nginx/sites-available/alice-prod
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/alice-prod ./
sudo rm -f /etc/nginx/sites-enabled/default

sudo apt-get install nodejs
RAILS_ENV=production rake db:migrate
rake assets:precompile

TO INSERT in /etc/nginx/nginx.conf

				##
        # Phusion Passenger config
        ##
        # Uncomment it if you installed passenger or passenger-enterprise
        ##

        passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
        passenger_ruby /home/aliceblogs/.rbenv/shims/ruby;
        # passenger_ruby /usr/bin/passenger_free_ruby;


sudo service nginx restart
```
