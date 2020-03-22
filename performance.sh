#! /bin/bash

ip=$1
echo "1 client 1 way"
iperf3 -c $ip -t 30 | grep SUM

echo "1 client 1 way 128k"
iperf3 -c $ip -t 30 -w 128k | grep SUM

echo "30 client 1 way"
iperf3 -c $ip -t 30 -P 30 | grep SUM

echo "30 client 1 way 128k"
iperf3 -c $ip -t 30 -P 30 -w 128K | grep SUM


# -R

echo "1 client 1 way"
iperf3 -c $ip -t 30 -R | grep SUM

echo "1 client 1 way 128k"
iperf3 -c $ip -t 30 -w 128k -R | grep SUM

echo "30 client 1 way"
iperf3 -c $ip -t 30 -P 30 -R | grep SUM

echo "30 client 1 way 128k"
iperf3 -c $ip -t 30 -P 30 -w 128K -R | grep SUM
