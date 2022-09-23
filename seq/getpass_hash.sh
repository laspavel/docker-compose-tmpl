#!/bin/bash

PassHash=$(echo $1 | docker run --rm -i datalust/seq:2022.1.7929 config hash)
echo "$PassHash"