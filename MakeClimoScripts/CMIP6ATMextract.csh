#!/bin/csh

# script to extract timeseries and make climatology from monthly timeseries in CMIP6 directory
# note if you want different years you must edit the numbers X and Y that appear after -d time,X,Y
# It is set now to get years 331 Jan through 350 Dec

set processpiControl = y
set processQuadCO2 = y

# please edit me
set ADFout = /glade/derecho/scratch/$USER/ATMS559HW3classruns/AtmosClimoss/

# get geopotential heights (Z3) be sure to include PS with 3D spatial variables
set vars = (LHFLX SHFLX PRECSC PRECSL)

# add PS to the 3D variables so they can be regridded sigma to pressure coordinates with ease
set addPS2vars = ()

#--------------------------------------------------


# make directory if it does not exist
mkdir -p $ADFout

if ($processpiControl == 'y') then

    set case = b.e21.B1850.f19_g17.CMIP6-piControl-2deg.001
    set casedir = /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/${case}/atm/proc/tseries/month_1/

    foreach avar ($vars)
	ncks -d time,120480.,127750. ${casedir}/${case}.cam.h0.${avar}.030101-035012.nc  ${ADFout}/${case}.cam.h0.${avar}.033101-035012.nc
    end

    foreach avar ($addPS2vars)
	ncks -A ${ADFout}/${case}.cam.h0.PS.033101-035012.nc ${ADFout}/${case}.cam.h0.${avar}.033101-035012.nc
    end

    echo 'Please ignore warnings about number of records requested, what matters is number found'
    foreach avar ($vars)
	set m = 0
	while ($m <= 11)
	    set month = `printf "%02d" ${m}`
	    ncra -d time,${m},9999,12 ${ADFout}/${case}.cam.h0.${avar}.033101-035012.nc ${ADFout}/tmp_${month}.nc
	    @ m++
	end
	ncrcat ${ADFout}/tmp*.nc ${ADFout}/${case}_${avar}_climo.nc
	rm -f ${ADFout}/tmp_*nc
    end
    
endif

if ($processQuadCO2 == 'y') then
    set case = b.e21.BCO2x4.f19_g17.CMIP6-abrupt4xCO2-2deg.001
    set casedir = /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/${case}/atm/proc/tseries/month_1/

    foreach avar ($vars)
	ncks -d time,120,359 ${casedir}/${case}.cam.h0.${avar}.000101-005012.nc  ${ADFout}/${case}.cam.h0.${avar}.001101-003012.nc
    end

    foreach avar ($addPS2vars)
	ncks -A ${ADFout}/${case}.cam.h0.PS.001101-003012.nc ${ADFout}/${case}.cam.h0.${avar}.001101-003012.nc
    end

    echo 'Please ignore warnings about number of records requested, what matters is number found'
    foreach avar ($vars)
	set m = 0
	while ($m <= 11)
	    set month = `printf "%02d" ${m}`
	    ncra -d time,${m},9999,12 ${ADFout}/${case}.cam.h0.${avar}.001101-003012.nc ${ADFout}/tmp_${month}.nc
	    @ m++
	end
	ncrcat ${ADFout}/tmp*.nc ${ADFout}/${case}_${avar}_climo.nc
	rm -f ${ADFout}/tmp_*nc
    end
    
endif


#-------------------------------------------------------



