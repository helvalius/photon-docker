FROM phusion/baseimage:0.9.16
# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Get latest photon master from github
# RUN git clone https://github.com/komoot/photon.git /photon

RUN mkdir /photon
WORKDIR /photon
EXPOSE 2322

RUN wget http://photon.komoot.de/data/photon-0.2.2.jar

# VOLUME /photon/photon_data
# RUN mvn clean package
# RUN java -jar target/photon-0.2.3-SNAPSHOT.jar

ENTRYPOINT java -jar photon-0.2.2.jar

# Requires nominatim to be running and linked to 'nominatim'
CMD [ "-nomatim-import", "-host", NOMINATIM_NAME,"-port","NOMINATIM_PORT_5432_TCP","-user","docker","-password","docker"]

# java -jar photon-0.2.2.jar -nominatim-import -host 192.168.59.103 -port 32775 -user docker -password docker
