FROM ubuntu:trusty

RUN apt-get update; apt-get clean

# Add a user for running applications.
RUN useradd apps
RUN mkdir -p /home/apps && chown apps:apps /home/apps

# Install x11vnc.
RUN apt-get install -y x11vnc

# Install xvfb.
RUN apt-get install -y xvfb

# Install fluxbox.
RUN apt-get install -y fluxbox

# Install wget.
RUN apt-get install -y wget

# Install wmctrl.
RUN apt-get install -y wmctrl

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y install google-chrome-stable

RUN apt-get -y install python-pip python-dev build-essential \
websockify \
&& pip install --upgrade pip \
&& pip install --upgrade virtualenv 

RUN apt -y install novnc python-numpy

RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout novnc.pem -out novnc.pem -days 365 -subj "/C=NO/ST=Sandvika/L=Sandvika/O=TEMP/OU=TEMP/CN=localhost:3000"

RUN apt install curl

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt install -y nodejs

RUN mkdir /var/server \
    /var/server/src \
    /var/server/dist
COPY React-Express-Boilerplate/package.json /var/server/
COPY React-Express-Boilerplate/package-lock.json /var/server/
COPY React-Express-Boilerplate/webpack.config.js /var/server/
COPY React-Express-Boilerplate/src /var/server/src
COPY React-Express-Boilerplate/dist/index.html /var/server/dist/
COPY React-Express-Boilerplate/index.js /var/server/

RUN npm --prefix /var/server/ install
#RUN npm run --prefix /var/server/ build

COPY bootstrap.sh /

EXPOSE 5900
EXPOSE 6080

CMD '/bootstrap.sh'