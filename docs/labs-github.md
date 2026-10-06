# Résultats des labs J1

## Dépôt et protection

Fork : https://github.com/Waddenn/cicd-fil-rouge

Le ruleset `Protection main J1` est actif sur main, sans bypass. Il impose une PR, une approbation, la revue des Code Owners, la résolution des discussions, une branche à jour et le check `CI OK`. Il interdit la suppression et le force push. Les approbations sont invalidées après un nouveau commit.

- [Export du ruleset actif](../reports/github/ruleset.json)
- [Refus du push direct](../reports/github/push-refuse.txt)
- [Capture de la transcription des refus](../reports/github/refus-github.png)

Le commit de test du push était vide : même contenu que main, mais un nouvel identifiant. GitHub a refusé sa publication avec GH013. Main n’a pas été modifiée par cet essai.

## Pipeline et test rouge

Le pipeline et les exercices ont été intégrés dans la [PR #1](https://github.com/Waddenn/cicd-fil-rouge/pull/1). Cette première PR a été fusionnée avant l’activation du ruleset et ne constitue pas une preuve de revue par le binôme.

Dans la [PR #2](https://github.com/Waddenn/cicd-fil-rouge/pull/2), le test attendait volontairement `ko` au lieu de `ok`. Lint est passé ; les trois jobs de tests et CI OK ont échoué. Une demande de fusion via l’API a reçu HTTP 405, avec les motifs « Required status check CI OK is failing » et approbation requise. La PR a été fermée sans fusionner.

- [État des checks et blocage](../reports/github/pr-rouge.json)
- [Réponse du refus de fusion](../reports/github/merge-refuse.json)
- [Capture du run rouge](../reports/github/ci-rouge.png)

La capture du run provient de GitHub. La capture des refus est une transcription HTML des sorties Git et API conservées à côté, pas une capture du bouton de fusion : le navigateur n’était pas connecté à GitHub.

## Cache et artefact

Le run 37442392450 a été relancé deux fois au même commit 8cdac98. Les caches du seul dépôt du cours ont été supprimés avant la tentative 2. Ses logs indiquent `pip cache is not found`. La tentative 3 restaure les caches générés par la tentative 2. Chaque job utilise un runner neuf.

| Python | Tentative 2 sans cache | Tentative 3 avec cache |
| --- | --- | --- |
| 3.11 | 6 s | 3 s |
| 3.12 | 6 s | 8 s |
| 3.13 | 6 s | 4 s |

Durées calculées depuis les timestamps de l’étape `Installer les dépendances`, arrondis à la seconde par GitHub. Elles excluent la restauration du cache et ne constituent pas un benchmark statistique. Le résultat sur Python 3.12 montre la variabilité des runners.

- [Jobs sans cache](../reports/github/cache-froid-jobs.json) et [logs](../reports/github/cache-froid.log)
- [Jobs avec cache](../reports/github/cache-chaud-jobs.json) et [logs](../reports/github/cache-chaud.log)
- [Rapport JUnit téléchargé depuis la tentative 2](../reports/github/artefact-python-3.11/junit.xml) : 9 tests, 0 échec, 0 erreur.

## Revue

La PR du rendu passe par les protections actives. Une approbation par une autre personne ayant le droit Write est nécessaire à sa fusion. CODEOWNERS désigne Waddenn pour les workflows ; une PR de Waddenn modifiant ces fichiers exige donc une adaptation des propriétaires par une PR approuvée ou un changement proposé par le binôme. La PR du rendu ne modifie ni les workflows ni CODEOWNERS.
