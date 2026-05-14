#!/usr/bin/env bash
#
# deploy.sh - Déploiement de la page linktree sur GitHub Pages
#
# Usage :
#   ./deploy.sh                       # commit auto avec horodatage
#   ./deploy.sh "Message de commit"   # commit avec message custom
#

set -euo pipefail

# Couleurs terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- Vérifications préalables ---

if [ ! -d ".git" ]; then
  echo -e "${RED}Erreur : ce dossier n'est pas un repo Git.${NC}"
  echo "Lance d'abord : git init && git remote add origin <url>"
  exit 1
fi

if [ ! -f "index.html" ]; then
  echo -e "${RED}Erreur : index.html introuvable à la racine.${NC}"
  exit 1
fi

# Vérifie la présence des placeholders non remplis
if grep -q "REMPLACER_PAR_URL_LINKEDIN" index.html; then
  echo -e "${YELLOW}Avertissement : le placeholder LinkedIn n'a pas été remplacé dans index.html.${NC}"
  read -p "Continuer quand même ? [o/N] " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[OoYy]$ ]] && exit 1
fi

if grep -q "REMPLACER_PAR_NUMERO" index.html; then
  echo -e "${YELLOW}Avertissement : le placeholder WhatsApp n'a pas été remplacé dans index.html.${NC}"
  read -p "Continuer quand même ? [o/N] " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[OoYy]$ ]] && exit 1
fi

# --- Récupération du message de commit ---

if [ $# -ge 1 ] && [ -n "$1" ]; then
  COMMIT_MSG="$1"
else
  COMMIT_MSG="Mise à jour - $(date +'%Y-%m-%d %H:%M')"
fi

# --- Stage et vérification des changements ---

git add -A

if git diff --cached --quiet; then
  echo -e "${BLUE}Aucun changement à déployer.${NC}"
  exit 0
fi

echo -e "${BLUE}Fichiers modifiés :${NC}"
git diff --cached --name-status | sed 's/^/  /'
echo

# --- Commit et push ---

git commit -m "$COMMIT_MSG"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}Push vers origin/${CURRENT_BRANCH}...${NC}"
git push origin "$CURRENT_BRANCH"

# --- Affichage final ---

REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
REPO_PATH=$(echo "$REMOTE_URL" | sed -E 's|.*github.com[:/]([^/]+/[^/]+)\.git|\1|')

echo
echo -e "${GREEN}Déploiement OK.${NC}"
echo

if [ -f "CNAME" ]; then
  CUSTOM_DOMAIN=$(cat CNAME | tr -d '[:space:]')
  echo -e "  Page en ligne dans ~30 s sur : ${GREEN}https://${CUSTOM_DOMAIN}${NC}"
fi

if [ -n "$REPO_PATH" ]; then
  USER=$(echo "$REPO_PATH" | cut -d'/' -f1)
  REPO=$(echo "$REPO_PATH" | cut -d'/' -f2)
  echo -e "  URL GitHub Pages par défaut : ${GREEN}https://${USER}.github.io/${REPO}/${NC}"
  echo -e "  Build : ${BLUE}https://github.com/${REPO_PATH}/actions${NC}"
fi
echo
