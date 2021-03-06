# bitcoin-testnet-box docker image

# Ubuntu 14.04 LTS (Trusty Tahr)
FROM ubuntu:14.04
LABEL maintainer="Sean Lavine <lavis88@gmail.com>"

# add bitcoind from the official PPA
# install bitcoind (from PPA) and make
RUN apt-get update && \
	apt-get install --yes jq && \
	apt-get install --yes software-properties-common && \
	add-apt-repository --yes ppa:bitcoin/bitcoin && \
	apt-get update && \
	apt-get install --yes bitcoind make

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# copy the testnet-box files into the image
ADD . /home/tester/bitcoin-testnet-box

# make tester user own the bitcoin-testnet-box
RUN chown -R tester:tester /home/tester/bitcoin-testnet-box

# color PS1
RUN mv /home/tester/bitcoin-testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc

# Move liquid binaries
RUN mv /home/tester/bitcoin-testnet-box/liquid/bin/liquidd /usr/bin/liquidd
RUN mv /home/tester/bitcoin-testnet-box/liquid/bin/liquid-cli /usr/bin/liquid-cli
# Add some aliases
RUN echo 'alias e1-cli="liquid-cli -datadir=1"' >> /home/tester/.bashrc && \
	echo 'alias e1-d="liquidd -datadir=1"' >> /home/tester/.bashrc && \
	echo 'alias e2-cli="liquid-cli -datadir=2"' >> /home/tester/.bashrc && \
	echo 'alias e2-d="liquidd -datadir=2"' >> /home/tester/.bashrc
# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/bitcoin-testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]



