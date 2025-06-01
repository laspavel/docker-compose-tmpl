#!/bin/sh

VAULT_CONFIG="/vault/config/config.hcl"
UNSEAL_KEYS_FILE="/vault/keys/keys.json"
KEY_SHARES=5
KEY_THRESHOLD=3

# Запускаем Vault в фоне
vault server -config="$VAULT_CONFIG" -disable-caps &
VAULT_PID=$!

# Ждём готовности
echo "[*] Waiting for Vault..."
until curl -s http://127.0.0.1:8200/v1/sys/health | grep -q 'initialized'; do
  sleep 2
done

# Проверяем инициализирован ли Vault
if ! curl -s http://127.0.0.1:8200/v1/sys/health | grep -q '"initialized":true'; then
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
