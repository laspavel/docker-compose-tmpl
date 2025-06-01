#!/bin/sh

set -e

UNSEAL_KEYS_FILE="/vault/keys.json"
KEY_SHARES=5
KEY_THRESHOLD=3

echo "[*] Waiting for Vault to be up..."
until curl -s "$VAULT_ADDR/v1/sys/health" | grep -q 'initialized'; do
  sleep 2
done

if ! curl -s "$VAULT_ADDR/v1/sys/health" | grep -q '"initialized":true'; then
  echo "[+] Vault is not initialized, initializing..."
  vault operator init -key-shares=$KEY_SHARES -key-threshold=$KEY_THRESHOLD -format=json > "$UNSEAL_KEYS_FILE"
else
  echo "[*] Vault already initialized"
fi

# Unseal with first M keys
for i in $(seq 0 $((KEY_THRESHOLD - 1))); do
  KEY=$(jq -r ".unseal_keys_b64[$i]" "$UNSEAL_KEYS_FILE")
  echo "[*] Unsealing with key $((i+1))..."
  vault operator unseal "$KEY"
done

echo "[✓] Vault unsealed with $KEY_THRESHOLD of $KEY_SHARES keys."
