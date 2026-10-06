# TaskFlow — dépôt fil rouge CI/CD

TaskFlow est une petite API de gestion de tâches écrite en Python avec FastAPI.
C'est le projet fil rouge du module CI/CD (Mastère DevOps M1, Sup de Vinci) :
pendant trois jours, vous allez construire autour d'elle un pipeline complet
qui teste, construit, sécurise et livre l'application.

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

- Compte de travail : `Waddenn`.
- Binôme : à renseigner avant les invitations et les revues croisées.

## Gouvernance du dépôt

Configuration préparée dans [le modèle de ruleset](docs/ruleset-main.json), à appliquer sur le fork GitHub après publication et premier run de CI. Aucune protection distante n’est attestée par ce fichier seul.

| Règle | Pourquoi |
| --- | --- |
| PR obligatoire sur main | Chaque changement passe par un diff relisible et traçable. |
| Une approbation | Un second membre contrôle le changement avant intégration. |
| Invalidation des approbations après nouveau commit | La revue doit porter sur la dernière version. |
| Revue des Code Owners pour les workflows | Les changements des contrôles CI sont eux-mêmes contrôlés. |
| Interdiction de force push | Empêche la réécriture de l’historique de main. |
| Interdiction de suppression | Préserve la branche de référence. |
| Aucun contournement, admins compris | Les garanties s’appliquent à tous. |
| Résolution des discussions et branche à jour | Évite de fusionner une discussion ouverte ou une intégration obsolète. |
| Seul check obligatoire : CI OK | Maintient un nom stable malgré l’évolution de la matrice. |

CODEOWNERS désigne actuellement `@Waddenn`. Le binôme devra être ajouté avec le droit Write pour pouvoir approuver les PR de Waddenn qui modifient les workflows. La capture du push refusé reste à produire sur le fork protégé ; aucun refus local n’est présenté comme un refus GitHub.

## Pipeline CI

[Le workflow](.github/workflows/ci.yml) se déclenche sur les PR vers main, les push sur main et manuellement. Il possède uniquement la permission `contents: read`.

- `lint` vérifie les règles Ruff et le formatage.
- `test` lance Pytest sur Python 3.11, 3.12 et 3.13 en parallèle, sans arrêter les autres versions au premier échec.
- Le cache pip dépend des deux fichiers de dépendances ; l’installation est exécutée même si le cache manque.
- Chaque version publie son propre rapport JUnit, conservé 14 jours, y compris après un test en échec.
- `concurrency` annule les runs dépassés sur la même PR ou branche.

`CI OK` est le seul nom à exiger dans le ruleset et agrège lint et toute la matrice de tests. Son exécution est inconditionnelle avec `always()`, puis il échoue si un résultat n’est pas exactement `success`, y compris lorsqu’un job est ignoré ou annulé.

### Validation et mesures

Les preuves locales se trouvent dans `reports/local/` après exécution de `scripts/validate-local.sh`. Elles vérifient l’application et le formatage ; elles ne prouvent ni l’exécution sur GitHub Actions ni le blocage d’une PR.

| Mesure GitHub Actions | Durée |
| --- | --- |
| Installation sans cache restauré | À mesurer sur le fork |
| Installation avec cache restauré | À mesurer sur le même commit et la même version Python |

La capture de la PR bloquée, les liens de runs et l’artefact téléchargé seront ajoutés après les labs distants. La procédure détaillée est dans [les labs GitHub](docs/labs-github.md), et les réponses théoriques dans [les exercices J1](docs/exercices-j1.md).
