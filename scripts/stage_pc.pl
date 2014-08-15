#!/usr/bin/env perl

# This Perl script is used to stage the CCSP Simulator for the PC platform.

use strict;
use warnings;

use File::Path;
use File::Copy;
use Cwd;

my @src = (
    '../hal/lib/libhal_cm.so',
    '../hal/lib/libhal_mta.so',
    '../hal/lib/libhal_wifi.so',
    '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libcrypto.a',
    '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libcrypto.so',
    '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libcrypto.so.0.9.8',
    '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libssl.a',
    '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libssl.so',
    '../ExtDependency/opensource_work/pc/rdkb/openssl-0.9.8l/libssl.so.0.9.8',
    '../ExtDependency/opensource_work/pc/rdkb/curl-7.28.1/lib/.libs/libcurl.so',
    '../ExtDependency/opensource_work/pc/rdkb/curl-7.28.1/lib/.libs/libcurl.so.4',
    '../ExtDependency/opensource_work/pc/rdkb/curl-7.28.1/lib/.libs/libcurl.so.4.3.0',
    '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.a',
    '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.la',
    '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.so',
    '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.so.3',
    '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/dbus/.libs/libdbus-1.so.3.5.7',
    '../ExtDependency/opensource_work/pc/rdkb/fcgi-2.4.0/libfcgi/.libs/libfcgi.a',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/ixml/.libs/libixml.so',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/ixml/.libs/libixml.so.2',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/ixml/.libs/libixml.so.2.0.4',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/helpers/.libs/libnetsnmphelpers.so',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/helpers/.libs/libnetsnmphelpers.so.30',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/helpers/.libs/libnetsnmphelpers.so.30.0.1',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpmibs.so',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpmibs.so.30',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpmibs.so.30.0.1',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpagent.so',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpagent.so.30',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/libnetsnmpagent.so.30.0.1',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/snmplib/.libs/libnetsnmp.so',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/snmplib/.libs/libnetsnmp.so.30',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/snmplib/.libs/libnetsnmp.so.30.0.1',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/apps/.libs/libnetsnmptrapd.so',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/apps/.libs/libnetsnmptrapd.so.30',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/apps/.libs/libnetsnmptrapd.so.30.0.1',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/AGENTX-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/BRIDGE-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-EVENT-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-EXPRESSION-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-NSLOOKUP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-PING-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-SCHEDULE-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-SCRIPT-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/DISMAN-TRACEROUTE-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/EtherLike-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/HCNUM-TC.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/HOST-RESOURCES-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/HOST-RESOURCES-TYPES.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANA-ADDRESS-FAMILY-NUMBERS-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANAifType-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANA-LANGUAGE-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IANA-RTPROTO-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IF-INVERTED-STACK-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IF-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/INET-ADDRESS-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IP-FORWARD-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-FLOW-LABEL-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-ICMP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-TCP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-TC.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/IPV6-UDP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/LM-SENSORS-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/MTA-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-AGENT-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-EXAMPLES-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-EXTEND-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-MONITOR-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-PASS-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-PERIODIC-NOTIFY-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-SYSTEM-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-TC.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NET-SNMP-VACM-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NETWORK-SERVICES-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/NOTIFICATION-LOG-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RFC1155-SMI.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RFC1213-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RFC-1215.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/RMON-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SCTP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SMUX-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-COMMUNITY-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-FRAMEWORK-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-MPD-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-NOTIFICATION-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-PROXY-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-TARGET-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-TLS-TM-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-TSM-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-USER-BASED-SM-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-USM-AES-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-USM-DH-OBJECTS-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-CONF.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-SMI.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-TC.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMPv2-TM.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/SNMP-VIEW-BASED-ACM-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/TCP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/TRANSPORT-ADDRESS-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/TUNNEL-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-DEMO-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-DISKIO-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-DLMOD-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-IPFILTER-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-IPFWACC-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-SNMP-MIB-OLD.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UCD-SNMP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/mibs/UDP-MIB.txt',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/threadutil/.libs/libthreadutil.so',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/threadutil/.libs/libthreadutil.so.2',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/threadutil/.libs/libthreadutil.so.2.2.3',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/upnp/.libs/libupnp.so',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/upnp/.libs/libupnp.so.3',
    '../ExtDependency/opensource_work/pc/rdkb/libupnp-1.6.6/upnp/.libs/libupnp.so.3.0.5',
    '../ExtDependency/opensource_work/pc/rdkb/dbus-1.4.14/bus/dbus-daemon',
    '../ExtDependency/opensource_work/pc/rdkb/net-snmp-5.7.1/agent/.libs/snmpd',
    '../CcspLMLite/lib/liblmapi.so',
    '../CcspCommonLibrary/source/util_api/ccsp_msg_bus/basic.conf',
    '../CcspCommonLibrary/source/util_api/ccsp_msg_bus/ccsp_msg.cfg',
    '../CcspCr/bin/CcspCrSsp',
    '../CcspMisc/bin/dmcli',
    '../CcspMisc/bin/psmcli',
    '../CcspCommonLibrary/scripts/cli_start_pc.sh',
    '../CcspCommonLibrary/scripts/cosa_start_pc.sh',
    '../CcspCr/config/cr-deviceprofile_pc.xml',
    '../CcspCommonLibrary/lib/libccsp_common.so',
    '../CcspPsm/bin/PsmSsp',
    '../CcspCMAgent/bin/CcspCMAgentSsp',
    '../CcspCMAgent/lib/libcm_tr181.so',
    '../CcspCMAgent/config/CcspCMDM_pc.cfg',
    '../CcspCMAgent/config/CcspCM_pc.cfg',
    '../CcspCMAgent/config/TR181-CM_pc.XML',
    '../CcspCommonLibrary/config/ccsp_msg_pc.cfg',
    '../CcspPsm/config/bbhm_def_cfg_pc.xml',
    '../CcspLMLite/bin/CcspLMLite',
    '../CcspLMLite/lib/liblmapi.so',
    '../CcspMtaAgent/bin/CcspMtaAgentSsp',
    '../CcspMtaAgent/lib/libmta_tr181.so',
    '../CcspMtaAgent/config/CcspMtaAgent_pc.xml',
    '../CcspMtaAgent/config/CcspMta_pc.cfg',
    '../CcspMtaAgent/config/CcspMtaLib_pc.cfg',
    '../CcspCommonLibrary/config/ccsp_msg_pc.cfg',
    '../CcspPandM/bin/CcspPandMSsp',
    '../CcspPandM/lib/libtr181.so',
    '../CcspPandM/config/CcspDmLib_pc.cfg',
    '../CcspPandM/config/CcspPam.cfg',
    '../CcspPandM/config/COSAXcalibur.XML',
    '../CcspCommonLibrary/config/ccsp_msg_pc.cfg',
    '../RebootManager/bin/CcspRmSsp',
    '../RebootManager/config/RebootManager_pc.xml',
    '../CcspSnmpPa/lib/libsnmp_plugin.so',
    '../CcspSnmpPa/config/snmpd.conf',
    '../CcspSnmpPa/scripts/run_snmpd.sh',
    '../CcspSnmpPa/scripts/run_subagent.sh',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_CLAB-WIFI-MIB.xml',
    '../CcspSnmpPa/Mib2DmMapping/CcspMibList.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-DeviceMgmt.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Hotspot.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Lan-Dhcp.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-MoCA.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-NTP.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-routing.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Tr069Pa.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Vlan.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-WanDns.xml',
    '../CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-WiFi-MIB.xml',
    '../CcspTr069Pa/bin/CcspTr069PaSsp',
    '../CcspTr069Pa/config/ccsp_tr069_pa_certificate_cfg_pc.xml',
    '../CcspTr069Pa/config/ccsp_tr069_pa_cfg_pc.xml',
    '../CcspTr069Pa/config/ccsp_tr069_pa_mapper_pc.xml',
    '../CcspTr069Pa/config/sdm.xml',
    '../CcspCommonLibrary/config/ccsp_msg_pc.cfg',
    '../TestAndDiagnostic/bin/CcspTandDSsp',
    '../TestAndDiagnostic/lib/libdiagnostic.so',
    '../TestAndDiagnostic/lib/libdmltad.so'
);

