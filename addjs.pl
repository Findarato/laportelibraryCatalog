#!/iiidb/software/tpp/bin/perl -w
use strict;

# version 380@(#) addjs.pl 380.2@(#) 02/13/12 17:08:12

##########################################################################
# <<addjs.pl>> adds the following javascript preceeding </head>
# for each *.html file in the local directory:
# <script type="text/javascript" src="/screens/iiilangswitch.js"></script>
##########################################################################

# global variables
my $insert_line = 0;
my $search = "^\<\/head\>";
my $addstring = '\<script type=\"text/javascript\" src=\"/screens/iiilangswitch.js\"\>\</script\>';

# log file
my $datetime = scalar(localtime(time));
open LOG, ">addjs.log" or die $!;
print LOG "addjs.pl - $datetime\n";
print LOG "-" x 55 . "\n";

# create a list of all *.html files in the current directory
opendir(DIR, ".");
my @files = grep(/\.html$/,readdir(DIR));
closedir(DIR);

foreach my $filename (@files) # loop thru list
{

  # skip files containing iiilangswitch.js
  my $js_exists = `grep iiilangswitch.js $filename`;
  if ( $js_exists ) {
    next; 
  }

  # skip files not containing </head>
  my $hd_exists = `grep "$search" $filename`;
  if ( ! $hd_exists ) {
    next; 
  }

  open(FH,$filename) or die "$!";
  while (<FH>) {
    if (/$search/) {
      $insert_line = $.;
	  last;
    }
  }
  close(FH);

  print "Updating $filename\n";
  print LOG "Updating $filename\n";
  system("perl -pi -le \'print \"$addstring\" if \$. == \'$insert_line\'\' \'$filename\'");

}

close(LOG);
print "Script completed\n";
