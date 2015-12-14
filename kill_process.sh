#!/bin/bash

kill $(ps aux | grep 'proceso' | grep -v 'proceso' | awk '{print $2}')

# o tambien
 ps aux | grep 'collectd' | awk '{print $2}' | xargs -d "\n" kill -9