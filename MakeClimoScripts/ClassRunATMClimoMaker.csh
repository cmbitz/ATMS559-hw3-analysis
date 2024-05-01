#!/bin/csh

# script to extract timeseries and make climatology from monthly data from one of our class runs
# if you want to analyze a run with different years output other than 0001-0024 or 0030, 
# or if you simply want different years you must edit the numbers in the first ncrcat command
# beware the AlotOfCH4FixedSST run does have different years and would need to be customized


# please edit me!
set cases = (DoubleCO2 AlotofCH4 RaiseSolar LowerSolar DirtyAir IcyNA DarkIce NoTrees FlatTibet FlatAntarctica FlatRockies)
set student = (aydenvdb rcbarr1 nwharton congdong ericmei jaypillai geraint lnzhang adhall skygale smheflin)

set prefernames = (DoubleCO2 AlotofCH4 RaiseSolar LowerSolar DirtyAir IcyNA DarkSeaIce NoTrees FlatTibet FlatTibet-Antarctica FlatTibet-Antarctica-Rockies)
	    
set ADFout = /glade/derecho/scratch/$USER/ATMS559HW3classruns/AtmosClimoss

# example get geopotential heights (Z3) be sure to include PS with 3D spatial variables
set vars = (LHFLX SHFLX PRECSC PRECSL)

# must add PS to the 3D variables so they can be regridded sigma to pressure coordinates with ease
# Z3 is a 3D variable so include it in the example
set addPS2vars = ()

#--------------------------------------------------


# make directory if it does not exist
mkdir -p $ADFout

set n = 1
while ($n < 12)
    set case = ${cases[$n]}
    set pref = ${prefernames[$n]}
    set casedir = /glade/derecho/scratch/${student[$n]}/archive/${case}/atm/hist/
    echo $casedir $pref

    foreach avar ($vars)  # using a generic name since not sure how many years we will get 
	set m = 1
	while ($m <= 12)
	    set month = `printf "%02d" ${m}`
            ncea -v ${avar} ${casedir}/${case}.cam.h0.00[1-4]*-${month}.nc ${ADFout}/tmp_${month}.nc 
	    @ m++
	end
	ncrcat ${ADFout}/tmp*.nc ${ADFout}/${pref}_${avar}_climo.nc
	rm -f ${ADFout}/tmp_*nc
    end

    foreach avar ($addPS2vars)
	ncks -A ${ADFout}/${case}_PS_climo.nc ${ADFout}/${case}_${avar}_climo.nc
    end

    @ n++
end



