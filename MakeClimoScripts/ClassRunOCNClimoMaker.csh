#!/bin/csh

# script to extract timeseries and make climatology from monthly data from one of our class runs
# if you want to analyze a run with different years output other than 0001-0024 or 0030, 
# or if you simply want different years you must edit the numbers in the first ncrcat command

# please edit me!
set ADFout = /glade/derecho/scratch/$USER/ATMS559HW3classruns/OceanClimos/

set cases = (DoubleCO2 AlotofCH4 RaiseSolar LowerSolar DirtyAir IcyNA DarkIce NoTrees FlatTibet FlatAntarctica FlatRockies)
set student = (aydenvdb rcbarr1 nwharton congdong ericmei jaypillai geraint lnzhang adhall skygale smheflin)

#set vars = (TEMP SALT HBLT)
set vars = (N_HEAT MOC)

#--------------------------------------------------

# make directory if it does not exist
mkdir -p $ADFout
set n = 1
while ($n < 12)
    set case = ${cases[$n]}
    set casedir = /glade/derecho/scratch/${student[$n]}/archive/${case}/ocn/hist/
    echo $casedir
    
    foreach avar ($vars)  
	set m = 1
	while ($m <= 12)
	    set month = `printf "%02d" ${m}`
            ncea -v ${avar} ${casedir}/${case}.pop.h.00[1-4]*-${month}.nc ${ADFout}/tmp_${month}.nc 
	    @ m++
	end
	ncrcat ${ADFout}/tmp*.nc ${ADFout}/${case}_${avar}_climo.nc
	rm -f ${ADFout}/tmp_*nc
    end
    @ n++
end




