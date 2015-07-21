#!/bin/bash

if [ -z "$RABBIT_HOST" ];then
  echo "error: RABBIT_HOST not set"
  exit 1
fi

if [ -z "$RABBIT_USERID" ];then
  echo "error: RABBIT_USERID not set"
  exit 1
fi

if [ -z "$RABBIT_PASSWORD" ];then
  echo "error: RABBIT_PASSWORD not set"
  exit 1
fi

if [ -z "$KEYSTONE_ENDPOINT" ];then
  echo "error: KEYSTONE_ENDPOINT not set"
  exit 1
fi

if [ -z "$NEUTRON_PASS" ];then
  echo "error: NEUTRON_PASS not set. user neutron password."
  exit 1
fi

if [ -z "$LOCAL_IP" ];then
  echo "error: LOCAL_IP not set. tunel ip."
  exit 1
fi

CRUDINI='/usr/bin/crudini'
    
    $CRUDINI --del /etc/neutron/neutron.conf database connection

    $CRUDINI --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit

    $CRUDINI --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
    $CRUDINI --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid $RABBIT_USERID
    $CRUDINI --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password $RABBIT_PASSWORD

    $CRUDINI --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone

    $CRUDINI --del /etc/neutron/neutron.conf keystone_authtoken

    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://$KEYSTONE_ENDPOINT:5000
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://$KEYSTONE_ENDPOINT:35357
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken auth_plugin password
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken project_domain_id default
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken user_domain_id default
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken project_name service
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken username neutron
    $CRUDINI --set /etc/neutron/neutron.conf keystone_authtoken password $NEUTRON_PASS
    
    $CRUDINI --set /etc/neutron/neutron.conf DEFAULT core_plugin neutron.plugins.ml2.plugin:Ml2Plugin
    $CRUDINI --set /etc/neutron/neutron.conf DEFAULT service_plugins neutron.services.l3_router.l3_router_plugin:L3RouterPlugin
    $CRUDINI --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True

    $CRUDINI --set /etc/neutron/dhcp_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
    $CRUDINI --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
    $CRUDINI --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_delete_namespaces True
    $CRUDINI --del /etc/neutron/dhcp_agent.ini DEFAULT dnsmasq_config_file
 
/usr/bin/supervisord -n