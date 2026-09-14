# A imagem nouphet/docker-php4 usa manifest schema 1, removido do Docker atual.
# Compilamos a última versão PHP 4, mantendo o runtime legado (CGI).
FROM debian:bookworm-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf autotools-dev flex bison ca-certificates curl bzip2 \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /build
RUN curl -fsSL https://museum.php.net/php4/php-4.4.9.tar.bz2 -o php.tar.bz2 \
    && echo '2ac502d56ba3360fa4ea2e5c53ea6e35b6367a5654161f9aeec86a549b1656c2  php.tar.bz2' | sha256sum -c - \
    && tar -xjf php.tar.bz2
WORKDIR /build/php-4.4.9
# config.guess/sub atualizados; -fcommon mantém a semântica dos compiladores da época.
RUN cp /usr/share/misc/config.guess /usr/share/misc/config.sub . \
    && CFLAGS='-O2 -fcommon' ./configure --prefix=/usr/local/php4 \
       --with-config-file-path=/usr/local/etc/php --disable-all --disable-cli \
       --enable-cgi --enable-force-cgi-redirect --enable-session --enable-xml \
    && make -j2

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends apache2 \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod actions cgid \
    && mkdir -p /usr/local/etc/php /var/lib/php/session \
    && chown www-data:www-data /var/lib/php/session
COPY --from=build /build/php-4.4.9/sapi/cgi/php /usr/lib/cgi-bin/php4
COPY infra/config/php.ini /usr/local/etc/php/php.ini
COPY infra/config/php-apache.conf /etc/apache2/conf-available/agenda.conf
RUN a2enconf agenda
COPY php/ /var/www/html/
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
