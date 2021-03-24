# Script will automatically download USGS discharge (flow) data 
# for a set of watersheds, user needs to provide:
# discharge ID of the watershed 
# state what the station is in
# unless specified, the script will download all records from Jan 1, 1800 
# the orignal file will be saved as a .txt with tabs
# and a reformatted file as an .prn where it will be space delimited

today=`date +%Y-%m-%d`
state="HI"
for WS in 1 2 
 do
  case ${WS} in

      1) USGS_ID=16238500 ;;
      2) USGS_ID=16240500 ;; 

 esac

sitNo="${USGS_ID}"


#: <<DOWNLOAD
#THIS PART DOWNLOADS FLOW DATA 
   wget -O - "http://waterdata.usgs.gov/$state/nwis/dv?cb_00060=on&format=rdb&period=&begin_date=1800-01-01&end_date=${today}&site_no=${sitNo}&referred_module=sw" > $sitNo.txt #Daily Data`
#DOWNLOAD

#: <<REFORMAT
#THIS PART RE-ALLIGNS COLUMNS, from tab-delimited txt files to space delimited txt files
 sed -e "s/Ice/-99/g" \
     -e "s/Dis/-99/g" \
     -e "s/		/	-99	?/g" \
     -e "s/^USGS	/USGS     /g" \
     -e "s/^USGS     ......../&XXX/g" \
     -e "s/XXX	/     /g" \
     -e "s/ ....-..-..	/&YYY/g" \
     -e "s/	YYY/ ZZZ/g" \
     -e "s/	*\../&XYZ/g" \
     -e "s/	.*.$/.0&/g" \
     -e "s/XYZ[0-9]\.0/&ZXY/g" \
     -e "s/\.0ZXY//g" \
     -e "s/XYZ\.0//g" \
     -e "s/XYZ//g" \
     -e "s/\..	\|\...	/&QQQ/g" \
     -e "s/	QQQ/ /g" \
     -e "s/ZZZ........\.. \|ZZZ.......\... / &/g" \
     -e "s/ZZZ.......\.. \|ZZZ......\... /  &/g" \
     -e "s/ZZZ......\.. \|ZZZ.....\... /   &/g" \
     -e "s/ZZZ.....\.. \|ZZZ....\... /    &/g" \
     -e "s/ZZZ....\.. \|ZZZ...\... /     &/g" \
     -e "s/ZZZ...\.. \|ZZZ..\... /      &/g" \
     -e "s/ZZZ..\.. \|ZZZ.\... /       &/g" \
     -e "s/ZZZ.\.. /        &/g" \
     -e "s/ZZZ//g" \
   $sitNo.txt > $sitNo.prn 
#REFORMAT

done
exit

