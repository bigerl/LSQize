FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qq install -y git openjdk-11-jdk maven wget

RUN git clone --depth 1 --recurse-submodules --shallow-submodules -b develop https://github.com/AKSW/LSQ.git

WORKDIR LSQ

RUN wget https://raw.githubusercontent.com/dice-group/iswc2020_tentris/master/queries/SWDF-Queries.txt

RUN mvn install -Dmaven.test.skip=true

# openjdk-8-jre-headless seems to be a dependency of the .deb
# the already installed openjdk-11-jdk isn't sufficient
RUN apt-get -qq install -y  openjdk-8-jre-headless

RUN dpkg -i `find 'lsq-debian-cli/target/' -name 'lsq-cli_*.deb'`

# this produces
# WARNING: Illegal reflective access by org.aksw.jena_sparql_api.mapper.proxy.MapperProxyUtils (file:/usr/share/lib/lsq-cli/lsq-debian-cli-2.0.0-SNAPSHOT-jar-with-dependencies.jar) to constructor java.lang.invoke.MethodHandles$Lookup(java.lang.Class)
# RUN lsq analyze --help

RUN lsq analyze SWDF-Queries.txt > SWDF-Queries-LSQ-analyze.ttl

