Total Https Request 
--------------------------
grep ' "GET https\?:' test.log | wc -l > TOTAL_HTTPS_REQUEST


Top 10 Host
--------------------------
awk -v start="09/Jul/2019:00:00:00 +0800" -v end="19/Jul/2019:23:59:59 +0800" '$4 >= "["start && $4 <= "["end' test.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10 > TOP10HOSTS



Country MostHTTPS REquest
--------------------------

grep ' "GET https\?:' test.log | awk '{print $1}' | sort | uniq > ip_address.txt


while read -r ip; do
    country=$(curl -s "http://ipinfo.io/$ip/country")
    echo "$country"
done < ip_address.txt > countries.txt


sort countries.txt | uniq -c | sort -nr > MOSTHTTPSCOUNTRY
