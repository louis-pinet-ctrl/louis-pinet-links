# louis-pinet-links

Page « link in bio » pour le compte Instagram **@avocatdesrestaurateurs** (ou tout autre réseau).
Hébergement statique sur GitHub Pages, zéro dépendance, charte OURAMA (charbon `#1e1e1e` + lime `#c4e913`).

URL cible : `https://links.louispinetavocat.fr`

---

## 1. Structure

```
louis-pinet-links/
├── index.html        Page complète (HTML + CSS inline, 2 polices Google Fonts)
├── CNAME             Domaine personnalisé pour GitHub Pages
├── deploy.sh         Script de déploiement (commit + push)
├── preview.sh        Serveur local pour aperçu avant push
├── .gitignore
└── README.md
```

Pas de build, pas de framework, pas de `node_modules`. Un fichier HTML autonome.

---

## 2. Personnalisation

Deux variables à remplacer dans `index.html` (recherche-remplace) :

| Marqueur | À remplacer par | Exemple |
|---|---|---|
| `REMPLACER_PAR_URL_LINKEDIN` | URL complète du profil LinkedIn | `https://www.linkedin.com/in/louis-pinet-avocat/` |
| `REMPLACER_PAR_NUMERO` | Numéro WhatsApp international, sans `+` ni `0` initial | `33612345678` |

Aucune autre modification nécessaire pour la mise en ligne.

---

## 3. Aperçu local

```bash
./preview.sh
```

Lance un serveur Python sur `http://localhost:8000` et ouvre le navigateur.
`Ctrl+C` pour arrêter.

---

## 4. Déploiement initial

```bash
# Une seule fois, à la création du repo
git init
git branch -M main
git add .
git commit -m "Init linktree Avocat des Restaurateurs"
gh repo create louis-pinet-links --public --source=. --push
```

Puis sur GitHub :
1. `Settings → Pages → Source : Deploy from a branch → main / (root) → Save`
2. La page est en ligne sous 2 min sur `https://[pseudo].github.io/louis-pinet-links/`

---

## 5. Déploiement des mises à jour

```bash
# Avec un message explicite
./deploy.sh "Ajout du lien Calendly"

# Ou sans argument (timestamp automatique)
./deploy.sh
```

Le script vérifie qu'il y a bien des changements, commit, pousse sur `main`, et affiche l'URL.
GitHub Pages redéploie tout seul en ~30 secondes.

---

## 6. Domaine personnalisé

Le fichier `CNAME` contient déjà `links.louispinetavocat.fr`.

Côté registrar DNS (celui où est géré `louispinetavocat.fr`), créer :

```
Type   : CNAME
Nom    : links
Valeur : [pseudo-github].github.io
TTL    : 3600
```

Puis sur GitHub : `Settings → Pages → Custom domain → links.louispinetavocat.fr → Enforce HTTPS`.

Propagation DNS : 10 min à 2 h. Le certificat SSL est généré automatiquement par GitHub (Let's Encrypt) une fois la propagation terminée.

---

## 7. Évolutions possibles

Quelques pistes pour faire vivre la page sans tout refondre :

- **Calendly / Cal.com** : ajouter un quatrième bouton « Prendre rendez-vous » pointant vers le lien de réservation.
- **Pixel de tracking** : intégrer Plausible ou Umami (RGPD-friendly, sans bandeau cookies obligatoire) pour mesurer les clics par bouton.
- **Tag UTM** : suffixer les URL avec `?utm_source=instagram&utm_medium=bio&utm_campaign=links` pour suivre la conversion dans Google Analytics du site principal.
- **Variantes saisonnières** : créer une branche `summer` ou `rentree` avec une couleur d'accent légèrement différente, mergeable à la demande.

---

## 8. Stack et licences

- HTML5 / CSS3 / zéro JavaScript
- Polices : [Fraunces](https://fonts.google.com/specimen/Fraunces) et [DM Sans](https://fonts.google.com/specimen/DM+Sans), Google Fonts (Open Font License)
- Hébergement : GitHub Pages
- DNS : à la convenance (OVH, Gandi, Cloudflare, etc.)

Maintenance : louispinetavocat.fr — 4 rue d'Angoumois, 44000 Nantes — Barreau de Nantes.
