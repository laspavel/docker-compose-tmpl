#!/bin/bash

## Generate global auth key between cluster nodes
openssl rand -base64 756 > mongodb.key
chown 999:root mongodb.key
chmod 600 mongodb.key

