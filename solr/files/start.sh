#!/bin/bash

/usr/bin/jsvc -cp /usr/share/java/commons-daemon.jar:/usr/share/jetty/start.jar:/usr/share/jetty/start-daemon.jar:/usr/lib/jvm/default-java/lib/tools.jar -outfile /var/log/jetty/out.log -errfile /var/log/jetty/out.log -pidfile /var/run/jetty.pid -Xmx8g -Djava.awt.headless=true -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=55556 -Dcom.sun.management.jmxremote.password.file=/etc/jetty/jmxremote.password -Dcom.sun.management.jmxremote.ssl=false -XX:+UseConcMarkSweepGC -Djava.io.tmpdir=/var/cache/jetty/data -DSTART=/etc/jetty/start.config -Djetty.home=/usr/share/jetty -Djetty.logs=/var/log/jetty -Djetty.host=0.0.0.0 -Djetty.port=8880 org.mortbay.jetty.start.daemon.Bootstrap /etc/jetty/jetty-logging.xml /etc/jetty/jetty.xml /etc/jetty/jetty-shared-webapps.xml 
tail -F /var/log/jetty/out.log

