#!/usr/local/bin/perl
#!/usr/bin/perl
################################################################################
##                                                                            ##
## Author     : Monty Scroggins                                               ##
## Description: DB to store code examples etc                                 ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
##  Parameters:                                                               ##
##                                                                            ##
## +++++++++++++++++++++++++++ Maintenance Log ++++++++++++++++++++++++++++++ ##
## Tue Mar 9 17:23:59 CST 1999  Monty Scroggins - Script created.    

use Tk;
use Tk::Dialog;
use Tk::SplitFrame;

#perl variables
$|=1; # set output buffering to off
$[ = 0; # set array base to 1
$, = ' '; # set output field separator
$\ = "\n"; # set output record separator

#The colors
$txtbackground="snow2";
$background="bisque3";
$troughbackground="bisque4";
$buttonbackground="tan";
$txtforeground="black";
$winfont="8x13bold";
$trbgd="bisque4";

#check the arguments
$dbfile="$ARGV[0]";
if (!$dbfile) {
   print "\nNo DB specified.";
   print "\nusage - $0 <dbfile>\n";
   exit;
   }

$dbfile=~s/\.db$//;
if (!-f $dbfile && !-f "$ENV{HOME}\/\.mydb/$dbfile\.db") {
   print "$ENV{HOME}\/\.mydb/$dbfile\.db";
   #dialog box for creating empty db file...
   $confirmwin->destroy if Exists($confirmwin);
      $confirmwin = Tk::MainWindow->new;
      $confirmwin->withdraw;
      local $confirmbox=$confirmwin->messageBox(
         -type=>'OKCancel',
         -bg=>$background,
         -font=>'8x13bold',
         -title=>"Prompt",
         -text=>"The Database file \"$dbfile\" does not exist...\nCreate it??",
         );
   if ($confirmbox eq "Ok") {
      #if the filename has no path, look in the ~/.mydb directory
      if (grep(/\//,$dbfile)<1) {
         $dbfile="$ENV{HOME}\/\.mydb/$dbfile";
         }
      #if the filename has no ".db" extension, add it
      if (grep(/\.db *$/,$dbfile)<1) {
         $dbfile.=".db";
         }
      system("touch $dbfile")
      }else{
         exit;
         }#else
   }#if !-f dbfile


#if the filename has no path, look in the ~/.mydb directory
if (grep(/\//,$dbfile)<1) {
   $dbfile="$ENV{HOME}\/\.mydb/$dbfile";
   }

#if the filename has no ".db" extension, add it
if (grep(/\.db *$/,$dbfile)<1) {
   $dbfile.=".db";
   }

#get the filename for the title
$titlestring=(split("\\.",$dbfile))[0];

$LW = Tk::MainWindow->new;
#$LW->minsize(30,24);
$LW->minsize(90,28);
#$LW->maxsize(86,28);

#set the window title
$LW->configure(
   -title=>"$dbfile",
   -background=>$background,
   -foreground=>$txtforeground,
   -borderwidth=>2,
   -relief=>'raised',
   );

#create two sub frames - one for the text, one for the buttons, and one for help,cancel
#label frame 
$listframe1=$LW->Frame(
   -borderwidth=>'0',
   -relief=>'flat',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -fill=>'x',
      -pady=>0,
      -padx=>0,
      );

#the split frame with the slider between the panes
$mainsplit=$LW->SplitFrame(
   -borderwidth=>'0',
   -relief=>'flat',
   -bg=>'red4',
   -background=>$background,
   -trimcolor=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -orientation=>'horizontal',
   -sliderposition=>280,
   -padbefore=>80,
   -padafter => 105,
   -trimcount=>2,
   -sliderwidth=>7,
   -opaque=>1,
   )->pack(
      -fill=>'both',
      -expand=>'true',
      -pady=>'0',
      -padx=>'0',
      );

#listbox frame
$listframe2top=$mainsplit->Frame(
   -borderwidth=>'0',
   -relief=>'flat',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -fill=>'both',
      -expand=>'true',
      -pady=>'0',
      -padx=>'0',
      );

#listbox frame
$listframe2bot=$mainsplit->Frame(
   -borderwidth=>'0',
   -relief=>'flat',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -expand=>'true',
      -fill=>'both',
      -pady=>'0',
      -padx=>'0',
      );

#buttons frame
$listframe3=$LW->Frame(
   -borderwidth=>1,
   -relief=>'sunken',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0)
   ->pack(
      -fill=>'x',
      -pady=>3,
      -padx=>0,
      );

########################################################
# Create a scrollbar on the right side of the listbox

$scroll=$listframe2top->Scrollbar(
   -orient=>'vert',
   -elementborderwidth=>1,
   -highlightthickness=>0,
   -background=>$background,
   -troughcolor=>$troughbackground,
   -relief=>'flat',)
   ->pack(
       -side=>'right',
       -fill=>'y',
       );

$scroll2=$listframe2top->Scrollbar(
   -orient=>'horiz',
   -elementborderwidth=>1,
   -highlightthickness=>0,
   -background=>$background,
   -troughcolor=>$troughbackground,
   -relief=>'flat',)
   ->pack(
       -side=>'bottom',
       -fill=>'x',
       );
       
$toptext=$listframe2top->Text(
   -yscrollcommand=>['set', $scroll],
   -xscrollcommand=>['set', $scroll2],
   -relief=>'sunken',
   -font=>'8x13bold',
   -highlightthickness=>0,
   -background=>$txtbackground,
   -foreground=>$txtforeground,
   -selectforeground=>$txtforeground,
   -selectbackground=>'#c0d0c0',
   -borderwidth=>1,
   -setgrid=>'yes',
   -wrap=>'none',
   )->pack(
      -fill=>'both',
      -expand=>1,
      );

$scroll->configure(-command=>['yview', $toptext]);
$scroll2->configure(-command=>['xview', $toptext]);

# Create a scrollbar on the right side and bottom of the listbox
$botscroll=$listframe2bot->Scrollbar(
   -orient=>'vert',
   -elementborderwidth=>1,
   -highlightthickness=>0,
   -background=>$background,
   -troughcolor=>$troughbackground,
   -relief=>'flat',
   )->pack(
      -side=>'right',
      -fill=>'y',
      -pady=>0,
      );

$titlelist=$listframe2bot->ROText(
   -yscrollcommand=>['set', $botscroll],
   -relief=>'flat',
   -font=>'8x13bold',
   -highlightthickness=>0,
   -background=>$txtbackground,
   -foreground=>'#a00000',
   -selectforeground=>'#a00000',
   -selectbackground=>$txtbackground,
   -selectborderwidth=>0,
   -borderwidth=>1,
   -height=>6,
   -spacing1=>1,
   -cursor=>'top_left_arrow',
   -insertontime=>0,
   )->pack(
      -fill=>'both',
      -expand=>1,
      -pady=>0,
      );
      
$botscroll->configure(-command=>['yview',$titlelist]);
$titlelist->bind('<Button-1>'=>\&popindex);

########################################################
#bottom row of buttons and labels

#title list frame
$titlelistframe=$listframe3->Frame(
   -borderwidth=>1,
   -relief=>'sunken',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -fill=>'both',
      -pady=>0,
      -padx=>0,
      -expand=>1,
      );
     
$listframe3->Button(
   -text=>'Add Item',
   -borderwidth=>'1',
   -width=>'9',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>\&add_item,
   )->pack(
      -side=>'left',
      -padx=>1,
      -pady=>3,
      );

$listframe3->Button(
   -text=>'Edit Item',
   -borderwidth=>'1',
   -width=>'9',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>\&edit_item,
   )->pack(
      -side=>'left',
      -padx=>1,
      -pady=>3,
      );

$listframe3->Button(
   -text=>'Delete Item',
   -borderwidth=>'1',
   -width=>'9',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>\&delete_it,
   )->pack(
      -side=>'left',
      -padx=>1,
      -pady=>3,
      );
        
$titlelistframe->Label(
   -text=>'Total Items:',
   -borderwidth=>'1',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   )->pack(
      -side=>'left',
      -padx=>4,
      -pady=>3,
      -expand=>0,
      );

$titlelistframe->Label(
   -textvariable=>\$numsnips,
   -borderwidth=>'1',
   -background=>$buttonbackground,
   -foreground=>'black',
   -highlightthickness=>0,
   -font=>$winfont,
   -relief=>'sunken',
   -width=>4,
   )->pack(
      -side=>'left',
      -padx=>4,
      -pady=>3,
      -expand=>0,
      );

$listframe3->Button(
   -text=>'Cancel',
   -borderwidth=>'1',
   -width=>'9',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>sub{exit;},
   )->pack(
      -side=>'right',
      -padx=>1,
      -pady=>3,
      );
      

# print code not written yet
#
# $listframe3->Button(
#    -text=>'Print',
#    -borderwidth=>'1',
#    -width=>'9',
#    -background=>$buttonbackground,
#    -foreground=>$txtforeground,
#    -highlightthickness=>0,
#    -font=>$winfont,
#    -command=>sub{$LW->destroy;},
#    )->pack(
#       -side=>'right',
#       -padx=>1,
#       -pady=>3,
#       );
#       
$listframe3->Button(
   -text=>'Load',
   -borderwidth=>'1',
   -width=>'9',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>\&select_file,
   )->pack(
      -side=>'right',
      -padx=>1,
      -pady=>3,
      );

      
$listframe3->Button(
   -text=>'Search',
   -borderwidth=>'1',
   -width=>'9',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>\&search_list,
   )->pack(
      -side=>'right',
      -padx=>1,
      -pady=>3,
      );
      
&populate;
MainLoop;

########################################################
#Subs
sub populate {
   #read in the db file
   open(dbfile, "<$dbfile") || die "Can't open db file - \"$dbfile\"";
   @dblines=<dbfile>;
   close(dbfile);
   $toptext->delete('0.0','end');
   $titlelist->delete('0.0','end');
   @itemlist="";
   $numsnips=0;
   #load the title list into the bottomlistbox
   foreach (@dblines) {
      if (/^ *\+\>/) {
         chomp;
         $line=$_;
         $line=~s/^ *\+\> *//;
         push(@itemlist,"$line");
         $numsnips++;
         }
      }#foreach
   foreach (sort(@itemlist)) {
      next if (/^ *$/);
      $titlelist->insert('end', "$_\n");
      }
   $mainsplit->update;
}

sub add_mod_dialog {
   $AW = Tk::MainWindow->new;
   #set the window title
   $AW->configure(
      -title=>"Add Database Item",
      -background=>$background,
      -foreground=>$txtforeground,
      -borderwidth=>2,
      -relief=>'raised',
      );

   #create two sub frames - one for the text, one for the buttons
   $addframetop=$AW->Frame(
   -borderwidth=>'0',
   -relief=>'flat',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -fill=>'x',
      -pady=>0,
      -padx=>0,
      );

   $addframebottom=$AW->Frame(
   -borderwidth=>'0',
   -relief=>'flat',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -fill=>'x',
      -pady=>0,
      -padx=>0,
      );

   $addbuttonframe=$AW->Frame(
   -borderwidth=>'0',
   -relief=>'flat',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -fill=>'x',
      -pady=>0,
      -padx=>0,
      -side=>'bottom',
      );

   ########################################################
   # Create a scrollbar on the right side of the listbox

   $addscroll=$addframetop->Scrollbar(
   -orient=>'vert',
   -elementborderwidth=>1,
   -highlightthickness=>0,
   -background=>$background,
   -troughcolor=>$troughbackground,
   -relief=>'flat',)
   ->pack(
      -side=>'right',
      -fill=>'y',
      );

   $addscroll2=$addframetop->Scrollbar(
   -orient=>'horiz',
   -elementborderwidth=>1,
   -highlightthickness=>0,
   -background=>$background,
   -troughcolor=>$troughbackground,
   -relief=>'flat',)
   ->pack(
      -side=>'bottom',
      -fill=>'x',
      );

   $addtext=$addframetop->Text(
   -yscrollcommand=>['set', $addscroll],
   -xscrollcommand=>['set', $addscroll2],
   -relief=>'sunken',
   -font=>'8x13bold',
   -highlightthickness=>0,
   -background=>$txtbackground,
   -foreground=>$txtforeground,
   -selectforeground=>$txtforeground,
   -selectbackground=>'#c0d0c0',
   -borderwidth=>1,
   -setgrid=>'yes',
   -wrap=>'none',
   )->pack(
      -fill=>'both',
      -expand=>1,
      );
   $addscroll->configure(-command=>['yview', $addtext]);
   $addscroll2->configure(-command=>['xview', $addtext]);

   $addframebottom->Label(
   -text=>'Title:',
   -borderwidth=>'1',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   )->pack(
      -side=>'left',
      -padx=>1,
      -pady=>3,
      -expand=>0,
      );

   $addframebottom->Entry(
   -textvariable=>\$entrytitle,
   -borderwidth=>'1',
   -background=>$txtbackground,
   -foreground=>'black',
   -highlightthickness=>0,
   -font=>$winfont,
   -relief=>'sunken',
   )->pack(
      -side=>'left',
      -padx=>1,
      -pady=>3,
      -expand=>1,
      -fill=>'x',
      );

   $addbuttonframe->Button(
   -text=>'Cancel',
   -borderwidth=>'1',
   -width=>'8',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>sub{$AW->destroy;},
   )->pack(
      -side=>'right',
      -padx=>1,
      -pady=>3,
      );

   $addbuttonframe->Button(
   -text=>'Commit',
   -borderwidth=>'1',
   -width=>'8',
   -background=>$buttonbackground,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   -font=>$winfont,
   -command=>sub{&commit_it;},
   )->pack(
      -side=>'right',
      -padx=>1,
      -pady=>3,
      ); 
}#sub add_mod_dialog

sub add_item {
   $entrytitle="";
   &add_mod_dialog;
   $committype="add";
   }

sub edit_item {
   $itemtext=$toptext->get('0.0','end');
   return if ($itemtext=~/^ *$/);
   &add_mod_dialog;
   $addtext->insert('end',"$itemtext");
   #sniptext is derived from the mouse selection of the bottom listbox
   $entrytitlesav=$entrytitle=$sniptext;
   $committype="edit";
   }
   
sub delete_it {
   return if ($sniptext=~/^ *$/);
   $ask=&operconfirm;
   return if ($ask ne "Ok");
   $inproc=0;
   #out with the old
   for($i = 0; $i < ($#dblines); ++$i) {
      if ($dblines[$i]=~/^\ *\+\>\ *$sniptext$/) {
         $inproc=1;
         splice(@dblines,$i,1);
         redo;
         }#  
      #if the line contains the entry delimeter the record has ended
      if ($dblines[$i] =~ /^ *\+\>/) {
         $inproc=0;
         }
      if ($inproc==1) {
         splice(@dblines,$i,1);
         redo;
         }#foreach line proclines
      }#for $i = 0; $i < ($#dblines); ++$i)
   #save the db file
   &write_file;
   &populate;
}

sub commit_it {
   $committext=$addtext->get('0.0','end');
   return if ($committext=~/^ *$/|| $entrytitle=~/^ *$/);
   $AW->destroy;
   #if the commit type is add just push the new text into the list
   if ($committype eq "add") {
      push(@dblines,"\+\>$entrytitle");
      @committext=split("\n",$committext);
      foreach (@committext) {
         chomp;
         push(@dblines,"$_");
         }#foreach
      push(@dblines,"\n");
      }else{
         #if the commit type is not add, delete the active entry, and push the new text
         #onto the list
         $inproc=0;
         #out with the old
         for($i = 0; $i < ($#dblines); ++$i) {
            if ($dblines[$i]=~/^\ *\+\>\ *$sniptext$/) {
               $inproc=1;
               splice(@dblines,$i,1);
               redo;
               }#  
            #if the line contains the entry delimeter the record has ended
            if ($dblines[$i] =~ /^ *\+\>/) {
               $inproc=0;
               }
            if ($inproc==1) {
               splice(@dblines,$i,1);
               redo;
               }#foreach line proclines
            }#for $i = 0; $i < ($#dblines); ++$i)
         #in with the new   
         push(@dblines,"\+\>$entrytitle");
         @committext=split("\n",$committext);
         foreach (@committext) {
            chomp;
            push(@dblines,"$_");
            }
         push(@dblines,"\n");
         $toptext->delete('0.0','end');
         }#else
   #save the db file
   &write_file;
   #display the file results
   &populate;   
}#sub commit_it

sub select_file {
    @types =
      (["Log files",           ['.db']],
       ["All files",    '*']
      );
   $dbtestfile=$LW->getOpenFile(-filetypes => \@types);
   if ($dbtestfile) {
      $dbfile=$dbtestfile;
      &populate;  
      }
}#sub select file

sub write_file {
   open(dbfile, ">$dbfile") || die "Can't open proc file - $dbfile";
   foreach (@dblines) {
      chomp;
      print dbfile "$_";
      }
   close(dbfile);
}
#pop the double clicked process info of of the kill array and listbox
sub popindex {
   $titlelist->tagDelete('new_tag');
   chomp @dblines;
   #get the line number where u have clicked  by doing .
   #$linenumber=$titlelist->index('current')  =~ /(\d*)\.\d*/;
   $linenumber=$titlelist->index('current');
   #remove the trailing ".xx" for the line number
   $linenumber=~s/\.\d+//;
   #highlight the entire line even if there is no text all the way to the end
   $titlelist->tagAdd('new_tag', "$linenumber.0","$linenumber.0+1 line");
   $titlelist->tagConfigure('new_tag',
      -foreground=>'#002040',
      -relief=>'raised',
      -borderwidth=>1,
      -background=>'#d1efb4',
      );
   $sniptext=$titlelist->get("$linenumber.0","$linenumber.end");
   $sniptext=~s/^ *//;
   $inproc=0;
   for($i = 0; $i < ($#dblines); ++$i) {
      if ($dblines[$i]=~/^\ *\+\>\ *\Q$sniptext\E$/) {
         $toptext->delete('0.0','end');
         $inproc=1;
         next;
         }# if the line contains the USE statement  
      #if the line contains a delimeter out of item
      if ($dblines[$i] =~ /^ *\+\>/) {
         $inproc=0;
         }
      if ($inproc==1) {
         $toptext->insert('end',"$dblines[$i]\n");
         }#if inproc
      }#for $i = 0; $i < ($#dblines); ++$i) 
}#sub

#sort rules used in the alpha sort command
#$a and $b are the internal variables used for the cmp or diff command.
#must handle numeric values differently than alpha values..
sub sort_criteria {
   $num_a=$a=~/^[0-9]/;
   $num_b=$b=~/^[0-9]/;
   if ($num_a && $num_b) {
      $retval = $a<=>$b;
      }elsif ($num_a) {
         $retval=1;
         }elsif ($num_b) {
            $retval=-1;
            }else{
               $retval = $a cmp $b;
               }
   $retval; 
}

#query results search dialog
sub search_list {
   $srchstring="";
   $SW->destroy if Exists($SW);
   $SW=new MainWindow(-title=>'DBGUI search');
   #width,height in pixels    
   $SW->minsize(424,51);
   $SW->maxsize(724,51);
   #default to non case sensitive
   $caseflag="nocase";
   $newsearch=1;
   #The top frame for the text
   $searchframe1=$SW->Frame(
      -borderwidth=>'0',
      -relief=>'flat',
      -background=>$background,
      )->pack(
         -expand=>1,
         -fill=>'both',
         );

   $searchframe2=$SW->Frame(
      -borderwidth=>'0',
      -relief=>'flat',
      -background=>$background,
      )->pack(
         -fill=>'x',
         -pady=>2,
         );

   $searchframe1->Checkbutton(
      -variable=>\$caseflag,
      -font=>$winfont,
      -relief=>'flat',
      -text=>"Case",
      -highlightthickness=>0,
      -highlightcolor=>'black',
      -activebackground=>$background,
      -bg=>$background,
      -foreground=>$txtforeground,
      -borderwidth=>'1',
      -width=>6,
      -offvalue=>"nocase",
      -onvalue=>"case",
      -command=>sub{$current='0.0',$searchcount=0;$newsearch=1},
      -background=>$background,
      )->pack(
         -side=>'left',
         -expand=>0,
         );
         
   $searchhistframe=$searchframe1->Frame(
   -borderwidth=>1,
   -relief=>'sunken',
   -background=>$background,
   -foreground=>$txtforeground,
   -highlightthickness=>0,
   )->pack(
      -side=>'bottom',
      -expand=>0,
      -pady=>0,
      -padx=>1,
      -fill=>'x', 
      );
      
   $ssentry=$searchhistframe->HistEntry(
      -font=>$winfont,
      -relief=>'sunken',
      -textvariable=>\$srchstring,
      -highlightthickness=>0,
      -highlightcolor=>'black',
      -selectforeground=>$txtforeground,
      -selectbackground=>'#c0d0c0',
      -bg=>$background,
      -foreground=>$txtforeground,
      -borderwidth=>0,
      -bg=> 'white',
      -limit=>$histlimit,
      -dup=>0,
      -match => 1,  
      -justify=>'left',
      -command=>sub{@searchhisttemp=$ssentry->history;},
      )->pack(
         -fill=>'both',
         -expand=>0,
         );

   #press enter and perform a single fine
   $ssentry->bind('<KeyPress-Return>'=>sub{&find_one;});
   $ssentry->bind('<Up>'        => sub { $ssentry->historyUp });
   $ssentry->bind('<Control-p>' => sub { $ssentry->historyUp });
   $ssentry->bind('<Down>'      => sub { $ssentry->historyDown });
   $ssentry->bind('<Control-n>' => sub { $ssentry->historyDown });
   $ssentry->history([@searchhist]);
   $ssentry->invoke;

   $searchframe2->Button(
      -text=>'Find',
      -borderwidth=>'1',
      -width=>'10',
      -background=>$buttonbackground,
      -foreground=>$txtforeground,
      -highlightthickness=>0,
      -font=>$winfont,
      -command=>sub {&find_one;},
      )->pack(
         -side=>'left',
         -padx=>2,
         );

   $searchframe2->Button(
      -text=>'Find All',
      -borderwidth=>'1',
      -width=>'10',
      -background=>$buttonbackground,
      -foreground=>$txtforeground,
      -highlightthickness=>0,
      -font=>$winfont,
      -command=>sub {&find_all;},
      )->pack(
         -side=>'left',
         -padx=>2,
         );

   $searchframe2->Button(
      -text=>'Cancel',
      -borderwidth=>'1',
      -width=>'10',
      -background=>$buttonbackground,
      -foreground=>$txtforeground,
      -highlightthickness=>0,
      -font=>$winfont,
      -command=>sub{$SW->destroy;$titlelist->tag('remove','search', qw/0.0 end/);}
      )->pack(
         -side=>'right',
         -padx=>2,
         );
   $ssentry->focus;      
} # sub search


# search the Logfile for a term and return a highlighted line
# containing the term.
sub find_all {
   return if ($srchstring eq "");
   $ssentry->invoke;
   #delete any old tags so new ones will show
   $titlelist->tag('remove','search', qw/0.0 end/);
   $current='0.0';
   $stringlength=length($srchstring);
   $searchcount=0;
   while (1) {
      if ($caseflag eq "case") {  
         $current=$titlelist->search(-exact,$srchstring,$current,'end');
         }else{
            $current=$titlelist->search(-nocase,$srchstring,$current,'end');
            }#else  
      last if (!$current);
      $titlelist->tag('add','search',$current,"$current + $stringlength char");
      $titlelist->tag('configure','search',
         -background=>'chartreuse',
         -foreground=>'black',
         );
      $searchcount++;       
      $current=$titlelist->index("$current + 1 char");
      }#while true
   $SW->configure(-title=>"$searchcount Matches");
   $searchcount=0;
   $current='0.0';
}#sub find all

#find and highlight one instance of a string at a time
sub find_one {
   return if ($srchstring eq "");
   $ssentry->invoke;
   $titlelist->tag('remove','search', qw/0.0 end/);
   #mull through the text tagging the matched strings along the way
   if ($srchstring ne $srchstringold || $newsearch==1) {
      $allcount=0;
      $tempcurrent='0.0';
      $srchstringold=$srchstring;
      while (1) {
         if ($caseflag eq "case") {  
            $tempcurrent=$titlelist->search(-exact,$srchstring,$tempcurrent,'end');
            }else{
               $tempcurrent=$titlelist->search(-nocase,$srchstring,$tempcurrent,'end');
               }#else  
         last if (!$tempcurrent);
         $allcount++;       
         $tempcurrent=$titlelist->index("$tempcurrent + 1 char");
         $searchcount=0;
         $current='0.0';
         }#while true
     $newsearch=0; 
    }#if srchstring ne srstringold
   #set the titlebar of the search dialog to indicate the matches
   $SW->configure(-title=>"$allcount Matches");  
   $stringlength=length($srchstring);
   if (!$current) {
      $current='0.0';
      $searchcount=0;
      } # if current
   local $currentold=$current;   
   if ($caseflag eq "case") {  
      $current=$titlelist->search(-exact,$srchstring,"$current +1 char");
      }else{
         $current=$titlelist->search(-nocase,$srchstring,"$current +1 char");
         }#else
   #no matches were found - set the titlebar
   if ($current eq "") {
      $SW->configure(-title=>"No Matches");
      return;
      }      
   $current=$titlelist->index($current);
   $titlelist->tag('add','search',$current,"$current + $stringlength char");
   $titlelist->tag('configure','search',
      -background=>'chartreuse',
      -foreground=>'black',
      );         
   $titlelist->see($current);
} #sub find one

sub operconfirm {
   local $ask=$LW->messageBox(
      -icon=>'warning', 
      -type=>'OKCancel',
      -bg=>$background,
      -title=>'Action Confirm',
      -text=>"Please confirm the action before\nit is executed..",
      -font=>'8x13bold',
      );
   return $ask;
}#sub operconfirm

#return a positive status 
1;
