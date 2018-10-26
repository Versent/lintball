#!/bin/bash

set -ou pipefail

declare COMMON_LIB_PATH=""
COMMON_LIB_PATH="$(dirname "$(dirname "${BASH_SOURCE[0]}")")/common.sh"

#shellcheck disable=SC1090
source "${COMMON_LIB_PATH}"

# TODO - https://yamllint.readthedocs.io/en/stable/configuration.html

handle()
{
  local RC=0
  local FILENAME="${1}"
  local USERS_YAML_CONFIG_PATH="./yamllintrc"
  local DEFAULT_YAML_CONFIG_PATH="./lintball-yamllintrc"
  local YAML_CONFIG=""

  if echo "${FILENAME}" | grep -e \.yml$ -e \.yaml$ -e \.template$ > /dev/null
  then
    log "Invoking yamllint on [${FILENAME}]"

    # If the user has provided a yaml config , use it, else use the default (packaged with the container)
    if [ -f "${USERS_YAML_CONFIG_PATH}" ]
    then
      YAML_CONFIG="${USERS_YAML_CONFIG_PATH}"
    else
       YAML_CONFIG="${DEFAULT_YAML_CONFIG_PATH}"
    fi

    log "Using YAML_CONFIG - [${YAML_CONFIG}]"

    #TODO - test for existence of .lintball-yamllintrc
    yamllint -c "${YAML_CONFIG}" "${FILENAME}" 2>&1
    RC=${?}
  fi
  exit "${RC}"
}

handle "${1}"
