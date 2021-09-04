#!/bin/bash
#This script is derived from Roberto Reigada script

RED='\033[0;31m'
WHITE='\033[0;37m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if [ $# -lt 2 ];
then
	printf "${RED}USAGE: $0 <buckets_file> <folder_to_save_the_results> <dictionaryFile> <service choose: S3 or GS or Azure>${NC}\n"
	exit 0
fi

bucketsFile=$1
resultsfolder=$2
dictFile=$3
service=$4

if [ ! -f $bucketsFile ]; then
	printf "${RED}File $bucketsFile not found${NC}\n"
	exit 0
fi
if [ ! -d $resultsfolder ]; then
	mkdir $resultsfolder
fi
printf "${GREEN}Starting making the dictionary${NC}\n"
for i in $(cat $bucketsFile); do echo $i >> "$resultsfolder/customWordlist.txt"; done
for i in $(cat $dictFile); do sed -e "s/$/${i}/g" $bucketsFile >> "$resultsfolder/customWordlist.txt"; done
for i in $(cat $dictFile); do sed -e "s/$/.${i}/g" $bucketsFile >> "$resultsfolder/customWordlist.txt"; done
for i in $(cat $dictFile); do sed -e "s/$/-${i}/g" $bucketsFile >> "$resultsfolder/customWordlist.txt"; done
for i in $(cat $dictFile); do sed -e "s/^/${i}/" $bucketsFile >> "$resultsfolder/customWordlist.txt"; done
for i in $(cat $dictFile); do sed -e "s/^/${i}./" $bucketsFile >> "$resultsfolder/customWordlist.txt"; done
for i in $(cat $dictFile); do sed -e "s/^/${i}-/" $bucketsFile >> "$resultsfolder/customWordlist.txt"; done
printf "${GREEN}Starting making the test on the buckets created with our created dictionary${NC}\n"
aws-extender-cli -f $resultsfolder/customWordlist.txt -s $4 > $resultsfolder/bucket-results.txt
printf "${GREEN}Finished the script, please check $resultsfolder/bucket-results.txt file${NC}\n"
