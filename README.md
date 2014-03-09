HuffmanPerl
===========

Perl basic implementation of Huffman compression algorithm (in French). 

Realized during the first year at [high school Arc](http://www.he-arc.ch) (Switzerland).

Description
-----------
Permet de compresser un fichier avec l'algorithme de Huffman. La table de compression est affichée à la console et le fichier compressé est enregistré dans un fichier du même nom avec l'extension .hf

**Syntaxe :**  ./Huffman.pl   adresseFichier
* **adresseFichier :** Adresse du fichier à compresser

Structure des données
---------------------
Dans notre cas et étant donné qu'il ne s'agit pas de l'algorithme dynamique de Huffman, nous pouvons nous passer des arbres. On peut ici utiliser tout simplement des tableaux associatifs (voir l'algorithme du script).

Choix du langage de programmation
---------------------------------
PERL a été choisi pour plusieurs raisons, tout d'abord car les structures de données dont nous avons besoin existent dans le langage et sont aisées à manipuler, ensuite car le langage permet de gérer facilement toutes les tâches liées à la manipulation de chaînes de caractères et enfin il n'y a pas de limitation sur la taille des données ou de leur contenu.

Stockage des données compressées
--------------------------------
Lors de l'utilisation du script, la table de compression est affichée à la console et le fichier une fois compressé est enregistré sous le même nom mais avec l'extension .hf. Il serait aussi possible d'enregistrer la table de compression dans un autre fichier, celle-ci doit être sauvegardée dans le même fichier que le contenu du fichier compressé en séparant ce contenu de la table de compression.

Evaluation par rapport aux autres compressions
----------------------------------------------
Le programme a été évalué avec un grand fichier texte (Lorem Ipsum à 15 paragraphes)

* **Taille initiale :** 9'325 octets
* **Taille compressée :** 4'943 octets (A noter que la table de compression n'est pas incluse)
* **Taille Zip :** 3'161 octets
* **Taille 7Z :** 3'112 octets
