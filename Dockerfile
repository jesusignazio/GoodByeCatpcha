# Build the Docker container by running "docker build ." in the same folder as
# Dockerfile. After the build is complete, run "docker images" and copy the
# most recent create image. Then run the command "docker run -i -t COPIEDIMAGE"
# which will place you in the shell of the newly created container.
# All files are located in /goodbyecaptcha.


# This Dockerfile assumes all required files/folders are in the relative
# folder:
# - goodbyecaptcha.yaml
# - app.py
# You may want to add proxies.txt at the bottom of this file.

# We are using Ubuntu 16.04 for the base Docker image
FROM ubuntu:16.04

# This installs all the required packages for Python3.6, Chrome, and
# Pocketsphinx
RUN apt-get update \
    && apt-get install -y \
    libpangocairo-1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libcups2 \
    libxss1 \
    libxrandr2 \
    libgconf-2-4 \
    libasound2 \
    libasound2-dev \
    libatk1.0-0 \
    libgtk-3-0 \
    gconf-service \
    libappindicator1 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpulse-dev \
    libstdc++6 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxfixes3 \
    libxrender1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    lsb-release \
    xdg-utils \
    build-essential \
    ffmpeg \
    swig \
    software-properties-common curl \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get remove -y software-properties-common \
    && apt autoremove -y \
    && apt-get update \
    && apt-get install -y python3.6 python3.6-dev \
    && curl -o /tmp/get-pip.py "https://bootstrap.pypa.io/get-pip.py" \
    && python3.6 /tmp/get-pip.py \
    && apt-get remove -y curl \
    && apt autoremove -y \
    && pip install goodbyecaptcha
RUN pip install sanic json-api

# Copies required files for running nonoCAPTCHA to the Docker container.
# You can comment out pocketsphinx if you aren't using Pocketsphinx.
RUN mkdir /goodbyecaptcha
WORKDIR /goodbyecaptcha
#ADD pocketsphinx /goodbyecaptcha/pocketsphinx
ADD goodbyecaptcha.yaml /goodbyecaptcha
# ADD proxies.txt /goodbyecaptcha/proxies.txt

# This determines which file you want to copy over to the Docker container,
# by default the aiohttp server is copied to the container.
ADD app.py /goodbyecaptcha

# Uncomment the lines below if you want to autostart the app and expose the
# port on your machine, which can be accessed by going to http://localhost:5000
EXPOSE 5000
CMD ["python3.11", "/goodbyecaptcha/examples/app.py"]
