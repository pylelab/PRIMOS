#!/usr/bin/perl
#
# PRIMOS 
# Probing Rna to Identify Motifs and Other Structures
# By Carlos M Duarte
# Copyright 2002 
#
# PRIMOS has three functions: database creation, motif search, and structural comparisons
# This module queries the user for which function they want then creates a shell script 
# which executes the appropriate perl script
#

print STDOUT "\nWelcome to PRIMOS.\n";
print STDOUT "What would you like to do?\n";
print STDOUT " 	Create an RNA worm database from a directory of PDB files (type \"D\")\n";
print STDOUT "	Perform a motif search using a probe worm (type \"S\")\n";
print STDOUT "	Perform whole structural comparisons (type \"C\")\n";
$ANSWER = <STDIN>;
chop ($ANSWER);
open (SHELL, ">step1\.sh") || die "couldn't open step1.sh, check permissions.\n";
print SHELL "#!/bin/sh\n";
print SHELL "#\n# temporary shell script that directs the rest of the PRIMOS execution\n#\n";
if ($ANSWER eq "D" || $ANSWER eq "d") {
	print SHELL "\$PRIMOSBASE/priworm.pl\n";
	print SHELL "rm step1.sh\n";
	}
elsif ($ANSWER eq "C" || $ANSWER eq "c") {
	print SHELL "\$PRIMOSBASE/pricomp.pl\n";
	print SHELL "rm step1.sh\n";
	}
elsif ($ANSWER eq "S" || $ANSWER eq "s") {
	print SHELL "\$PRIMOSBASE/prisearch.pl\n";
	print SHELL "chmod +x step2.sh\n";
	print SHELL "\./step2.sh\n";
	print SHELL "rm step1.sh\n";
	}
else {
	print STDOUT "ya gotta type either D, S or C\n";
	}