# Note: add '../hal/lib/libmoca_mgnt.so' to src array when it is building again.
#       add '../CcspSnmpPa/build-pc-rdkb/snmp_custom.so' to src array when it is building again.
#       add '../CcspSnmpPa/build-pc/snmp_subagnet' to src array when it is building again.

my @dest = (
    'lib', 'lib', 'lib',
    'lib', 'lib', 'lib',
    'lib', 'lib', 'lib',
    'lib', 'lib', 'lib',
    'lib', 'lib', 'lib', 'lib', 'lib',
    'lib',
    'lib', 'lib', 'lib',
    'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib', 'lib',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'mibs', 'mibs', 'mibs', 'mibs', 'mibs', 'mibs',
    'lib', 'lib', 'lib',
    'lib', 'lib', 'lib',
    '.',
    '.',
    'lib',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp',
    'usr/ccsp/cm', 'usr/ccsp/cm', 'usr/ccsp/cm', 'usr/ccsp/cm', 'usr/ccsp/cm', 'usr/ccsp/cm',
    'usr/ccsp/config',
    'usr/ccsp/lm', 'usr/ccsp/lm',
    'usr/ccsp/mta', 'usr/ccsp/mta', 'usr/ccsp/mta', 'usr/ccsp/mta', 'usr/ccsp/mta', 'usr/ccsp/mta',
    'usr/ccsp/pam', 'usr/ccsp/pam', 'usr/ccsp/pam', 'usr/ccsp/pam', 'usr/ccsp/pam', 'usr/ccsp/pam',
    'usr/ccsp/rm', 'usr/ccsp/rm',
    'usr/ccsp/snmp/libs',
    'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp',
    'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp',
    'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp', 'usr/ccsp/snmp',
    'usr/ccsp/snmp', 'usr/ccsp/snmp',
    'usr/ccsp/tr069pa', 'usr/ccsp/tr069pa', 'usr/ccsp/tr069pa', 'usr/ccsp/tr069pa', 'usr/ccsp/tr069pa', 'usr/ccsp/tr069pa',
    'usr/ccsp/tad', 'usr/ccsp/tad', 'usr/ccsp/tad'
);

# Note: add 'lib' to dest array when libmoca_mgnt.so is building again.
#       add 'usr/ccsp/snmp/libs' to dest array when snmp_custom.so is building again.
#       add 'usr/ccsp/snmp' to dest array when snmp_subagnet is building again.

print "Staging PC Simulator\n";

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
    # Validate that src and dest arrays are the same size.
    if (@src != @dest) {
        #print "Src array size: " . @src . "\n";
	#print "Dest array size: " . @dest . "\n";
        die "ERROR: Source and destination file arrays are our of sync.\n";
    }

    # Validate that src files exist.
    foreach (@src) {
	my $file = $STAGE_ROOT . $_;
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
    my $index = 0;
    foreach (@src) {
	my $source = $STAGE_ROOT . $_;
	my $destination = $STAGE_ROOT . $dest[$index];
	#print "Source: " . $source . "\n";
	#print "Destination: " . $destination . "\n";
	$index++;
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

main();
