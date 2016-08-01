#############################################################
# Archivo Dockerfile para ejecutar apache Spark
# Basado en una imagen de Ubuntu
#############################################################

# Establece la imagen de base a utilizar para Ubuntu
FROM ubuntu:14.04

# Establece el autor (maintainer) del archivo (tu nombre - el autor del archivo)
MAINTAINER Mario <100292688@alumnos.uc3m.es>

# Actualización de la lista de fuentes del repositorio de aplicaciones por defecto
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get install python -y  && \
    apt-get install -y git && \
    apt-get install -y curl && \
    apt-get install -y python-numpy && \
    apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/
RUN wget http://ftp.cixug.es/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN tar xzvf apache-maven-3.3.9-bin.tar.gz -C /usr/local/src/
ENV export PATH=/usr/local/src/apache-maven-3.3.9/bin:$PATH
RUN wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz
RUN mkdir /usr/local/src/scala
RUN tar xvf scala-2.10.4.tgz -C /usr/local/src/scala/
ENV SCALA_HOME /usr/local/src/scala/scala-2.10.4
ENV export PATH $SCALA_HOME/bin:$PATH
RUN wget http://ftp.cixug.es/apache/spark/spark-1.6.1/spark-1.6.1.tgz
RUN mkdir /usr/local/src/spark
RUN tar xvf spark-1.6.1.tgz -C /usr/local/src/spark/
ENV SPARK_HOME /usr/local/src/spark/spark-1.6.1
#ENV export PATH $SPARK_HOME/bin:$PATH
RUN ln -s /usr/local/src/spark/spark-1.6.1/project/ /project
RUN ln -s /usr/local/src/spark/spark-1.6.1/build/ /
RUN cd usr/local/src/spark/spark-1.6.1/ && build/sbt -Pyarn -Phadoop-2.3 assembly
#RUN /usr/local/src/spark/spark-1.6.1/make-distribution.sh
RUN rm scala-2.10.4.tgz
RUN rm spark-1.6.1.tgz
RUN rm apache-maven-3.3.9-bin.tar.gz
ENV export PATH=/usr/local/src/spark/spark-1.6.1/bin:$PATH
ENV export PATH=/usr/local/src/scala/scala-2.10.4/bin:$PATH

#ADD init-spark.sh /init-spark.sh
#RUN chmod -v +x /init-spark.sh
#CMD ["/init-spark.sh"]

#assembly apt-cache search maven && apt-get install -y maven