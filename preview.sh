#!/usr/bin/env bash
#
# preview.sh - Aperçu local de la page avant déploiement
#

set -e

PORT=8000
URL="http://localhost:${PORT}"

# Détection de Python
if command -v python3 &>/dev/null; then
  PYTHON=python3
elif command -v python &>/dev/null; then
  PYTHON=python
else
  echo "Erreur : Python n'est pas installé."
  exit 1
fi

echo "Serveur local démarré sur ${URL}"
echo "Ctrl+C pour arrêter."
echo

# Ouverture automatique du navigateur (macOS, Linux, WSL, Git Bash)
( sleep 1
  if command -v open &>/dev/null; then
    open "$URL"
  elif command -v xdg-open &>/dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
  elif command -v start &>/dev/null; then
    start "$URL"
  fi
) &

$PYTHON -m http.server "$PORT" --bind 127.0.0.1
