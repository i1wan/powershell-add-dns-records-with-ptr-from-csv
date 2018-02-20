#██╗ ██╗██╗    ██╗ █████╗ ███╗   ██╗
#██║███║██║    ██║██╔══██╗████╗  ██║
#██║╚██║██║ █╗ ██║███████║██╔██╗ ██║
#██║ ██║██║███╗██║██╔══██║██║╚██╗██║
#██║ ██║╚███╔███╔╝██║  ██║██║ ╚████║
#╚═╝ ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
#By Iwan Hoogendoorn 19 Feb 2018 
#This script create DNS A Record and associate Reverse PTR Records
#If the Reverse Lookup Zones do not exist they will be created as well
#An additional external file is needed (records.csv file) where you create teh records.
#
#Change with your dns server info $Servername and $Domain
$ServerName = "DNS-SERVER-NAME"
$domain = "domain-name.local"
Import-Csv c:\script\Records.csv | ForEach-Object {

#Define variable
$Computer = "$($_.Computer).$domain"
$addr = $_.IP -split "\."
$rzone = "$($addr[2]).$($addr[1]).$($addr[0]).in-addr.arpa"

#Create Dns entries
dnscmd $Servername /recordadd $domain "$($_.Computer)" A "$($_.IP)"

#Create New Reverse Zone if zone already exist, system return a normal error
dnscmd $Servername /zoneadd $rzone /primary

#Create reverse DNS
dnscmd $Servername /recordadd $rzone "$($addr[3])" PTR $Computer
}
