# Exercices du jour 1

## CI, Delivery ou Deployment

| Cas | Réponse | Justification |
| --- | --- | --- |
| 1. Tests sur PR, copie FTP le vendredi | CI, sous réserve d’intégrations fréquentes | Les tests apportent du feedback, mais la copie manuelle ne démontre pas une livraison reproductible et toujours prête. |
| 2. Image testée en staging, bouton du PO | Continuous Delivery | L’artefact est prêt ; une décision humaine déclenche la production. |
| 3. Merge sur main puis production après tests | Continuous Deployment | Le passage en production est automatique après validation. |
| 4. Jenkins, branches de trois semaines | Pas de véritable intégration continue | L’outil ne compense pas des intégrations trop rares et les conflits accumulés. |
| 5. Automatisation, validation d’un comité | Continuous Delivery | L’approbation humaine reste la dernière porte avant la production. |
| 6. Production automatique sans tests | Automatisation de déploiement, pas une chaîne CI/CD fiable | L’absence de vérification supprime la garantie attendue de la CI. |

## Vérification du matin

Une validation du PO correspond à Continuous Delivery. Pour garantir que le code déployé est celui qui a été relu, on impose la PR et les checks sur main, on invalide les approbations après une modification et on rattache le build au commit exact. On construit une fois et on promeut le même artefact immuable, identifié par son digest, du staging vers la production.

Un hash permet de détecter une modification de l’historique ; il n’empêche pas sa réécriture et ne prouve pas l’identité de l’auteur. Une signature prouve la possession de la clé correspondante ; son attribution dépend de la confiance accordée à cette clé.

## Vérification de l’après-midi

Après ajout d’une matrice, le job `test` apparaît sous plusieurs noms, comme `test (Python 3.11)`. Si le ruleset attend encore l’ancien contexte `test`, ce check ne sera jamais reçu et la PR restera bloquée malgré les jobs verts.

`CI OK` donne un nom stable au contrôle obligatoire et dépend de `lint` et de toutes les exécutions de `test`. Avec `if: always()`, il s’exécute même après un échec, puis exige explicitement que les deux résultats soient `success` : un job ignoré ou annulé ne suffit pas.

## Cache, artefact et parallélisme

Le cache pip réutilise des téléchargements et des wheels ; il ne remplace jamais l’installation des dépendances. Un cache absent doit seulement ralentir le job. Le rapport JUnit est un artefact du run, conservé même lorsque les tests échouent, avec un nom distinct par version de Python.

Les jobs lint et test peuvent démarrer ensemble ; les trois versions de Python sont indépendantes. `needs` est réservé à l’agrégation finale. `concurrency` annule les exécutions devenues obsolètes sur une même PR ou branche.

## Discussion sur une mauvaise mise en production

Exemple fictif à adapter à une expérience réelle : une copie manuelle laisse un mélange de deux versions sur le serveur. L’application démarre mais certains endpoints échouent. Un artefact immuable, un passage en staging, un contrôle de santé et un retour à l’artefact précédent auraient rendu la livraison plus sûre et le rétablissement plus rapide.
