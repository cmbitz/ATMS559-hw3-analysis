#!/bin/csh

# script to extract timeseries and make climatology from monthly timeseries in CMIP6 directory
# note if you want different years you must edit the numbers X and Y that appear after -d time,X,Y
# It is set now to get years 331 Jan through 350 Dec

set processpiControl = y
set processQuadCO2 = y

# please edit me
set ADFout = /glade/derecho/scratch/$USER/ATMS559HW3classruns/OceanClimos

#set vars = (SALT TEMP HBLT) 
set vars = (N_HEAT MOC) 

#--------------------------------------------------

# make directory if it does not exist
mkdir -p $ADFout


if ($processpiControl == 'y') then

    set case = b.e21.B1850.f19_g17.CMIP6-piControl-2deg.001
    echo $case
    
    foreach avar ($vars)
    set casedir = /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/${case}/ocn/proc/tseries/month_1/
    echo $casedir
	set m = 1
	while ($m <= 12)
	    set month = `printf "%02d" ${m}`
	    echo ${month}
	    @ startmonth = ( 239 + $m )
	    echo $startmonth
	    ncra -d time,$startmonth,479,12 ${casedir}/${case}.pop.h.${avar}.030101-035012.nc ${ADFout}/tmp_${month}.nc
	    @ m++
	end
	ncrcat ${ADFout}/tmp*.nc ${ADFout}/${case}_${avar}_climo.nc
	rm -f ${ADFout}/tmp_*nc
    end
    
endif

if ($processQuadCO2 == 'y') then
    set case = b.e21.BCO2x4.f19_g17.CMIP6-abrupt4xCO2-2deg.001
    
    echo $case
    
    foreach avar ($vars)
    set casedir = /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/${case}/ocn/proc/tseries/month_1/
    echo $casedir
	set m = 1
	while ($m <= 12)
	    set month = `printf "%02d" ${m}`
	    echo ${month}
	    @ startmonth = ( 119 + $m )
	    echo $startmonth
	    ncra -d time,$startmonth,359,12 ${casedir}/${case}.pop.h.${avar}.000101-005012.nc ${ADFout}/tmp_${month}.nc
	    @ m++
	end
	ncrcat ${ADFout}/tmp*.nc ${ADFout}/${case}_${avar}_climo.nc
	rm -f ${ADFout}/tmp_*nc
    end
endif


#-------------------------------------------------------



