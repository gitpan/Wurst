# src Makefile
use ExtUtils::MakeMaker;

my $cflags = "$common::defines -DRETSIGTYPE=$Config{signal_t} -DGPLT_X11_MODE";

# on MSWin32 these functions are wrappers available in Perl CORE only
if (defined $Config{d_dup2} and defined $Config{d_pipe} and $^O ne 'MSWin32') {
  $cflags .= ' -DPIPES -DX11 -DX11_DRIVER_DIR=\".\"';
  $cflags .= " -DEXENAME_X11=$common::x_exe -DEXENAME_PM=$common::pm_exe -DCANT_ACCEPT_COMMANDS -DX11_FORCED_PATH";
}

$cflags .= ' -DMY_Windows' if $^O eq 'MSWin32';

$cflags .= $common::cflags;

$try_libs = $common::try_libs;

my $Using_ms_vc = ($^O =~ /win32/i and $Config{cc} =~ /cl/i);
my $Using_Borland = ($^O =~ /win32/i and $Config{cc} =~ /\bbcc/i);


WriteMakefile(
      'OPTIMIZE'      => $OPTIMIZE,
      'NAME'          => 'Wurst',
      'VERSION_FROM'  => '../lib/Wurst.pm',     # finds $VERSION
      'DEFINE'        => $cflags,
      'MYEXTLIB'      => 'wurstsrc/libwurst$(LIB_EXT) wurstsrc/gsldir/libminigsl$(LIB_EXT)',
      'INC'           => '-Iwurstsrc -Iwurstsrc/gsldir',
      'INSTALLMAN3DIR'=> $man_dest,
      'clean'         => { 'FILES' => '*~'},
);

sub MY::postamble {
'
wurstsrc/gsldir/libminigsl$(LIB_EXT): wurstsrc/gsldir/Makefile
	@echo
	@echo "Starting to make wurstsrc/gsldir/libminigsl$(LIB_EXT)"
	cd wurstsrc/gsldir && $(MAKE) $(PASSTHRU)
	@echo "Finished making wurstsrc/gsldir/libminigsl$(LIB_EXT)"
	@echo

wurstsrc/libwurst$(LIB_EXT): wurstsrc/Makefile
	@echo
	@echo "Starting to make wurstsrc/libwurst$(LIB_EXT)"
	cd wurstsrc && $(MAKE) $(PASSTHRU)
	@echo "Finished making wurstsrc/libwurst$(LIB_EXT)"
	@echo
';
}

sub MY::test {
'
test:
	$(NOECHO) $(NOOP)
';
}
