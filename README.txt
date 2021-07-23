PRIMOS
copyright 2021, Chengxin Zhang and the Yale University
copyright 2003, Carlos Duarte and the Trustees of Columbia University
current latest revision - 07/23/2021

This software is described in the paper:
Duarte, Wadley & Pyle, Nucl. Acids Res., 31:4755-4761, 2003

--------

QUICKSTART INSTALLATION & INSTRUCTIONS

First, change to the directory that contains primos.tar.gz, and untar
it:

gzip -dc primos.tar.gz | tar xf -

PRIMOS will be uncompressed into a subdirectory called 'PRIMOS'.

The PRIMOS package contains 4 perl scripts:
pricomp.pl
prilaunch.pl
prisearch.pl
priworm.pl

and a shell script that runs the program:
primos.sh


There are two methods for setting up the program depending on your 
workstation setup.  

Method A:
1. Make a copy of the "primos.sh" shell script in a directory in your path
 (e.g. /usr/local/bin).
2. Make a local directory for the 4 perl scripts and place them there.
3. Set the environment variable PRIMOSBASE to the directory where the 
   PRIMOS files are located (These variables are usually set in your
   ".cshrc", ".bashrc", etc... depending on the type of shell you are 
   running).

   For bash:
   export PRIMOSBASE=/directory/for/primos

   For csh, tcsh:
   setenv PRIMOSBASE /directory/for/primos

Method B:
1. copy all 5 files to a local directory.
2. create an alias for the "primos.sh" shell script that points to its
location.
3. same as step 3 above.

If you follow Method B, you can also always run PRIMOS from the
directory where you placed the files.

There are other ways to set this up as well, but these should work.

--------

WHAT PRIMOS DOES

PRIMOS is a computational method for querying the RNA structural
database.  The software takes advantage of a shorthand two-dimensional
description for nucleotide structure (described in JMB,
284:1465-1478,1998) by extending it to a third dimension in sequence
space.  This yields a simple description of the overall structure of
an RNA molecule,

Using this approach whole molecular complexes can be compared to each
other on a nucleotide by nucleotide basis regardless of size.
Additionally, motif searches can be performed in order to determine
whether a novel fold has been identified previously in the context of
other structures.

--------

EXECUTING PRIMOS

Upon execution the program will ask you questions about what you would
like to do.  There are 3 basic tasks that PRIMOS performs:


**TASK 1** "Create an RNA worm database from a directory of PDB
files."

This task parses a directory of PDB files and outputs the eta and
theta values for all applicable nucleotides. One file is created for
each nucleic acid chain encountered.

This task is a prerequisite to performing searches and comparisons
using PRIMOS (TASKS 2 or 3).

Notes: when specifying a directory absolute or relative pathnames are
okay (e.g. "/home/user/data/pdb" or "data/pdb"), but home directory
shortcuts (e.g. ~user/pdb) are not.

Output: this task creates one file for each RNA chain encountered. For
example:

464d.pdb_3_worm.txt

This file contains the eta & theta values for the third chain
occurring in the PDB file, 464d. Chains are numbered according to
their order in the PDB file and do not necessarily reflect the chain
IDs found in the file.

The contents of an output file might look like:

464d.pdb        3       C   2     A      167.6   220.7   13.69
464d.pdb        3       C   3     G      171.1   201.6   16.93
464d.pdb        3       C   4     C      166.2   217.7   10.12
464d.pdb        3       C   5     U      170.4   206.4   10.44
464d.pdb        3       C   6     C      169.1   217.8   12.58

The fields are as follows:

1) PDB filename 
2) chain indicator (here, this represents the third chain in the
file).
3) chain ID, as given in the PDB file.
4) residue number, as given in the PDB file.
5) base type
6) eta-value
7) theta-value
8) B-factor (optional)


**TASK 2** "Perform a motif search using a probe worm."  

This task uses a probe worm to search for matches within an RNA worm
database.

Before performing this task, you must create a fragment worm file
which represents the structural feature of interest. (In our use,
fragment files of 3 to 7 nucleotides in length were best.)  The
fragment worm file is created by editing a worm file created for the
structure of interest. You should leave only the the stretch of
nucleotides you wish to search for.

For example, the file 464d.pdb_3_worm.txt could be edited to contain
only:

464d.pdb        3       C   3     G      171.1   201.6   16.93
464d.pdb        3       C   4     C      166.2   217.7   10.12
464d.pdb        3       C   5     U      170.4   206.4   10.44

Residues 3-5 from chain C of 464d would then be used as a probe
worm. 

Output: Suppose you name the probe file "probe.txt". PRIMOS asks for
the name of the probe file (probe.txt) and the directory that contains
the worm database (created by TASK 1). The output is a file called
"probe.txt_primos". It might look like:

