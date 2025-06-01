#!/bin/bash
# Global variables for Minecraft
export NFS_MOUNT_PATH=/mnt/dockershare
export DOMAINNAME=example.com
export TZ="Europe/Amsterdam"
export SERVER_PORT=25565
export SERVER_RCON_PORT=25575
export NFS_MOUNT_PATH=/mnt/example
export WHITELIST_PATH=$NFS_MOUNT_PATH/minecraft/whitelist.json
export OPS_PATH=$NFS_MOUNT_PATH/minecraft/ops.json
export ENABLE_GUI="FALSE"

# Forge-one settings
export FORGE_ONE_SERVER_NAME=forge-one
export FORGE_ONE_SERVE_MODPACK_PATH=$NFS_MOUNT_PATH/minecraft/$FORGE_ONE_SERVER_NAME/allthemods8.zip
export FORGE_ONE_SERVER_PATH=$NFS_MOUNT_PATH/minecraft/$FORGE_ONE_SERVER_NAME/data
export FORGE_ONE_MOTD="Forge One"
export FORGE_ONE_SUBDOMAIN=forge
export FORGE_ONE_MEMORY="16G"
export FORGE_ONE_FORGE_VERSION="47.1.3"
export FORGE_ONE_JAVA_VERSION="1.20.1"
export FORGE_ONE_IMAGE_VERSION='latest'
export FORGE_ONE_ENABLE_RCON="FALSE"
export FORGE_ONE_RCON_PASSWORD="changeme"
export FORGE_ONE_MAX_PLAYERS=20
export FORGE_ONE_PVP="TRUE"
export FORGE_ONE_ENABLE_WHITELIST="TRUE"