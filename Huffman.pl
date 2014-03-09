#!/usr/local/bin/perl
#
# Sujet :	Script de compression Huffman (non dynamique)
# Auteur :	Johan Chavaillaz
# Date :	04.11.2012
#
use strict;
use warnings;

# -------------------------------------------
# Déclaration des variables
# -------------------------------------------

# Tableau associatif contenant pour chaque caractère son occurrence
my %occurrences;

# Tableau de compression contenant pour chaque caractère son code
my %tableCompression;

# -------------------------------------------
# FONCTION ajouteCodeCompression
# -------------------------------------------
#	But :			Permettre d'ajouter un bit au code de compression
#	Paramètres :	- Valeur de la clé pour laquelle ajouter le bit fourni
#					- Bit à ajouter au code de compression (avant celui-ci)
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

# Lancement de la commande d'effacement de l'écran selon le système d'exploitation
system $^O eq 'MSWin32' ? 'cls' : 'clear';

# Titre du programme
print STDOUT "\n  Script de compression Huffman (version 1.0) :\n  =============================================\n";

# Vérification de la présence de 1 argument au script
if (scalar(@ARGV) == 1)
{
	# Variable stockant les données à traiter
	my $donnees;
	
	# Variable contenant l'adresse du fichier à compresser
	my $adresseFichier = $ARGV[0];
	
	# Vérification de l'adresse 
	if ( !(-f "$adresseFichier") )
	{
		die "  Le fichier a compresser n'existe pas. \r\n";
	}
	
	# Récupération du contenu du fichier
	local $/;
	open FILE, $adresseFichier or die "Ouverture du fichier impossible : $!"; 
	while (<FILE>) { $donnees .= $_; }
	close FILE;

	# Remplissage du tableau en fonction avec les occurrences des caractères
	foreach my $caractere ( split("", $donnees) )
	{
		# Si le caractère existe déjà dans le tableau, on l'incrémente
		if (defined $occurrences{$caractere}) {
			$occurrences{$caractere}++;
		}
		# Dans le cas contraire on le définit à 1
		else {
			$occurrences{$caractere} = 1;
		}
	}
	
	# Débogage pour afficher toutes les occurrences de chaque élément
	# foreach my $cle(keys(%occurrences)) { print "$cle => $occurrences{$cle} \r\n"; }

	# Création d'un nouveau tableau avec les clés triées numériquement
	my @clesTri = sort{ $occurrences{$a} <=> $occurrences{$b} } keys %occurrences; 

	# Boucle de création des codes de compression
	while ( scalar(@clesTri) != 1 && scalar(keys(%occurrences)) > 0)
	{
		# Création d'une nouvelle paire (clé, valeur) fusionné entre les deux premiers éléments du tableau d'occurrence trié
		# C'est une fusion entre les deux éléments les moins utilisées (le tableau étant trié par ordre croissant d'occurrence)
		my $nouvelleCle = $clesTri[0].$clesTri[1];
		my $nouvelleValeur = $occurrences{$clesTri[0]} + $occurrences{$clesTri[1]};
		
		# Ajout de la nouvelle paire dans les tableaux
		push(@clesTri, $nouvelleCle);
		$occurrences{$nouvelleCle} = $nouvelleValeur;
		
		# Tri numérique en fonction des occurrences
		@clesTri = sort{ $occurrences{$a} <=> $occurrences{$b} } keys %occurrences; 
		
		# Ajoute les codes de compression pour cette itération
		if ($occurrences{$clesTri[0]} > $occurrences{$clesTri[1]}) {
			&ajouteCodeCompression($clesTri[0], '1');
			&ajouteCodeCompression($clesTri[1], '0');
		}
		else {
			&ajouteCodeCompression($clesTri[0], '0');
			&ajouteCodeCompression($clesTri[1], '1');
		}
		
		# Suppression des anciens éléments qui sont désormais fusionnés
		delete $occurrences{$clesTri[0]};
		delete $occurrences{$clesTri[1]};
		
		# Suppression également dans le tableau des clés triées
		@clesTri = (@clesTri[2..$#clesTri]);
	}

	# Débogage pour afficher le dernier élément après toutes les fusions
	# foreach my $cle(@clesTri) { print "$cle => $occurrences{$cle} \r\n"; }

	# Débogage pour afficher l'arbre de compression
	print "  Table de compression : \r\n";
	foreach my $cle(sort keys(%tableCompression)) { print "  $cle => $tableCompression{$cle} \r\n"; }

	my $donneesCompressees;

	# Affichage de la chaine compressée
	foreach my $caractere ( split("", $donnees) ) {
		if (defined $tableCompression{$caractere}) { $donneesCompressees .= $tableCompression{$caractere}; };
	}

	# Affichage du résultat
	# print $donneesCompressees;
	
	# Enregistrement du résultat
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