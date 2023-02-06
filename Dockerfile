# Dockerfile
#FROM python:3.8
#WORKDIR /fastApiForTests
#COPY . /fastApiForTests
#RUN python -m pip install --upgrade pip
#RUN pip install -r requirements.txt
#EXPOSE 8000
#ENTRYPOINT ["./docker-entrypoint.sh"]

FROM python:3.8

RUN apt-get update -y
# We need wget to set up the PPA and xvfb to have a virtual screen and unzip to install the Chromedriver
RUN apt-get install -y wget xvfb unzip
# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
# Update the package list and install chrome
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable
# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 97.0.4692.71
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR
# Download and install Chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR
# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH
WORKDIR /fastApiForTests
COPY . /fastApiForTests
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt
EXPOSE 8000
ENTRYPOINT ["./docker-entrypoint.sh"]