#!/bin/bash

UNSEAL_KEYS_FILE="/vault/keys/keys.json"
KEY_SHARES=5
KEY_THRESHOLD=3
/bin/vault operator init -key-shares=$KEY_SHARES -key-threshold=$KEY_THRESHOLD -format=json > "$UNSEAL_KEYS_FILE"