Average PDBID     1stNT    lastNT    Sequence
   0.00 464d  3   C   3    C   5     G    C    U      0.00     0.00     0.00
   2.55 469d  2   B  18    B  20    +A   +U   +U      1.30     3.91     2.42
   3.25 486d  5   E  41    E  43     G    C    C      1.77     4.07     3.91
   3.99 409d  5   E  37    E  39     U    G    G      1.49     6.82     3.68
.....

This file is sorted by how closely a particular worm fragment matches
the probe worm. Good matches come first.

"Average"=overall delta(eta,theta) (equation 2 from Duarte, Wadley
& Pyle).
"PDBID"=PDB code of match
Third field=chain indicator
"1stNT"=chain ID and residue number for the start of the fragment that
has been probed.
"lastNT"=last nucleotide in the sequence.
"Sequence"=base sequence of fragment that has been probed.
The last three fields represent the delta(eta,theta) values (equation
1 from Duarte, Wadley & Pyle) for the individual nucleotides.


**TASK 3** "Perform whole structural comparisons."  

This task generates a list of the differences between two structures
of the same complex on a nucleotide by nucleotide basis.

Notes: This comparison assumes that the two structures being compared
are the same length and type.  If these conditions are not true the
program will still output measurements but the results may not be
meaningful.

First, you will be asked for a "Filename for the first structure." You
should enter the name of a worm file created by TASK 1.  All other
structures will be compared against this one.

Second, you are asked to enter a "Directory containing structures to
be compared." This directory should also contain worm files created by
TASK 1.

Output: if the first structure you specified was 464d.pdb_3_worm.txt,
the output file will be 464d.pdb_3_worm.txt_compare. It might look
like:

PDBID   Chain#  NT      Type      Dist  Bfact1  Bfact2
466d    3       C   2     A       2.11    0.00    0.00
466d    3       C   3     G       3.88    0.00    0.00
466d    3       C   4     C       4.51    0.00    0.00
466d    3       C   5     U       5.62    0.00    0.00
466d    3       C   6     C       1.89    0.00    0.00


"PDBID"=the file being compared.
"Chain#"=chain indicator.
"NT"=the chain ID from the PDB file followed by the residue number.
"Type"=base type
"Dist"=delta(eta,theta) (equation 1 from Duarte, Wadley & Pyle)
"Bfact1", "Bfact2"=difference in B-factors (always 0.00 if B-factors were
not included).


--------

TROUBLESHOOTING

**PDB files that do not conform to the PDB Format Description (available
at http://www.pdb.org) may not be read correctly and may generate
errors. This situation arises most frequently when third-party
software is used to output files in PDB format. Typically, the columns
are aligned incorrectly, and adding or deleting spaces between fields
will fix the problem. Report this to the authors of the third-party
software if this problem occurs.

**If you receive an error like the following:

./primos.sh: line 8: /prilaunch.pl: No such file or directory
chmod: failed to get attributes of `step1.sh': No such file or directory
./primos.sh: line 10: ./step1.sh: No such file or directory,

then you likely have not set the PRIMOSBASE environment. Refer to the
installation instructions above.

**If you receive an error like the following:

couldn't open step1.sh, check permissions.
chmod: failed to get attributes of `step1.sh': No such file or directory
/usr/bin/primos.sh: line 10: ./step1.sh: No such file or directory,

you are likely running PRIMOS in a non-writable directory. Make sure
you run PRIMOS in a directory in which you have write access.

**If a PRIMOS process is interrupted, you may find the files,
'step1.sh' and/or 'step2.sh'.in the directory from which PRIMOS was
run. These can safely be deleted.

**Some PDB files contain multiple conformations of the same atom. For
example, two conformations of the atom, "O3*", could be labeled "O3*A"
and "O3*B". PRIMOS considers only the first such conformation that
occurs in the PDB file. Any subsequent conformations are ignored. If
you would like to use other conformations instead, modify the PDB file
so that the desired conformation is the first listed.

--------

KNOWN BUGS & ISSUES

**With some versions of Perl, PRIMOS cannot handle more than 255 (maybe
256) files at a time.  To overcome this issue, separate your files
into batches and run PRIMOS multiple times.

**While generating the worm database, PRIMOS checks if neighboring
nucleotides are connected by employing a distance cutoff between O3'
and P atoms. If this cutoff is exceeded, "Broken worm" is output to
the screen. However, a worm search will not recognize this worm as
broken. It is possible a false-positive result could occur in such a
situation. Please inspect the worm matches to ensure this is not the
case.

**PRIMOS may generate empty output files. They correspond to chains in
PDB files that do not contain RNA nucleotides or only contain RNA
nucleotides for which eta and theta are not defined. These output
files can safely be ignored.

**PRIMOS fails on the following PDB files: 1C59, 1DV4, 1FKA, 1H3E,
1HR0, 1N35, 1N38. The error reported is an "Illegal division by
zero..." This problem appears to occur with PDB files that have
nucleotides with certain atoms missing. We are working on fixing this
bug. In the meantime, removing nucleotides with missing atoms from the
appropriate PDB file will likely fix the problem.
