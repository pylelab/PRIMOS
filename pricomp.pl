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
print STDOUT "Filename for the first structure:\n";
$PROBE = <STDIN>;
chop ($PROBE);
print "$PROBE\n";
if ($PROBE) {
	open (PROBEFILE, $PROBE) || die "couldn't open $PROBE\n";
	}
else {
	end
	}
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
	$PROBBFAC[$PROBLEN] = $INPUT[6];
	}
unless ($PROBLEN) {
	die "empty file\n";
	}
$WORMDIR = "E:/Data/temp";
print STDOUT "Directory containing structures to be compared: (Default $WORMDIR)\n";
$QUERY = <STDIN>;
chop ($QUERY);
if ($QUERY) {
	$WORMDIR = $QUERY;
	}
opendir(DIRWORM, $WORMDIR) || die "couldn't open $WORMDIR\n";
@WORMFILES = readdir DIRWORM;
$RESULTS = $PROBE . "_compare";
open (OUTPROB, ">$RESULTS") || die "couldn't open $RESULTS\n";
print OUTPROB "PDBID\tChain#\tRes\tType\t  Dist\tBfact1\tBfact2\n";
foreach $FILE (@WORMFILES) {
	$_ = $FILE;
	if (/worm.txt$/) {
		$WORM = $WORMDIR . "/" . $FILE;
		print "$WORM\n";
		$PDBNAM = substr($_, 0, 4);
		if (&COMPARE($WORM)) {
			$POSN = 0;
			for ($j = 1; $j <= $TOTCOMPS; $j++) {
				for ($k = 0; $k < $PROBLEN; $k++) {
					printf OUTPROB "%-4s\t%-2s\t%5s\t", $PDBNAM, $WORMCHN, $WORMRES[$j + $k];
					printf OUTPROB "%4s\t", $WORMTYP[$j+$k];
					$POSN++;
					printf OUTPROB "%6.2f\t", $NTDIST[$POSN];  
					printf OUTPROB "%6.2f\t", $PROBBFAC[$POSN];
					printf OUTPROB "%6.2f", $WORMBFAC[$POSN];
					printf OUTPROB "\n";
					}
				}
			}
		}
	}



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
		$WORMBFAC[$WORMLEN] = $INPUT[6];
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
