#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    exit 1
fi

RUNNER_USER="${RUNNER_USER:-runner}"

echo "==> Создаю пользователя ${RUNNER_USER}"
if id "${RUNNER_USER}" >/dev/null 2>&1; then
    echo "    пользователь уже существует"
else
    adduser --disabled-password --gecos "" "${RUNNER_USER}"
fi

echo "==> Выдаю sudo без пароля"
echo "${RUNNER_USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${RUNNER_USER}"
chmod 0440 "/etc/sudoers.d/${RUNNER_USER}"
visudo -c >/dev/null

echo "==> Создаю ~/.ssh с правами"
install -d -m 700 -o "${RUNNER_USER}" -g "${RUNNER_USER}" "/home/${RUNNER_USER}/.ssh"

