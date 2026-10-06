# TaskFlow — dépôt fil rouge CI/CD

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

## Équipe

- Waddenn
- Binôme à compléter

## Gouvernance du dépôt

Les règles sont préparées dans [ruleset-main.json](docs/ruleset-main.json), mais restent à activer sur GitHub :

- PR et une approbation obligatoires pour relire les changements avant le merge.
- Nouvelle approbation après un ajout de commit, pour valider la dernière version.
- Revue des Code Owners sur les workflows, pour contrôler les modifications de la CI.
- Force push et suppression de `main` interdits, sans exception pour les admins.
- Discussions résolues, branche à jour et check `CI OK` vert avant le merge.

Le binôme reste à ajouter dans [CODEOWNERS](.github/CODEOWNERS). La capture du push refusé sera ajoutée après activation des règles.

## Pipeline CI

Le [workflow](.github/workflows/ci.yml) tourne sur les PR vers `main` et les push sur `main`.

- `lint` : Ruff vérifie le code et le formatage.
- `test` : Pytest lance les 9 tests sur Python 3.11, 3.12 et 3.13.
- `CI OK` : vérifie que lint et tous les tests ont réussi. Ce nom reste fixe même si la matrice change ; avec `always()`, un job échoué ou ignoré ne passe pas inaperçu.

Le cache pip évite de télécharger à nouveau les dépendances. Les rapports de tests sont conservés en artefacts pendant 14 jours. Un nouveau push annule le run précédent de la même PR.

[Premier run réussi sur GitHub Actions](https://github.com/Waddenn/cicd-fil-rouge/actions/runs/37441411424).

À compléter pour le lab : capture de la PR bloquée et comparaison des temps d’installation avec et sans cache.

## Exercices

- [Réponses aux exercices J1](docs/exercices-j1.md)
- [Étapes des labs GitHub](docs/labs-github.md)
