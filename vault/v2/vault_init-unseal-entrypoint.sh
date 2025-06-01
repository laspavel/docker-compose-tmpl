#!/bin/sh

VAULT_CONFIG="/vault/config.hcl"
UNSEAL_KEYS_FILE="/vault/keys.json"
KEY_SHARES=5
KEY_THRESHOLD=3

# # Проверка jq
# if ! command -v jq >/dev/null 2>&1; then
#   echo "[!] jq not found, trying to install..."

#   if command -v apk >/dev/null 2>&1; then
#     echo "[+] Installing jq via apk..."
#     apk add --no-cache jq
#   else
#     echo "[✗] Package manager not found. Cannot install jq."
#     exit 1
#   fi
# fi

# Запускаем Vault в фоне
vault server -config="$VAULT_CONFIG" &
VAULT_PID=$!

# Ждём готовности
echo "[*] Waiting for Vault..."
until vault status -format=json | grep -q 'initialized'; do
  sleep 2
done

# Проверяем инициализирован ли Vault
if ! vault status -format=json | grep -q '"initialized":true'; then
  echo "[+] Initializing Vault..."
  vault operator init -key-shares=$KEY_SHARES -key-threshold=$KEY_THRESHOLD -format=json > "$UNSEAL_KEYS_FILE"
else
  echo "[*] Vault already initialized"
fi

# Unseal
for i in $(seq 0 $((KEY_THRESHOLD - 1))); do
  KEY=$(jq -r ".unseal_keys_b64[$i]" "$UNSEAL_KEYS_FILE")
  echo "[*] Unsealing with key $((i+1))..."
  vault operator unseal "$KEY"
done

echo "[✓] Vault initialized and unsealed"

# Ожидаем завершения Vault-процесса
wait $VAULT_PID
