#!/bin/bash

PassHash=$(echo $1 | docker run --rm -i datalust/seq:2023.1.9162 config hash)
echo "$PassHash"