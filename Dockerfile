# image name lzh/neutron-dhcp-agent:liberty
FROM registry.lzh.site:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-12-28
ENV OPENSTACK_VERSION liberty
ENV BUILD_VERSION 2015-12-29

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]