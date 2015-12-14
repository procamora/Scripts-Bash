#!/bin/bash

busq=10.32.73.10.txt
sed -i '/msf3/d' $busq 
sed -i '/=>/d' $busq 
sed -i '/^$/d' $busq 
sed -i '/</d' $busq 
sed -i '/Warning:/d' $busq 

