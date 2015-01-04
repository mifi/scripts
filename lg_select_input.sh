# Simple script that I use for my LG "smart" TV over the web api to select input with the specified id (starting at 0).
# Since LG doesn't have a command to set input number, it has to be hacked like this.
# The IP that runs the script must be already authenticated for the TV (for "instance by using the LG TV Remote Controller" Chrome extension to pair)

# Set this to at least as many choices that exist in the input list
num_enabled_choices=6

ip_port=192.168.1.148:8080

function send_cmd {
	echo '<?xml version="1.0" encoding="utf-8"?><command><name>HandleKeyInput</name><value>'$1'</value></command>'
	curl -H 'Content-Type: application/atom+xml' -d '<?xml version="1.0" encoding="utf-8"?><command><name>HandleKeyInput</name><value>'$1'</value></command>' "http://$ip_port/roap/api/command"
}


if [ -z "$1" ]; then
	echo "No argument supplied"
	exit
fi
input="$1"


#exit anything that's open
send_cmd 412 || exit
sleep 1

#input
send_cmd 47 || exit
sleep 3

# Make sure we get to the first element
for i in `seq $num_enabled_choices`; do
	#left
	send_cmd 14 || exit
	sleep 0.3
done

for i in `seq $input`; do
	#right
	send_cmd 15 || exit
	sleep 0.3

done

sleep 1

#OK
send_cmd 20 || exit
