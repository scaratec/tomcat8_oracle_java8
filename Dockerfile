FROM debian:jessie
MAINTAINER Randy Nel Gupta <gupta@scaratec.com>
 
ENV DEBIAN_FRONTEND noninteractive

ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE
ENV LC_ALL C.UTF-8

ENV JAVA_VERSION 8u111
ENV JAVA_MINOR_VERSION b14

ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.6
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
RUN apt-get update && apt-get upgrade -q -y && \
    apt-get update -qq && apt-get install -y locales -qq && locale-gen de_DE.UTF-8 de_de && dpkg-reconfigure locales && \
    dpkg-reconfigure locales && locale-gen de_DE.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8 && \
    apt-get install -y wget curl && \
    cd /opt && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-${JAVA_MINOR_VERSION}/jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
    cd /opt && \
    tar xfvz jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
    rm jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
    cd /opt/jdk* && \
    export JAVA_HOME=`pwd` && \
    update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 200 \
                        --slave /usr/bin/jar jar ${JAVA_HOME}/bin/jar \
                        --slave /usr/bin/jarsigner jarsigner ${JAVA_HOME}/bin/jarsigner \
                        --slave /usr/bin/javac javac ${JAVA_HOME}/bin/javac \
                        --slave /usr/bin/javadoc javadoc ${JAVA_HOME}/bin/javadoc \
                        --slave /usr/bin/javah javah ${JAVA_HOME}/bin/javah \
                        --slave /usr/bin/javap javap ${JAVA_HOME}/bin/javap \
                        --slave /usr/bin/keytool keytool ${JAVA_HOME}/bin/keytool \
                        --slave /usr/bin/javaws javaws ${JAVA_HOME}/bin/javaws && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23 && \
    mkdir -p ${CATALINA_HOME} && cd ${CATALINA_HOME} && \
    curl -SL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -SL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz* && \
    cd /tmp/ && \
    wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem && \
    keytool -import -noprompt -storepass changeit -trustcacerts -alias letsencryptx3crosssigned \
    -file lets-encrypt-x3-cross-signed.pem -keystore ${JAVA_HOME}/jre/lib/security/cacerts && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* 

EXPOSE 8080
CMD ["catalina.sh", "run"]
