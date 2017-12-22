FROM mtangaro/docker-galaxycloud-full

MAINTAINER ma.tangaro@ibiom.cnr.it

ENV container docker

COPY ["playbook.yaml","/"]

RUN ansible-galaxy install indigo-dc.galaxycloud-tools

RUN echo "localhost" > /etc/ansible/hosts

# start postgresql database
RUN sudo -E -u postgres /usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data -w start

RUN ansible-playbook /playbook.yaml

# stop postgresql database
RUN sudo -E -u postgres /usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data stop

# This overwrite docker-galaxycloud CMD line
CMD /bin/mount -t cvmfs elixir-italy.galaxy.refdata /refdata/elixir-italy.galaxy.refdata; /usr/local/bin/galaxy-startup; /usr/bin/sleep infinity
