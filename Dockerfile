FROM ubuntu:trusty-20160819

ENV LAST_RELEASE_URL http://dl.cnezsoft.com/zentao/8.2.6/ZenTaoPMS.8.2.6.zip
ENV LAST_RELEASE_FILENAME ZenTaoPMS.8.2.6

RUN echo "Asia/Shanghai" > /etc/timezone;dpkg-reconfigure -f noninteractive tzdata

COPY sources.list /etc/apt/sources.list
RUN apt-get update

ENV LANG="en_US.UTF8"
RUN echo -e "LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"" > /etc/default/locale
RUN locale-gen en_US.UTF-8

RUN apt-get install -y \
        apache2 \
        php5 \
        net-tools \
        vim \
        telnet \
        wget \
        zip \
        curl \
        php5-mysql \
        php5-mcrypt\
        php5-curl\
        php5-gd && \
     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# download tendaocms
RUN curl -s -fSL $LAST_RELEASE_URL -o /tmp/$LAST_RELEASE_FILENAME && \
    cd /tmp && unzip -q $LAST_RELEASE_FILENAME && \
    mv zentaopms /app && \
    chmod 777  /app/www && \
    sed -i -r 's/(php_*)/#\1/g' /app/www/.htaccess

#COPY default.conf /etc/nginx/sites-available/default.conf
#RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
#    rm /etc/nginx/sites-enabled/default


WORKDIR /app
VOLUME /data

COPY docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
