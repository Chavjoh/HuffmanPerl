HuffmanPerl
===========

Perl basic implementation of Huffman compression algorithm (in French). 
Realized during the first year at high school Arc (Switzerland).

Description
-----------
Permet de compresser un fichier avec l'algorithme de Huffman. La table de compression est affich�e � la console et le fichier compress� est enregistr� dans un fichier du m�me nom avec l'extension .hf

Syntaxe :  ./Huffman.pl   adresseFichier
  - adresseFichier : Adresse du fichier � compresser

Structure des donn�es
---------------------
Dans notre cas et �tant donn� qu'il ne s'agit pas de l'algorithme dynamique de Huffman, nous pouvons nous passer des arbres. On peut ici utiliser tout simplement des tableaux associatifs (voir l'algorithme du script).

Choix du langage de programmation
---------------------------------
Le PERL a �t� choisi pour plusieurs raisons, tout d'abord car les structures de donn�es dont nous avons besoin existent dans le langage et sont ais�es � manipuler, ensuite car le langage permet de g�rer facilement toutes les t�ches li�es � la manipulation de cha�nes de caract�res et enfin il n'y a pas de limitation sur la taille des donn�es ou de leur contenu.

Stockage des donn�es compress�es
--------------------------------
Lors de l'utilisation du script, la table de compression est affich�e � la console et le fichier une fois compress� est enregistr� sous le m�me nom mais avec l'extension .hf. Il serait aussi possible d'enregistrer la table de compression dans un autre fichier, mais pour plus de simplicit� et de facilit� d'utilisation, la table de compression doit �tre sauvegard�e dans le m�me fichier que le contenu du fichier compress� en s�parant ce contenu de la table de compression.

Evaluation par rapport aux autres compressions
----------------------------------------------
Le programme a �t� �valu� avec un grand fichier texte (Lorem Ipsum � 15 paragraphes)

Taille initiale : 	9'325 octets
Taille compress�e :	4'943 octets (A noter que la table de compression n'est pas incluse)
Taille Zip :		3'161 octets
Taille 7Z :			3'112 octets