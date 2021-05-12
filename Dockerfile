# Building ccminer from source
FROM    opensuse/leap:latest

ENV     REGION="stratum+tcp://verushash.eu.mine.zergpool.com:3300"
ENV     PAYOUT=ARRR
ENV     ADDRESS=
ENV     ID=miner_#1
ENV     THREADS=2

WORKDIR	/tmp

RUN     zypper install -y -t pattern devel_basis \
        && zypper install -y --no-recommends libcurl4 openssl libjansson4 git gcc-c++ automake libcurl-devel libopenssl-devel libjansson-devel \
        && git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git

WORKDIR /tmp/ccminer

RUN     chmod +x build.sh \
        && chmod +x configure.sh && chmod +x autogen.sh \
        && ./build.sh && cp ccminer /usr/bin \
        && zypper rm -y -t pattern devel_basis && zypper rm -y git gcc-c++ automake libcurl-devel libopenssl-devel libjansson-devel && zypper clean
        
WORKDIR /usr/bin

RUN     rm -rf /tmp/ccminer

ENTRYPOINT exec ccminer -a verus -o ${REGION} -u ${ADDRESS} -p c=${PAYOUT},mc=VRSC,ID=${ID} -t ${THREADS}
