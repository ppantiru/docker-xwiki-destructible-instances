# ---------------------------------------------------------------------------
# See the NOTICE file distributed with this work for additional
# information regarding copyright ownership.
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this software; if not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301 USA, or see the FSF site: http://www.fsf.org.
# ---------------------------------------------------------------------------
FROM tomcat:8-jre8

#    ____  ____  ____      ____  _   __        _
#   |_  _||_  _||_  _|    |_  _|(_) [  |  _   (_)
#     \ \  / /    \ \  /\  / /  __   | | / ]  __
#      > `' <      \ \/  \/ /  [  |  | '' <  [  |
#    _/ /'`\ \_     \  /\  /    | |  | |`\ \  | |
#   |____||____|     \/  \/    [___][__|  \_][___]

MAINTAINER Vincent Massol <vincent@massol.net>

# Note: when using docker-compose, the ENV values below are overridden from the .env file.

# Install LibreOffice + other tools
# Note that procps is required to get ps which is used by JODConverter to start LibreOffice
RUN apt-get update && \
  apt-get --no-install-recommends -y install \
    curl \
    libreoffice \
    unzip \
    procps \
    libmysql-java && \
  rm -rf /var/lib/apt/lists/*

# Install XWiki as the ROOT webapp context in Tomcat
# Create the Tomcat temporary directory
# Configure the XWiki permanent directory
ENV XWIKI_VERSION=11.3
ENV XWIKI_URL_PREFIX "http://maven.xwiki.org/releases/org/xwiki/platform/xwiki-platform-distribution-war/${XWIKI_VERSION}"
RUN mkdir -p /usr/local/xwiki/ && \
  mkdir -p /usr/local/tomcat/temp && \
  mkdir -p /usr/local/xwiki/data && \
  rm -rf /usr/local/tomcat/webapps/* && \
  curl -fSL "${XWIKI_URL_PREFIX}/xwiki-platform-distribution-war-${XWIKI_VERSION}.war" -o xwiki.war && \
  unzip -d /usr/local/xwiki xwiki.war && \
  wget http://central.maven.org/maven2/org/tuckey/urlrewritefilter/4.0.3/urlrewritefilter-4.0.3.jar && \
  mv urlrewritefilter-4.0.3.jar /usr/local/xwiki/WEB-INF/lib && \
  ln -sf /usr/local/xwiki/ /usr/local/tomcat/webapps/ROOT && \
  rm -f xwiki.war


# Copy the JDBC driver in the XWiki webapp
RUN cp /usr/share/java/mysql-connector-java-*.jar /usr/local/xwiki/WEB-INF/lib/

# Configure Tomcat. For example set the memory for the Tomcat JVM since the default value is too small for XWiki
COPY tomcat/setenv.sh /usr/local/tomcat/bin/

COPY tomcat/urlrewrite.xml /usr/local/xwiki/WEB-INF/

COPY tomcat/web.xml /usr/local/xwiki/WEB-INF/

COPY hibernate/hibernate.cfg.xml /usr/local/xwiki/WEB-INF/hibernate.cfg.xml

COPY start.sh start.sh

RUN chmod +x start.sh

# Set a specific distribution id in XWiki for this docker packaging.
RUN sed -i 's/<id>org.xwiki.platform:xwiki-platform-distribution-war/<id>org.xwiki.platform:xwiki-platform-distribution-docker/' \
  /usr/local/xwiki/META-INF/extension.xed

RUN apt-get update && \
	apt-get --no-install-recommends -y install \
	mysql-server

# Set up the db
#RUN service mysql start
#RUN mysql -u root -e "create database xwiki default character set utf8 collate utf8_bin"
#RUN mysql -u root -e "grant all privileges on *.* to xwiki@localhost identified by 'xwiki'"



# At this point the image is done and what remains below are the runtime configuration used by the user to configure
# the container that will be created out of the image. Namely the user can override some environment variables with
#   docker run -e "var1=val1" -e "var2=val2" ...
# The supported environment variables that can be overridden are:
# - DB_USER: the name of the user configured for XWiki in the DB. Default is "xwiki". This is used to configure
#            xwiki's hibernate.cfg.xml file.
# - DB_PASSWORD: the password for the user configured for XWiki in the DB. Default is "xwiki". This is used to
#                configure xwiki's hibernate.cfg.xml file.
# - DB_DATABASE: the name of the database to use. Default is "xwiki". This is used to configure xwiki's
#                hibernate.cfg.xml file.
# - DB_HOST: The name of the host (or docker container) containing the database. Default is "db". This is used to
#            configure xwiki's hibernate.cfg.xml file.

# Example:
#   docker run -it -e "DB_USER=xwiki" -e "DB_PASSWORD=xwiki" <imagename>

# Starts XWiki by starting Tomcat. All options passed to "docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]"
# are also passed to docker-entrypoint.sh. If "xwiki" is passed then XWiki will be configured the first time the
# container executes and Tomcat will be started. If some other parameter is passed then it'll be executed to comply
# with best practices defined at https://github.com/docker-library/official-images#consistency.
# ENTRYPOINT ["docker-entrypoint.sh"]
CMD ./start.sh
