# TaskFlow — dépôt fil rouge CI/CD

[![CI](https://github.com/Waddenn/cicd-fil-rouge/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Waddenn/cicd-fil-rouge/actions/workflows/ci.yml)

API de gestion de tâches en Python avec FastAPI. Projet du cours CI/CD M1 à Sup de Vinci, à partir du [dépôt du professeur](https://github.com/hardymil/cicd-fil-rouge).

## Lancer l'API en local

Prérequis : Python 3.10 ou plus récent.

```bash
python3 -m venv .venv
source .venv/bin/activate          # Windows : .venv\Scripts\activate
pip install -r requirements-dev.txt
uvicorn app.main:app --reload
```

L'API répond sur http://localhost:8000 et sa documentation interactive est sur
http://localhost:8000/docs.

## Vérifier le code

```bash
pytest           # tests automatiques
ruff check .     # lint
ruff format .    # mise en forme
```

## Lancer avec Docker

```bash
docker build -t taskflow .
docker run --rm -p 8000:8000 taskflow
```

## Endpoints

| Méthode | Chemin | Rôle |
| --- | --- | --- |
| GET | `/health` | État de l'API et version |
| GET | `/tasks` | Liste des tâches |
| GET | `/tasks/search?q=...` | Recherche dans les titres |
| POST | `/tasks` | Crée une tâche (`{"title": "..."}`) |
| GET | `/tasks/{id}` | Détail d'une tâche |
| PATCH | `/tasks/{id}/done` | Marque une tâche comme faite |
| DELETE | `/tasks/{id}` | Supprime une tâche (en-tête `X-API-Token` requis) |

## Configuration

| Variable | Rôle | Défaut |
| --- | --- | --- |
| `APP_VERSION` | Version affichée par `/health` | `0.1.0` |
| `DB_PATH` | Fichier SQLite | `taskflow.db` |
| `API_TOKEN` | Jeton exigé pour supprimer une tâche | vide (suppression désactivée) |
| `NOTIFY_WEBHOOK_URL` | Webhook appelé à chaque création de tâche | vide (désactivé) |

## Gouvernance du dépôt

La [protection de main](https://github.com/Waddenn/cicd-fil-rouge/rules) est active :

- PR et une approbation obligatoires pour relire les changements avant le merge.
- Nouvelle approbation après un ajout de commit, pour valider la dernière version.
- Revue des Code Owners sur les workflows, pour contrôler les modifications de la CI.
- Force push et suppression de `main` interdits, sans exception pour les admins.
- Discussions résolues, branche à jour et check `CI OK` vert avant le merge.

Le push direct a été refusé par GitHub. [Sortie de la commande](reports/github/push-refuse.txt).

![Refus du push et de la fusion, transcription des sorties GitHub](reports/github/refus-github.png)

## Pipeline CI

Le [workflow](.github/workflows/ci.yml) tourne sur les PR vers `main` et les push sur `main`.

- `lint` : Ruff vérifie le code et le formatage.
- `test` : vérifie la compatibilité des dépendances avec `pip check`, puis lance les 9 tests sur Python 3.11, 3.12 et 3.13.
- `docker` : construit l’image, démarre un conteneur et vérifie la réponse de `/health`. Le conteneur est supprimé après le test.
- `CI OK` : vérifie que lint, les tests et le contrôle Docker ont réussi. Ce nom reste fixe même si la matrice change ; avec `always()`, un job échoué ou ignoré ne passe pas inaperçu.

Le cache pip évite de télécharger à nouveau les dépendances. Les rapports de tests sont conservés en artefacts pendant 14 jours. Un nouveau push annule le run précédent de la même PR.

[Premier run réussi sur GitHub Actions](https://github.com/Waddenn/cicd-fil-rouge/actions/runs/37441411424).

### Vérifications du lab

Le test de santé a été volontairement cassé dans la [PR #2](https://github.com/Waddenn/cicd-fil-rouge/pull/2). Les trois versions de Python et `CI OK` ont échoué. GitHub a refusé la fusion ; la PR a ensuite été fermée sans merge.

![Pipeline en échec](reports/github/ci-rouge.png)

Temps de l’étape d’installation sur le même commit (`8cdac98`), sur des runners neufs :

| Python | Sans cache restauré | Avec cache restauré |
| --- | --- | --- |
| 3.11 | 6 s | 3 s |
| 3.12 | 6 s | 8 s |
| 3.13 | 6 s | 4 s |

Mesures : [sans cache](https://github.com/Waddenn/cicd-fil-rouge/actions/runs/37442392450/attempts/2) et [avec cache](https://github.com/Waddenn/cicd-fil-rouge/actions/runs/37442392450/attempts/3). Une seule comparaison : le cache aide ici sur deux versions, mais ne garantit pas un gain à chaque run.

Le [rapport JUnit téléchargé](reports/github/artefact-python-3.11/junit.xml) contient 9 tests réussis. Les [preuves du lab](docs/labs-github.md) regroupent les résultats.

## Exercices

- [Réponses aux exercices J1](docs/exercices-j1.md)
- [Étapes des labs GitHub](docs/labs-github.md)
