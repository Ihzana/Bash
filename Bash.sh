#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_ip>"
    exit 1
fi

target_ip=$1

start_port=1
end_port=1024

echo "Scanning ports on $target_ip from $start_port to $end_port..."

for port in $(seq $start_port $end_port); do
    (echo >/dev/tcp/$target_ip/$port) &>/dev/null && echo "Port $port is open"
done

echo "Scan complete!"
