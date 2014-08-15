#!/usr/bin/env perl

# This Perl script is used to stage the CCSP Simulator for the PC platform.

use strict;
use warnings;

use File::Path;
use File::Copy;
use Cwd;

my @src = (
    [ '../hal/lib/libhal_cm.so', 'lib' ],
    [ '../hal/lib/libhal_mta.so', 'lib' ],
    [ '../hal/lib/libhal_wifi.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libcrypto.a', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libcrypto.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libcrypto.so.0.9.8', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libssl.a', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libssl.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libssl.so.0.9.8', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/curl-7.28.1/lib/.libs/libcurl.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/curl-7.28.1/lib/.libs/libcurl.so.4', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/curl-7.28.1/lib/.libs/libcurl.so.4.3.0', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.a', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.la', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.so.3', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.so.3.5.7', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/fcgi-2.4.0/libfcgi/.libs/libfcgi.a', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/ixml/.libs/libixml.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/ixml/.libs/libixml.so.2', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/ixml/.libs/libixml.so.2.0.4', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/helpers/.libs/libnetsnmphelpers.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/helpers/.libs/libnetsnmphelpers.so.30', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/helpers/.libs/libnetsnmphelpers.so.30.0.1', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpmibs.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpmibs.so.30', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpmibs.so.30.0.1', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpagent.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpagent.so.30', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpagent.so.30.0.1', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/snmplib/.libs/libnetsnmp.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/snmplib/.libs/libnetsnmp.so.30', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/snmplib/.libs/libnetsnmp.so.30.0.1', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/apps/.libs/libnetsnmptrapd.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/apps/.libs/libnetsnmptrapd.so.30', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/apps/.libs/libnetsnmptrapd.so.30.0.1', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/AGENTX-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/BRIDGE-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-EVENT-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-EXPRESSION-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-NSLOOKUP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-PING-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-SCHEDULE-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-SCRIPT-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-TRACEROUTE-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/EtherLike-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/HCNUM-TC.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/HOST-RESOURCES-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/HOST-RESOURCES-TYPES.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANA-ADDRESS-FAMILY-NUMBERS-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANAifType-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANA-LANGUAGE-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANA-RTPROTO-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IF-INVERTED-STACK-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IF-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/INET-ADDRESS-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IP-FORWARD-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-FLOW-LABEL-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-ICMP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-TCP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-TC.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-UDP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/LM-SENSORS-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/MTA-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-AGENT-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-EXAMPLES-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-EXTEND-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-MONITOR-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-PASS-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-PERIODIC-NOTIFY-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-SYSTEM-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-TC.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-VACM-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NETWORK-SERVICES-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NOTIFICATION-LOG-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RFC1155-SMI.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RFC1213-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RFC-1215.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RMON-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SCTP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SMUX-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-COMMUNITY-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-FRAMEWORK-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-MPD-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-NOTIFICATION-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-PROXY-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-TARGET-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-TLS-TM-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-TSM-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-USER-BASED-SM-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-USM-AES-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-USM-DH-OBJECTS-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-CONF.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-SMI.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-TC.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-TM.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-VIEW-BASED-ACM-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/TCP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/TRANSPORT-ADDRESS-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/TUNNEL-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-DEMO-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-DISKIO-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-DLMOD-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-IPFILTER-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-IPFWACC-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-SNMP-MIB-OLD.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-SNMP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UDP-MIB.txt', 'mibs' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/threadutil/.libs/libthreadutil.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/threadutil/.libs/libthreadutil.so.2', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/threadutil/.libs/libthreadutil.so.2.2.3', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/upnp/.libs/libupnp.so', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/upnp/.libs/libupnp.so.3', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/upnp/.libs/libupnp.so.3.0.5', 'lib' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/bus/dbus-daemon', '.' ],
    [ '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/snmpd', '.' ],
    [ '../CcspLMLite/lib/liblmapi.so', 'lib' ],
    [ '../CcspCommonLibrary/source/util_api/ccsp_msg_bus/basic.conf', 'usr/ccsp' ],
    [ '../CcspCommonLibrary/source/util_api/ccsp_msg_bus/ccsp_msg.cfg', 'usr/ccsp' ],
    [ '../CcspCr/bin/CcspCrSsp', 'usr/ccsp' ],
    [ '../CcspMisc/bin/dmcli', 'usr/ccsp' ],
    [ '../CcspMisc/bin/psmcli', 'usr/ccsp' ],
    [ '../CcspCommonLibrary/scripts/cli_start_pc.sh', 'usr/ccsp' ],
    [ '../CcspCommonLibrary/scripts/cosa_start_pc.sh', 'usr/ccsp' ],
    [ '../CcspCr/config/cr-deviceprofile_pc.xml', 'usr/ccsp' ],
    [ '../CcspCommonLibrary/lib/libccsp_common.so', 'usr/ccsp' ],
    [ '../CcspPsm/bin/PsmSsp', 'usr/ccsp' ],
    [ '../CcspCMAgent/bin/CcspCMAgentSsp', 'usr/ccsp/cm' ],
    [ '../CcspCMAgent/lib/libcm_tr181.so', 'usr/ccsp/cm' ],
    [ '../CcspCMAgent/config/CcspCMDM_pc.cfg', 'usr/ccsp/cm' ],
    [ '../CcspCMAgent/config/CcspCM_pc.cfg', 'usr/ccsp/cm' ],
    [ '../CcspCMAgent/config/TR181-CM_pc.XML', 'usr/ccsp/cm' ],
    [ '../CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/cm' ],
    [ '../CcspPsm/config/bbhm_def_cfg_pc.xml', 'usr/ccsp/config' ],
    [ '../CcspLMLite/bin/CcspLMLite', 'usr/ccsp/lm' ],
    [ '../CcspLMLite/lib/liblmapi.so', 'usr/ccsp/lm' ],
    [ '../CcspMtaAgent/bin/CcspMtaAgentSsp', 'usr/ccsp/mta' ],
    [ '../CcspMtaAgent/lib/libmta_tr181.so', 'usr/ccsp/mta' ],
    [ '../CcspMtaAgent/config/CcspMtaAgent_pc.xml', 'usr/ccsp/mta' ],
    [ '../CcspMtaAgent/config/CcspMta_pc.cfg', 'usr/ccsp/mta' ],
    [ '../CcspMtaAgent/config/CcspMtaLib_pc.cfg', 'usr/ccsp/mta' ],
    [ '../CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/mta' ],
    [ '../CcspPandM/bin/CcspPandMSsp', 'usr/ccsp/pam' ],
    [ '../CcspPandM/lib/libtr181.so', 'usr/ccsp/pam' ],
    [ '../CcspPandM/config/CcspDmLib_pc.cfg', 'usr/ccsp/pam' ],
    [ '../CcspPandM/config/CcspPam.cfg', 'usr/ccsp/pam' ],
    [ '../CcspPandM/config/COSAXcalibur.XML', 'usr/ccsp/pam' ],
    [ '../CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/pam' ],
    [ '../RebootManager/bin/CcspRmSsp', 'usr/ccsp/rm' ],
    [ '../RebootManager/config/RebootManager_pc.xml', 'usr/ccsp/rm' ],
    [ '../CcspSnmpPa/lib/libsnmp_plugin.so', 'usr/ccsp/snmp/libs' ],
    [ '../CcspSnmpPa/config/snmpd.conf', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/scripts/run_snmpd.sh', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/scripts/run_subagent.sh', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_CLAB-WIFI-MIB.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/CcspMibList.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-DeviceMgmt.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Hotspot.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Lan-Dhcp.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-MoCA.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-NTP.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-routing.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Tr069Pa.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Vlan.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-WanDns.xml', 'usr/ccsp/snmp' ],
    [ '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-WiFi-MIB.xml', 'usr/ccsp/snmp' ],
    [ '../CcspTr069Pa/bin/CcspTr069PaSsp', 'usr/ccsp/tr069pa' ],
    [ '../CcspTr069Pa/config/ccsp_tr069_pa_certificate_cfg_pc.xml', 'usr/ccsp/tr069pa' ],
    [ '../CcspTr069Pa/config/ccsp_tr069_pa_cfg_pc.xml', 'usr/ccsp/tr069pa' ],
    [ '../CcspTr069Pa/config/ccsp_tr069_pa_mapper_pc.xml', 'usr/ccsp/tr069pa' ],
    [ '../CcspTr069Pa/config/sdm.xml', 'usr/ccsp/tr069pa' ],
    [ '../CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/tr069pa' ],
    [ '../TestAndDiagnostic/bin/CcspTandDSsp', 'usr/ccsp/tad' ],
    [ '../TestAndDiagnostic/lib/libdiagnostic.so', 'usr/ccsp/tad' ],
    [ '../TestAndDiagnostic/lib/libdmltad.so', 'usr/ccsp/tad' ]
);

# Note: add [ '../hal/lib/libmoca_mgnt.so', 'lib' ] to src array when it is building again.
#       add [ '../CcspSnmpPa/build-pc-rdkb/snmp_custom.so', 'usr/ccsp/snmp/libs' ] to src array when it is building again.
#       add [ '../CcspSnmpPa/build-pc/snmp_subagnet', 'usr/ccsp/snmp' ] to src array when it is building again.

# Staging HOME directory.
my $STAGE_ROOT = "";

sub createDir {
    my $directory = $STAGE_ROOT . $_[0];
    print "Creating $directory ...\n";

    unless(-e $directory || mkpath($directory)) {
	die "ERROR: Unable to create $directory.\n";
    }
};

sub copyFile {
    my $src = shift;
    my $dest = shift;
    print "Copying $src to $dest ...\n";

    unless(copy($src, $dest)) {
        die "ERROR: Unable to copy $src to $dest.\n";
    }
};

sub main {
    # Validate that src files exist.
    for my $ref (@src) {
	my $file = $STAGE_ROOT . @$ref[0];
        unless (-e $file) {
	    die "ERROR: Source file $file does not exist.\n";
	}
    }

    # Create staging directory structure.
    createDir("usr/ccsp");
    createDir("usr/ccsp/cm");
    createDir("usr/ccsp/config");
    createDir("usr/ccsp/lm");
    createDir("usr/ccsp/mta");
    createDir("usr/ccsp/pam");
    createDir("usr/ccsp/rm");
    createDir("usr/ccsp/snmp");
    createDir("usr/ccsp/snmp/libs");
    createDir("usr/ccsp/tad");
    createDir("usr/ccsp/tr069pa");
    createDir("mibs");
    createDir("lib");

    # Copy the files over to the staging directory.
    for my $ref (@src) {
	my $source = $STAGE_ROOT . @$ref[0];
	my $destination = $STAGE_ROOT . @$ref[1];
	#print "Source: " . $source . "\n";
	#print "Destination: " . $destination . "\n";
	copyFile($source, $destination);
    }

    # Fix file permissions.
    chmod 0755, $STAGE_ROOT . "dbus-daemon";
    chmod 0755, $STAGE_ROOT . "snmpd";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/basic.conf";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/CcspCrSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/dmcli";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/psmcli";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/ccsp_msg.cfg";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cli_start_pc.sh";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cosa_start_pc.sh";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/libccsp_common.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/PsmSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cm/CcspCMAgentSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cm/libcm_tr181.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cm/CcspCMDM_pc.cfg";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cm/CcspCM_pc.cfg";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/cm/ccsp_msg_pc.cfg";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/lm/CcspLMLite";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/lm/liblmapi.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/mta/CcspMtaAgentSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/mta/libmta_tr181.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/mta/ccsp_msg_pa.cfg";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/pam/CcspPandMSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/pam/libtr181.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/rm/CcspRmSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/snmp/libs/libsnmp_plugin.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/snmp/run_snmpd.sh";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/snmp/run_subagent.sh";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/tad/CcspTandDSsp";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/tad/libdiagnostic.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/tad/libdmltad.so";
    chmod 0755, $STAGE_ROOT . "usr/ccsp/tr069pa/CcspTr069PaSsp";

    # Fix file links.
    my $curdir = getcwd;
    chdir $STAGE_ROOT . "usr/ccsp";
    symlink "dmcli", "ccsp_bus_client_tool";
    symlink "cli_start_pc.sh", "cli_start.sh";
    symlink "cosa_start_pc.sh", "cosa_start.sh";
    symlink "cr-deviceprofile_pc.xml", "cr-deviceprofile.xml";
    chdir "cm";
    symlink "CcspCMDM_pc.cfg", "CcspCMDM.cfg";
    symlink "CcspCM_pc.cfg", "CcspCM.cfg";
    symlink "ccsp_msg_pc.cfg", "ccsp_msg.cfg";
    chdir "..";
    chdir "config";
    symlink "bbhm_def_cfg_pc.xml", "bbhm_def_cfg.xml";
    chdir "..";
    chdir "mta";
    symlink "CcspMtaAgent_pc.xml", "CcspMtaAgent.xml";
    symlink "CcspMta_pc.cfg", "CcspMta.cfg";
    symlink "CcspMtaLib_pc.cfg", "CcspMtaLib.cfg";
    chdir "..";
    chdir "pam";
    symlink "CcspDmLib_pc.cfg", "CcspDmLib.cfg";
    symlink "ccsp_msg_pc.cfg", "ccsp_msg.cfg";
    chdir "..";
    chdir "rm";
    symlink "RebootManager_pc.xml", "RebootManager.xml";
    chdir "..";
    chdir "tr069pa";
    symlink "ccsp_tr069_pa_certificate_cfg_pc.xml", "ccsp_tr069_pa_certificate_cfg.xml";
    symlink "ccsp_tr069_pa_cfg_pc.xml", "ccsp_tr069_pa_cfg.xml";
    symlink "ccsp_tr069_pa_mapper_pc.xml", "ccsp_tr069_pa_mapper_cfg.xml";
    symlink "ccsp_msg_pc.cfg", "ccsp_msg.cfg";
    chdir "..";
    chdir $curdir;
};

print "Staging PC Simulator\n";
main();
print "Done\n";
