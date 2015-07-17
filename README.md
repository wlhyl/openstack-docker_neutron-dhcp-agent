# 环境变量
- RABBIT_HOST: rabbitmq IP
- RABBIT_USERID: rabbitmq user
- RABBIT_PASSWORD: rabbitmq user 的 password
- KEYSTONE_ENDPOINT: keystone endpoint
- NEUTRON_PASS: openstack neutron密码
- LOCAL_IP: tunel ip

# volumes:
- /opt/openstack/neutron-plugin-openvswitch-agent/: /etc/neutron
- /opt/openstack/log/neutron-plugin-openvswitch-agent/: /var/log/neutron/

# 启动neutron-plugin-openvswitch-agent
docker run -d --name neutron-plugin-openvswitch-agent \
    -v /opt/openstack/neutron-plugin-openvswitch-agent/:/etc/neutron \
    -v /opt/openstack/log/neutron-plugin-openvswitch-agent/:/var/log/neutron/ \
    -e RABBIT_HOST=10.64.0.52 \
    -e RABBIT_USERID=openstack \
    -e RABBIT_PASSWORD=openstack \
    -e KEYSTONE_ENDPOINT=10.64.0.52 \
    -e NEUTRON_PASS=neutron_pass \
    -e LOCAL_IP=172.168.0.10 \
    10.64.0.50:5000/lzh/neutron-plugin-openvswitch-agent:kilo