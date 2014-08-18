standalone
==========

This repository contains utilities for running the CCSP simulators and tools.

CCSP Simulator
==============

To stage the simulator, you need to first execute the <i>scripts/stage_pc.pl</i>
Perl script. The files staged will be retrieved from $CCSP_ROOT. By default, this
environment variable is set to "..". The files will be staged in the $STAGE_ROOT
directory. By default, this environment variable is set to ".".

To run the simulator, you will need 2 terminal sessions. In the first terminal,
execute the following in the staged directory:

* cd usr/ccsp
* export LD_LIBRARY_PATH=./:../../../standalone/lib/
* ./cosa_start.sh
 
Some errors may be displayed; this is normal.

In the second terminal, execute:
 
* cd usr/ccsp
* export LD_LIBRARY_PATH=./:../../../standalone/lib/
* ./dmcli simu getv Device.DeviceInfo.NetworkProperties.MaxTCPWindowSize

Or

* ./dmcli simu getv Device.DeviceInfo.NetworkProperties.

Or

* ./dmcli simu getv Device.DeviceInfo.
