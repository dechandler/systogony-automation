
SSH_AUTH_SOCK="${HOME}/.ssh/sockets/agent.sock"
AGENT_ENV_FILE="${HOME}/.ssh/agent.env"

[[ -S "${SSH_AUTH_SOCK}" ]] || /usr/bin/ssh-agent -a "${SSH_AUTH_SOCK}" | head -2 > "${AGENT_ENV_FILE}"
source "${AGENT_ENV_FILE}"
