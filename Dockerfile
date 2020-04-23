FROM mcr.microsoft.com/windows/servercore:1903

ARG ES_USER
ARG ES_PASS

ARG JAVA=https://cdn.azul.com/zulu/bin/zulu8.46.0.19-ca-jdk8.0.252-win_x64.zip
ARG ELASTIC_INSTALL_DIR=c:/work/ES
ARG ELASTIC_DATA_DIR=c:/work/ESDATA 
ARG PORT=9200
ARG ES_SERVICE_NAME=elasticsearch-service-x64

WORKDIR c:/work
COPY ./ .
COPY ./log4j2.properties ./zip

SHELL ["powershell.exe", "-Command"]

RUN Invoke-WebRequest -Uri $Env:JAVA -OutFile c:/work/java.zip

RUN Expand-Archive ./java.zip -DestinationPath c:\java; \
    setx /M JAVA_HOME (dir c:/java | ?{$_.PSISContainer} ).Fullname;

RUN .\zip\Configure-TFSSearch.ps1 -Operation install -TFSSearchInstallPath $Env:ELASTIC_INSTALL_DIR -TFSSearchIndexPath $Env:ELASTIC_DATA_DIR -User $Env:ES_USER -Password $ENV:ES_PASS -Quiet -Port $ENV:PORT -$ServiceName $ENV:ES_SERVICE_NAME;

ENV ELASTIC_INSTALL_DIR=${ELASTIC_INSTALL_DIR}
ENV ES_JAVA_OPTS -Xms1800m -Xmx1800m

EXPOSE ${PORT}

ENTRYPOINT [ "powershell.exe ", "./run.ps1", "-InstallPath $ENV:ELASTIC_INSTALL_DIR" ]