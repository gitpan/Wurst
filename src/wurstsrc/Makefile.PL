#Builds an archive (static library) containing Wurst symbols
use ExtUtils::MakeMaker;
use Config;

WriteMakefile(
    'NAME'	=> 'LibWurst',
    'LINKTYPE'	=> 'static',
    'OBJECT'	=> 'align$(OBJ_EXT) altscores$(OBJ_EXT) amino_a$(OBJ_EXT) binver$(OBJ_EXT) cmp_dmat$(OBJ_EXT) common$(OBJ_EXT) classifyStructure$(OBJ_EXT) class_model$(OBJ_EXT) lsqf$(OBJ_EXT) multialign$(OBJ_EXT) coord$(OBJ_EXT) coordinfo$(OBJ_EXT) dbg$(OBJ_EXT) dihedral$(OBJ_EXT) e_malloc$(OBJ_EXT) fio$(OBJ_EXT) geo_gap$(OBJ_EXT) matrix$(OBJ_EXT) mgc_num$(OBJ_EXT) misc$(OBJ_EXT) model$(OBJ_EXT) mprintf$(OBJ_EXT) pair_set$(OBJ_EXT) pair_set_p$(OBJ_EXT) param_fx$(OBJ_EXT) pair_set_chim$(OBJ_EXT) pdbin$(OBJ_EXT) pdbout$(OBJ_EXT) prob_vec$(OBJ_EXT) read_ac_strct$(OBJ_EXT) read_ac$(OBJ_EXT) read_blst$(OBJ_EXT) read_mat$(OBJ_EXT) read_sec$(OBJ_EXT) read_seq$(OBJ_EXT) rescore$(OBJ_EXT) scor_set$(OBJ_EXT) score_fx$(OBJ_EXT) score_mat$(OBJ_EXT) score_probvec$(OBJ_EXT) score_sec$(OBJ_EXT) score_smat$(OBJ_EXT) scratch$(OBJ_EXT) sec_s$(OBJ_EXT) silly$(OBJ_EXT) str$(OBJ_EXT) vec$(OBJ_EXT) solv_data$(OBJ_EXT)',
#   'INC'	=> '-I..',
    'clean'	=> {'FILES' => 'libwurst$(LIB_EXT) *~'},
    macro	=> {
		    ADD_AR_OPT	  => ($add_ar_flags || ''),
		    MY_CC_PRE_TARGET => ($Using_ms_vc
					 ? '-Fo'
					 : ($Using_Borland
					    ? '-o': '-o $(MY_EMPTY_STR)')),
		    MY_AR_PRE_TARGET => ($Using_ms_vc
					 ? '-out:'
					 : ($Using_Borland
					    ? '' : 'cr $(MY_EMPTY_STR)')),
		    MY_AR_OBJECT => ($Using_Borland
				     ? '$(OBJECT:^"+")'
				      : '$(OBJECT)'),
		    MY_EMPTY_STR  => '',
		   },
);

sub MY::top_targets {
'
all :: libwurst$(LIB_EXT)

static ::       libwurst$(LIB_EXT)

libwurst$(LIB_EXT): $(OBJECT) gsldir/Makefile
	-$(RM_F) libwurst$(LIB_EXT)
	$(AR) $(ADD_AR_OPT) $(MY_AR_PRE_TARGET)libwurst$(LIB_EXT) $(MY_AR_OBJECT)
	$(RANLIB) libwurst$(LIB_EXT)

';
}
