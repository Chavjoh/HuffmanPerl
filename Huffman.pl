#!/usr/local/bin/perl
#
# Sujet :	Script de compression Huffman (non dynamique)
# Auteur :	Johan Chavaillaz
# Date :	04.11.2012
#
use strict;
use warnings;

# -------------------------------------------
# D�claration des variables
# -------------------------------------------

# Tableau associatif contenant pour chaque caract�re son occurrence
my %occurrences;

# Tableau de compression contenant pour chaque caract�re son code
my %tableCompression;

# -------------------------------------------
# FONCTION ajouteCodeCompression
# -------------------------------------------
#	But :			Permettre d'ajouter un bit au code de compression
#	Param�tres :	- Valeur de la cl� pour laquelle ajouter le bit fourni
#					- Bit � ajouter au code de compression (avant celui-ci)
sub ajouteCodeCompression 
{
	foreach my $valeur( split("", $_[0]) ) {
		if (defined $tableCompression{$valeur}) {
			$tableCompression{$valeur} = $_[1].$tableCompression{$valeur};
		}
		else {
			$tableCompression{$valeur} = $_[1];
		}
	}
}

# -------------------------------------------
# Programme principal
# -------------------------------------------

# Lancement de la commande d'effacement de l'�cran selon le syst�me d'exploitation
system $^O eq 'MSWin32' ? 'cls' : 'clear';

# Titre du programme
print STDOUT "\n  Script de compression Huffman (version 1.0) :\n  =============================================\n";

# V�rification de la pr�sence de 1 argument au script
if (scalar(@ARGV) == 1)
{
	# Variable stockant les donn�es � traiter
	my $donnees;
	
	# Variable contenant l'adresse du fichier � compresser
	my $adresseFichier = $ARGV[0];
	
	# V�rification de l'adresse 
	if ( !(-f "$adresseFichier") )
	{
		die "  Le fichier a compresser n'existe pas. \r\n";
	}
	
	# R�cup�ration du contenu du fichier
	local $/;
	open FILE, $adresseFichier or die "Ouverture du fichier impossible : $!"; 
	while (<FILE>) { $donnees .= $_; }
	close FILE;

	# Remplissage du tableau en fonction avec les occurrences des caract�res
	foreach my $caractere ( split("", $donnees) )
	{
		# Si le caract�re existe d�j� dans le tableau, on l'incr�mente
		if (defined $occurrences{$caractere}) {
			$occurrences{$caractere}++;
		}
		# Dans le cas contraire on le d�finit � 1
		else {
			$occurrences{$caractere} = 1;
		}
	}
	
	# D�bogage pour afficher toutes les occurrences de chaque �l�ment
	# foreach my $cle(keys(%occurrences)) { print "$cle => $occurrences{$cle} \r\n"; }

	# Cr�ation d'un nouveau tableau avec les cl�s tri�es num�riquement
	my @clesTri = sort{ $occurrences{$a} <=> $occurrences{$b} } keys %occurrences; 

	# Boucle de cr�ation des codes de compression
	while ( scalar(@clesTri) != 1 && scalar(keys(%occurrences)) > 0)
	{
		# Cr�ation d'une nouvelle paire (cl�, valeur) fusionn� entre les deux premiers �l�ments du tableau d'occurrence tri�
		# C'est une fusion entre les deux �l�ments les moins utilis�es (le tableau �tant tri� par ordre croissant d'occurrence)
		my $nouvelleCle = $clesTri[0].$clesTri[1];
		my $nouvelleValeur = $occurrences{$clesTri[0]} + $occurrences{$clesTri[1]};
		
		# Ajout de la nouvelle paire dans les tableaux
		push(@clesTri, $nouvelleCle);
		$occurrences{$nouvelleCle} = $nouvelleValeur;
		
		# Tri num�rique en fonction des occurrences
		@clesTri = sort{ $occurrences{$a} <=> $occurrences{$b} } keys %occurrences; 
		
		# Ajoute les codes de compression pour cette it�ration
		if ($occurrences{$clesTri[0]} > $occurrences{$clesTri[1]}) {
			&ajouteCodeCompression($clesTri[0], '1');
			&ajouteCodeCompression($clesTri[1], '0');
		}
		else {
			&ajouteCodeCompression($clesTri[0], '0');
			&ajouteCodeCompression($clesTri[1], '1');
		}
		
		# Suppression des anciens �l�ments qui sont d�sormais fusionn�s
		delete $occurrences{$clesTri[0]};
		delete $occurrences{$clesTri[1]};
		
		# Suppression �galement dans le tableau des cl�s tri�es
		@clesTri = (@clesTri[2..$#clesTri]);
	}

	# D�bogage pour afficher le dernier �l�ment apr�s toutes les fusions
	# foreach my $cle(@clesTri) { print "$cle => $occurrences{$cle} \r\n"; }

	# D�bogage pour afficher l'arbre de compression
	print "  Table de compression : \r\n";
	foreach my $cle(sort keys(%tableCompression)) { print "  $cle => $tableCompression{$cle} \r\n"; }

	my $donneesCompressees;

	# Affichage de la chaine compress�e
	foreach my $caractere ( split("", $donnees) ) {
		if (defined $tableCompression{$caractere}) { $donneesCompressees .= $tableCompression{$caractere}; };
	}

	# Affichage du r�sultat
	# print $donneesCompressees;
	
	# Enregistrement du r�sultat
	open(FILE,">".$adresseFichier.".hf") or die ("Ouverture du fichier impossible : $!");
	binmode(FILE);
	print FILE pack("B*", $donneesCompressees);
	close(FILE);
}
else
{
  print STDOUT "  Permet de compresser un fichier avec l'algorithme de Huffman. 
  La table de compression est affichee a la console et le fichier compresse 
  est enregistre dans un fichier du meme nom avec l'extension .hf
  
  Syntaxe :  ./Huffman.pl   adresseFichier
    - adresseFichier : Adresse du fichier a compresser
  
  Par Johan Chavaillaz
  ";
}