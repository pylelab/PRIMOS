#!/usr/bin/perl
#
#  Fishing with worms
#  a program designed to take a probe file
#  and a database of worm files and determine 
#  the RMSDs for every possible match
#  this file then gets sorted in unix
#  and matches can be examined
#
#  April 13, 2001
#
print STDOUT "Name of the probe file:\n";
$PROBE = <STDIN>;
chop ($PROBE);
print "$PROBE\n";
$OUTPROB = $PROBE . "_primos";
open (PROBEFILE, $PROBE) || die "1couldn't open $PROBE\n";
$PROBLEN = 0;
@INPUT = ();
while (<PROBEFILE>) {
	chop $_;
	@INPUT = split /\t/;
	$PROBLEN++;
	$PROBRES[$PROBLEN] = $INPUT[2];
	$PROBTYP[$PROBLEN] = $INPUT[3];
	$PROBETA[$PROBLEN] = $INPUT[4];
	$PROBTHETA[$PROBLEN] = $INPUT[5];
	}
unless ($PROBLEN) {
	die "empty file\n";
	}
$OUTPROB = $PROBE . "_primos";
open (STEPSH, ">step2.sh") || die "couldn't open step2.sh\n";
print STEPSH "#!/bin/sh\n";
print STEPSH "#\n#\n#  step2.sh\n#  intermediate program in primos execution\n#\n#\n";
print STEPSH "sort -n tempoutput >";
print STEPSH " tempsort\n";
print STEPSH "rm tempoutput\n";
print STEPSH "cat temptop tempsort >";
print STEPSH " $OUTPROB\n";
print STEPSH "rm tempsort\n";
print STEPSH "rm temptop\n";
print STEPSH "rm step2.sh\n";
$WORMDIR = "E:/Data/temp";
print STDOUT "What is your worm directory? (default $WORMDIR)\n";
$QUERY = <STDIN>;
chop ($QUERY);
if ($QUERY) {
	$WORMDIR = $QUERY;
	}
opendir(DIRWORM, $WORMDIR) || die "2couldn't open $WORMDIR\n";
@WORMFILES = readdir DIRWORM;
$RESULTS = "tempoutput";
open (OUTPROB, ">$RESULTS") || die "3couldn't open $RESULTS\n";
foreach $FILE (@WORMFILES) {
	$_ = $FILE;
	if (/worm.txt$/) {
		$WORM = $WORMDIR . "/" . $FILE;
		print "$WORM\n";
		$PDBNAM = substr($_, 0, 4);
		if (&COMPARE($WORM)) {
			$POSN = 0;
			for ($j = 1; $j <= $TOTCOMPS; $j++) {
				printf OUTPROB " %6.2f ", ($TOTDIST[$j] / $PROBLEN);
				printf OUTPROB "%-4s  %-2s %5s  %5s ", $PDBNAM, $WORMCHN, $WORMRES[$j], $WORMRES[$j+$PROBLEN-1];
				for ($k = 0; $k < $PROBLEN; $k++) {
					printf OUTPROB "%4s ", $WORMTYP[$j+$k];
					}
				for ($k = 1; $k <= $PROBLEN; $k++) {
					$POSN++;
					printf OUTPROB "  %6.2f ", $NTDIST[$POSN];  
					}
				printf OUTPROB "\n";
				}
			}
		}
	}
open (OUTTOP, "> temptop") || die "couldn't open temptop\n";
print OUTTOP "Average PDBID     1stNT    lastNT    Sequence\n";



sub COMPARE {
	open (WORMFILE, $WORM) || die "4couldn't open $WORM\n";
	$WORMLEN = 0;
	$GOGO = 0;
	@INPUT = ();
	while (<WORMFILE>) {
		chop $_;
		@INPUT = split /\t/;
		$WORMLEN++;
		$WORMCHN = $INPUT[1];
		$WORMRES[$WORMLEN] = $INPUT[2];
		$WORMTYP[$WORMLEN] = $INPUT[3];
		$WORMETA[$WORMLEN] = $INPUT[4];
		$WORMTHETA[$WORMLEN] = $INPUT[5];
		}
	if ($WORMLEN < $PROBLEN) {
		return $GOGO;
		}
	else {
		$GOGO = 1;
		$TOTCOMPS = $WORMLEN - $PROBLEN +1;
		$TOTNT = 0;
		for ($i = 0; $i < $TOTCOMPS; $i++) {
			$TOTDIST[$i+1] = 0;
			for ($COMPLEN = 1; $COMPLEN <= $PROBLEN; $COMPLEN++) {
				$TOTNT++;
				$POSN = $i + $COMPLEN;
				$DISTETA = (($WORMETA[$POSN] - $PROBETA[$COMPLEN])**2)**(1/2);
				if ($DISTETA > 180.0) {
					$DISTETA = 360 - $DISTETA;
					}
				$DISTTHETA = (($WORMTHETA[$POSN] - $PROBTHETA[$COMPLEN])**2)**(1/2);
				if ($DISTTHETA > 180.0) {
					$DISTTHETA = 360 - $DISTTHETA;
					}
				$NTDIST[$TOTNT] = (($DISTETA**2) + ($DISTTHETA**2))**(1/2);
				$TOTDIST[$i+1] += $NTDIST[$TOTNT];
				}
			}
		}
	return $GOGO;
	}
