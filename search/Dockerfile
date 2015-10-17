FROM docker.blinkboxmusic.com/blinkboxmusic/debian:wheezy
RUN apt-get update
RUN apt-get install -y --force-yes bbm-search
EXPOSE 8980 9200 9300
CMD java -jar /usr/share/bbm-search/bbm-search-all.jar server /etc/bbm/bbm-search.yml


#I recommend starting with
#docker run -v <host_dir>:/var/lib/bbm-search/data -d -t --name=search -p 18980:8980 search:latest
# You can skip -v if you don't care about persisting the data through an upgrade