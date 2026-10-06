# Exécution des labs GitHub

Ces étapes nécessitent un fork public autorisé et un binôme identifié. Les fichiers locaux ne constituent pas une preuve que les règles GitHub sont actives.

## Matin

1. Créer le fork de `hardymil/cicd-fil-rouge` dans le compte choisi et définir `origin` sur ce fork ; conserver le professeur comme `upstream`.
2. Inviter le binôme avec le rôle Write, après accord sur son identifiant. Ajouter son compte à CODEOWNERS : un auteur ne peut pas approuver sa propre PR.
3. Activer un ruleset sur main : PR obligatoire, une approbation, approbations invalidées après nouveau commit, revue des Code Owners, interdiction de suppression et de force push, aucun bypass. Pour ce premier lab, ne pas encore exiger CI OK qui n’existe pas sur GitHub.
4. Depuis un clone de test, créer un commit vide et tenter un push vers main ; enregistrer le refus GitHub et une capture réelle du terminal. Un `Everything up-to-date` ne prouve pas la protection. Si le push réussit, arrêter et corriger le ruleset avant de poursuivre.
5. Ouvrir une PR `feat/readme-equipe`, base = le fork, faire approuver par le binôme et fusionner.

## Après-midi partie 1

1. Sur `feat/ci`, démarrer avec deux jobs `lint` et `test`, sans matrice. Copier `docs/ci-simple.yml.example` vers `.github/workflows/ci.yml` pour cette étape.
2. Activer Actions, ouvrir la PR sur le fork, vérifier les checks, demander la revue du binôme et fusionner.
3. Exiger `lint` et `test` dans le ruleset.
4. Sur `fix/casse-test`, remplacer provisoirement l’attendu `ok` par `ko` dans le test de santé. Ouvrir une PR, constater le test rouge et le merge bloqué, capturer l’écran puis fermer la PR sans fusionner.

## Après-midi partie 2

1. Sur `feat/ci-rapide`, utiliser le workflow final `.github/workflows/ci.yml` : matrice, cache, rapports et concurrency.
2. Constater que le contexte obligatoire historique `test` manque depuis le changement des noms par la matrice.
3. Après le premier run qui crée le contexte `CI OK`, remplacer les checks obligatoires par ce seul contexte. Le modèle final est `docs/ruleset-main.json` ; vérifier son application et ne pas l’interpréter comme une configuration déjà active.
4. Comparer deux installations sur la même version Python et le même commit : un run sans restauration du cache puis un run avec restauration. Utiliser des runners neufs et conserver les liens des runs, l’état de restauration et la durée de l’étape d’installation. Ne pas utiliser le temps d’un environnement déjà installé comme mesure avec cache.
5. Télécharger l’artefact `pytest-3.11` depuis le run et vérifier son XML. Conserver l’archive téléchargée avec les preuves.
6. Faire approuver et fusionner la PR par le binôme.

## Preuves à joindre

- Capture du push direct réellement refusé par GitHub.
- Liens des PR et approbations du binôme.
- Capture de la PR au test rouge avec fusion bloquée.
- Export du ruleset réellement actif.
- Deux liens de runs et leurs durées d’installation avec et sans cache.
- Rapport de tests réellement téléchargé depuis GitHub Actions.

Le bonus de signature SSH nécessite une clé choisie et enregistrée sur GitHub. Le badge de CI doit pointer vers le fork réel et sa branche main ; il ne faut pas afficher le statut du dépôt du professeur comme preuve du rendu.
