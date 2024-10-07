#!/bin/bash

usage() {
    echo "Usage: $0 [-t target] [-p port_range]"
    echo "  -t target       Target IP address or domain name"
    echo "  -p port_range   Port range to scan (e.g., '1-1000')"
    exit 1
}


while getopts ":t:p:" opt; do
    case ${opt} in
        t )
            target=$OPTARG
            ;;
        p )
            port_range=$OPTARG
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Option -$OPTARG requires an argument." 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))


if [ -z "$target" ] || [ -z "$port_range" ]; then
    echo "Error: Target and port range are required."
    usage
fi


port_scan() {
    target=$1
    port=$2
    timeout 1 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null && echo "Port $port is open"
}

echo "Scanning ports $port_range on $target..."


for port in $(seq $(echo $port_range | cut -d'-' -f1) $(echo $port_range | cut -d'-' -f2)); do
    port_scan $target $port &
done

wait

echo "Port scan complete."
