##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2015 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################
#!/usr/bin/env perl

# This Perl script is used to stage the CCSP Simulator for the PC platform.

use strict;
use warnings;

use File::Path;
use File::Copy;
use Cwd;

my @src = (
    [ 'hal/lib/libhal_cm.so', 'lib' ],
    [ 'hal/lib/libhal_mta.so', 'lib' ],
    [ 'hal/lib/libhal_wifi.so', 'lib' ],
    [ 'CcspLMLite/lib/liblmapi.so', 'lib' ],
    [ 'CcspCommonLibrary/source/util_api/ccsp_msg_bus/basic.conf', 'usr/ccsp' ],
    [ 'CcspCommonLibrary/source/util_api/ccsp_msg_bus/ccsp_msg.cfg', 'usr/ccsp' ],
    [ 'CcspCr/bin/CcspCrSsp', 'usr/ccsp' ],
    [ 'CcspMisc/bin/dmcli', 'usr/ccsp' ],
    [ 'CcspMisc/bin/psmcli', 'usr/ccsp' ],
    [ 'CcspCommonLibrary/scripts/cli_start_pc.sh', 'usr/ccsp' ],
    [ 'CcspCommonLibrary/scripts/cosa_start_pc.sh', 'usr/ccsp' ],
    [ 'CcspCr/config/cr-deviceprofile_pc.xml', 'usr/ccsp' ],
    [ 'CcspCommonLibrary/lib/libccsp_common.so', 'usr/ccsp' ],
    [ 'CcspPsm/bin/PsmSsp', 'usr/ccsp' ],
    [ 'CcspCMAgent/bin/CcspCMAgentSsp', 'usr/ccsp/cm' ],
    [ 'CcspCMAgent/lib/libcm_tr181.so', 'usr/ccsp/cm' ],
    [ 'CcspCMAgent/config/CcspCMDM_pc.cfg', 'usr/ccsp/cm' ],
    [ 'CcspCMAgent/config/CcspCM_pc.cfg', 'usr/ccsp/cm' ],
    [ 'CcspCMAgent/config/TR181-CM_pc.XML', 'usr/ccsp/cm' ],
    [ 'CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/cm' ],
    [ 'CcspPsm/config/bbhm_def_cfg_pc.xml', 'usr/ccsp/config' ],
    [ 'CcspLMLite/bin/CcspLMLite', 'usr/ccsp/lm' ],
    [ 'CcspLMLite/lib/liblmapi.so', 'usr/ccsp/lm' ],
    [ 'CcspMtaAgent/bin/CcspMtaAgentSsp', 'usr/ccsp/mta' ],
    [ 'CcspMtaAgent/lib/libmta_tr181.so', 'usr/ccsp/mta' ],
    [ 'CcspMtaAgent/config/CcspMtaAgent_pc.xml', 'usr/ccsp/mta' ],
    [ 'CcspMtaAgent/config/CcspMta_pc.cfg', 'usr/ccsp/mta' ],
    [ 'CcspMtaAgent/config/CcspMtaLib_pc.cfg', 'usr/ccsp/mta' ],
    [ 'CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/mta' ],
    [ 'CcspPandM/bin/CcspPandMSsp', 'usr/ccsp/pam' ],
    [ 'CcspPandM/lib/libtr181.so', 'usr/ccsp/pam' ],
    [ 'CcspPandM/config/CcspDmLib_pc.cfg', 'usr/ccsp/pam' ],
    [ 'CcspPandM/config/CcspPam.cfg', 'usr/ccsp/pam' ],
    [ 'CcspPandM/config/COSAXcalibur.XML', 'usr/ccsp/pam' ],
    [ 'CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/pam' ],
    [ 'RebootManager/bin/CcspRmSsp', 'usr/ccsp/rm' ],
    [ 'RebootManager/config/RebootManager_pc.xml', 'usr/ccsp/rm' ],
    [ 'CcspSnmpPa/lib/libsnmp_plugin.so', 'usr/ccsp/snmp/libs' ],
    [ 'CcspSnmpPa/config/snmpd.conf', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/scripts/run_snmpd.sh', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/scripts/run_subagent.sh', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_CLAB-WIFI-MIB.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/CcspMibList.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-DeviceMgmt.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Hotspot.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Lan-Dhcp.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-MoCA.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-NTP.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-routing.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Tr069Pa.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-Vlan.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-MIB-WanDns.xml', 'usr/ccsp/snmp' ],
    [ 'CcspSnmpPa/Mib2DmMapping/Ccsp_SA-RG-WiFi-MIB.xml', 'usr/ccsp/snmp' ],
    [ 'CcspTr069Pa/bin/CcspTr069PaSsp', 'usr/ccsp/tr069pa' ],
    [ 'CcspTr069Pa/config/ccsp_tr069_pa_certificate_cfg_pc.xml', 'usr/ccsp/tr069pa' ],
    [ 'CcspTr069Pa/config/ccsp_tr069_pa_cfg_pc.xml', 'usr/ccsp/tr069pa' ],
    [ 'CcspTr069Pa/config/ccsp_tr069_pa_mapper_pc.xml', 'usr/ccsp/tr069pa' ],
    [ 'CcspTr069Pa/config/sdm.xml', 'usr/ccsp/tr069pa' ],
    [ 'CcspCommonLibrary/config/ccsp_msg_pc.cfg', 'usr/ccsp/tr069pa' ],
    [ 'TestAndDiagnostic/bin/CcspTandDSsp', 'usr/ccsp/tad' ],
    [ 'TestAndDiagnostic/lib/libdiagnostic.so', 'usr/ccsp/tad' ],
    [ 'TestAndDiagnostic/lib/libdmltad.so', 'usr/ccsp/tad' ]
);

# Note: add [ 'hal/lib/libmoca_mgnt.so', 'lib' ] to src array when it is building again.
#       add [ 'CcspSnmpPa/build-pc-rdkb/snmp_custom.so', 'usr/ccsp/snmp/libs' ] to src array when it is building again.
#       add [ 'CcspSnmpPa/build-pc/snmp_subagnet', 'usr/ccsp/snmp' ] to src array when it is building again.

# CCSP ROOT directory
my $CCSP_ROOT = "..";
if (defined $ENV{'CCSP_ROOT'}) { $CCSP_ROOT = $ENV{'CCSP_ROOT'} };
print "Using CCSP_ROOT: " . $CCSP_ROOT . "\n";

# Staging HOME directory.
my $STAGE_ROOT = ".";
if (defined $ENV{'STAGE_ROOT'}) { $STAGE_ROOT = $ENV{'STAGE_ROOT'} };
print "Using STAGE_ROOT: " . $STAGE_ROOT .  "\n";

sub createDir {
    my $directory = $STAGE_ROOT . "/" . $_[0];
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
	my $file = $CCSP_ROOT . "/" . @$ref[0];
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
	my $source = $CCSP_ROOT . "/" . @$ref[0];
	my $destination = $STAGE_ROOT . "/" . @$ref[1];
	#print "Source: " . $source . "\n";
	#print "Destination: " . $destination . "\n";
	copyFile($source, $destination);
    }

    # Fix file permissions.
#    chmod 0755, $STAGE_ROOT . "/" . "dbus-daemon";
#    chmod 0755, $STAGE_ROOT . "/" . "snmpd";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/basic.conf";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/CcspCrSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/dmcli";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/psmcli";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/ccsp_msg.cfg";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cli_start_pc.sh";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cosa_start_pc.sh";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/libccsp_common.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/PsmSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cm/CcspCMAgentSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cm/libcm_tr181.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cm/CcspCMDM_pc.cfg";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cm/CcspCM_pc.cfg";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/cm/ccsp_msg_pc.cfg";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/lm/CcspLMLite";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/lm/liblmapi.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/mta/CcspMtaAgentSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/mta/libmta_tr181.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/mta/ccsp_msg_pa.cfg";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/pam/CcspPandMSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/pam/libtr181.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/rm/CcspRmSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/snmp/libs/libsnmp_plugin.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/snmp/run_snmpd.sh";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/snmp/run_subagent.sh";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/tad/CcspTandDSsp";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/tad/libdiagnostic.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/tad/libdmltad.so";
    chmod 0755, $STAGE_ROOT . "/" . "usr/ccsp/tr069pa/CcspTr069PaSsp";

    # Fix file links.
    my $curdir = getcwd;
    chdir $STAGE_ROOT . "/" . "usr/ccsp";
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
