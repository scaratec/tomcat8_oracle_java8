#Apache Tomcat 8 running on Oracle Java 8

This is the first version of a Docker container
with Apache Tomcat 8 and Oracle Java 8 on Debian Jessie.

**[APR](http://tomcat.apache.org/tomcat-8.0-doc/apr.html)** is not yet configured!

To build run:

    sudo docker build -t tomcat8 .
    
**Remember:** Tomcat has many hooks for configuration and you should definitely use them!

To launch tomcat:

    sudo docker run -d --name tomcat8 -p 8080:8080 tomcat8

To adjust the launch parameters:

    sudo docker cp tomcat8:/opt/tomcat/bin/catalina.sh ./
    
Edit `catalina.sh`. Adjust memory etc. according to you needs, and NO the defaults are NOT okay. You need to test is with tools like [VisualVM](http://visualvm.java.net/). You need to adjust tomcat accordingly. It totally depends on you application.

Stop and remove the running container and then start the container with your customized `catalina.sh` mounted:

    sudo docker run -d --name tomcat8 -p 8080:8080 -v `pwd`/catalina.sh:/opt/tomcat/bin/catalina.sh tomcat8

I recommend that you do the same for

    /opt/tomcat/webapps
    /opt/tomcat/conf
    /opt/tomcat/logs
    
You can then start the container like this:

    sudo docker run -d --name tomcat8 -p 8080:8080 \
                -v `pwd`/catalina.sh:/opt/tomcat/bin/catalina.sh \
                -v `pwd`/webapps:/opt/tomcat/webapps \
                -v `pwd`/conf:/opt/tomcat/conf \
                -v `pwd`/logs:/opt/tomcat/logs \
                tomcat8        
                
You can now point your browser to [http://localhost:8080/](http://localhost:8080/). When you like to change some of your configuration simply stop the container:

    sudo docker stop tomcat8
    
Change whatever you like and start the container again:

    sudo docker start tomcat8
    
    
       