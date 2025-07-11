unit FDBSQL;

interface

uses
  Windows, SysUtils, Classes, ADODB, Grobal2, MfdbDef, HUtil32, EDCode;

type
  TSQLHumanInfo = record
    ChrName: string[20]; //key
    UserId: string[20];
    Delete: Boolean;
    DeleteDate: TDateTime;
    Mark: byte;
    Selected: Boolean;
    Demmy: array[0..2] of byte;
  end;

  FSQLHumRcd = record
    Deleted: Boolean; {delete mark}
    UpdateDateTime: TDouble;
    Key: string[20];
    Block: TSQLHumanInfo;
  end;
  PFSQLHumRcd = ^FSQLHumRcd;

   //用户ID结构
  FUserInfo = record      //货肺 函版 登绰 荤侩磊 沥焊 饭内靛
    UInfo: TUserEntryInfo;
    UAdd: TUserEntryAddInfo;
  end;

  FSQLIdRcd = record        //货肺 函版等 拌沥 饭农档
    Deleted: Boolean; {delete mark}
    MakeRcdDateTime: TDateTime;  //拌沥捞 父甸绢柳 矫埃
    UpdateDateTime: TDateTime; //TDouble;
    UserInfo: FUserInfo;
  end;
  PFSQLIdRcd = ^FSQLIdRcd;

  //数据库字段格式 --------------------------------------------------------
  TMIRDB_FIELDS = record
    szFieldName: string[30];
    btType: Byte;
    fIsKey: Boolean;
    nSize: Integer;
  end;
  PTMIRDB_FIELDS = ^TMIRDB_FIELDS;

  //动态数组指针类型
  TMirDBFields = array of TMIRDB_FIELDS;

  //数据表格式
  TMIRDB_TABLE = record
    szTableName: string[30];
    nNumOfFields: Integer;
    lpFields: Pointer;
  end;
  PTMIRDB_TABLE = ^TMIRDB_TABLE;

  TDBType = (tMaster, tGame, tAccount);
const
  SQLTYPE_SELECT			    = 1;
  SQLTYPE_SELECTWHERE	    = 2;
  SQLTYPE_UPDATE			    = 3;
  SQLTYPE_INSERT		      = 4;
  SQLTYPE_DELETE		      = 5;
  SQLTYPE_SELECTWHERENOT  = 6;
  SQLTYPE_DELETENOT	    	= 7;

  TABLETYPE_STR		      	= 1;
  TABLETYPE_INT		      	= 2;
  TABLETYPE_DAT		      	= 3;
  TABLETYPE_DBL		      	= 4;

  ATOM_FIRE			        	= 0;
  ATOM_ICE			        	= 1;
  ATOM_LIGHT		        	= 2;
  ATOM_WIND		        		= 3;
  ATOM_HOLY		        		= 4;
  ATOM_DARK		        		= 5;
  ATOM_PHANTOM	        	= 6;

  U_BAG				            =	77;
  U_SAVE			            =	88;

  __CHAR_INFOFIELDS: array[0..4] of TMIRDB_FIELDS = (
                    ( szFieldName: 'FLD_LOGINID';     btType: TABLETYPE_STR;  fIsKey: TRUE;   nSize: 20 ),
                    ( szFieldName: 'FLD_CHARACTER';   btType: TABLETYPE_STR;  fIsKey: TRUE; 	nSize: 20 ), // 14 -> 20
                    ( szFieldName: 'FLD_SERVERNAME';	btType: TABLETYPE_STR;  fIsKey: FALSE;	nSize: 9 ),
                    ( szFieldName: 'FLD_JOB';			    btType: TABLETYPE_INT;  fIsKey: FALSE;	nSize: 4 ),
                    ( szFieldName: 'FLD_SEX';			    btType: TABLETYPE_INT;  fIsKey: FALSE;	nSize: 4 )
                  );

  __ABILITYFIELDS: array[0..32] of TMIRDB_FIELDS = (
                		( szFieldName: 'FLD_CHARACTER';	    	btType: TABLETYPE_STR; fIsKey: TRUE;	nSize: 20 ), // 14 -> 20
										( szFieldName: 'FLD_LEVEL';		       	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
//										( szFieldName: 'FLD_RESERVED1';	  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_AC';	  		    	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAC';	  	      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_DC';		 	      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MC';			      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_SC';			      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_HP';			      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MP';			      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAXHP';		      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAXMP';		      	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_EXP';		        	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAXEXP';		    	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_WEIGHT';	    		btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAXWEIGHT';	    	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_WEARWEIGHT';	  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAXWEARWEIGHT'; 	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_HANDWEIGHT';	  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_MAXHANDWEIGHT'; 	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMFIRE_MC';   	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMICE_MC';  		btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMLIGHT_MC';  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMWIND_MC';   	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMHOLY_MC';   	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMDARK_MC';   	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMPHANTOM_MC';	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMFIRE_MAC';  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMICE_MAC';   	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMLIGHT_MAC'; 	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMWIND_MAC';  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMHOLY_MAC';  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMDARK_MAC';  	btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 ),
										( szFieldName: 'FLD_ATOMPHANTOM_MAC'; btType: TABLETYPE_INT; fIsKey: FALSE;	nSize: 4 )
								);

  __BONUSABILITYFIELDS: array[0..10] of TMIRDB_FIELDS	= (
                      ( szFieldName: 'FLD_CHARACTER';		btType: TABLETYPE_STR; fIsKey: TRUE; nSize: 0 ),
											( szFieldName: 'FLD_DC';			  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_MC';		  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_SC';		  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_AC';		  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_MAC';		     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_HP';			  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_MP';		  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_HIT';		    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_SPEED';		  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_RESERVED';		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 )
										);

  __CHARACTERFIELDS: array[0..44] of TMIRDB_FIELDS  = (
                      ( szFieldName: 'FLD_CHARACTER';				btType: TABLETYPE_STR; fIsKey: TRUE; nSize: 20 ),	// 14 -> 20
											( szFieldName: 'FLD_USERID';					btType: TABLETYPE_STR; fIsKey: TRUE; nSize: 20 ),
											( szFieldName: 'FLD_DELETED';			  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_UPDATEDATETIME'; 	btType: TABLETYPE_DAT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_DBVERSION';				btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_MAPNAME';			  	btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 20 ),
											( szFieldName: 'FLD_CX';				    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_CY';				  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_DIR';			    		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HAIR';			  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HAIRCOLORR';	 		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HAIRCOLORG';			btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HAIRCOLORB';			btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_SEX';				    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_JOB';			    		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_LEVEL';			  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HP';				  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_MP';				  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_EXP';				    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_GOLD';			  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
                      ( szFieldName: 'FLD_POTCASH';			  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
                      ( szFieldName: 'FLD_GAMEPOINT';			  btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HOMEMAP';		  		btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 20 ),
											( szFieldName: 'FLD_HOMEX';			  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HOMEY';			  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_PKPOINT';		  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_ALLOWPARTY';		 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_FREEGULITYCOUNT';	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_ATTACKMODE';		 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_FIGHTZONEDIE';	 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_BODYLUCK';				btType: TABLETYPE_DBL; fIsKey: FALSE;	nSize: 8 ),
											( szFieldName: 'FLD_INCHEALTH';				btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_INCSPELL';				btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_INCHEALING';		 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_BONUSAPPLY';		 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_BONUSPOINT';		 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_HUNGRYSTATE';			btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),	// Horse Ride
											( szFieldName: 'FLD_TESTSERVERRESETCOUNT';	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_CGHUSETIME';		 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_ENABLEGRECALL';	 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
											( szFieldName: 'FLD_BYTES_1';			  	btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 3 ),
											( szFieldName: 'FLD_HORSERACE';				btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
//											( szFieldName: 'FLD_STATE_DECHEALTH';	  	btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_DATAGEARMOR';		btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_LOCKSPELL';	  	btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_DONTMOVE';			btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_STONE';		    	btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_TRANSPARENT';		btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_DEFFENCEUP';		btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_MAGDEFENCEUP';		btType: TABLETYPE_INT; fIsKey: false },
//											( szFieldName: 'FLD_STATE_BUBBLEDEFENCEUP';	btType: TABLETYPE_INT; fIsKey: false },
											( szFieldName: 'FLD_FAMECUR';	        btType: TABLETYPE_INT; fIsKey: false; nSize: 4 ),	//疙己摹
											( szFieldName: 'FLD_FAMEBASE';	 	    btType: TABLETYPE_INT; fIsKey: false; nSize: 4 ),	//疙己摹
                      ( szFieldName: 'FLD_SECONDS';			   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 )
										);

  __CURRENTABILITYFIELDS: array[0..10] of TMIRDB_FIELDS  = (
                      ( szFieldName: 'FLD_CHARACTER';	btType: TABLETYPE_STR; fIsKey: TRUE;  nSize: 0 ),
											( szFieldName: 'FLD_DC';		  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_MC';	  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_SC';		  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_AC';		  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_MAC';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_HP';	  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_MP';	  		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_HIT';	     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_SPEED';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
											( szFieldName: 'FLD_RESERVED';	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 )
										);

  __ITEMFIELDS: array[0..24] of TMIRDB_FIELDS  = (
                ( szFieldName: 'FLD_CHARACTER';   btType: TABLETYPE_STR; fIsKey: TRUE;	nSize: 20 ), // 14 -> 20
								( szFieldName: 'FLD_TYPE';	    	btType: TABLETYPE_INT; fIsKey: TRUE;  nSize: 4 ),
								( szFieldName: 'FLD_POS';	      	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ), // 眠啊
								( szFieldName: 'FLD_MAKEINDEX'; 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_INDEX';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DURA';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DURAMAX';   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC0';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC1';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC2';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC3';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC4';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC5';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC6';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC7';	     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC8';	     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC9';	     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC10';	   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC11';	   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC12';	   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_DESC13';	   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_COLORR';     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_COLORG';    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_COLORB';	   	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
								( szFieldName: 'FLD_NAMEPREFIX'; 	btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 13 )
							);

  __MAGICFIELDS: array[0..5] of TMIRDB_FIELDS  = (
                  ( szFieldName: 'FLD_CHARACTER';	btType: TABLETYPE_STR; fIsKey: TRUE;	nSize: 20 ), // 14 -> 20
									( szFieldName: 'FLD_MAGICID'; 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
									( szFieldName: 'FLD_POS';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ), // 眠啊,
									( szFieldName: 'FLD_LEVEL';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
									( szFieldName: 'FLD_KEY';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
									( szFieldName: 'FLD_CURTRAIN';	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 )
								);

  __QUESTFIELDS: array[0..3] of TMIRDB_FIELDS  = (
                  ( szFieldName: 'FLD_CHARACTER';	      btType: TABLETYPE_STR; fIsKey: TRUE;	nSize: 20 ), // 14-> 20
									( szFieldName: 'FLD_QUESTOPENINDEX';	btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 64 ),
									( szFieldName: 'FLD_QUESTFININDEX'; 	btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 64 ),
									( szFieldName: 'FLD_QUEST';         	btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 256 )
								);

  __SAVEDITEMFIELDS: array[0..23] of TMIRDB_FIELDS  = (
                    ( szFieldName: 'FLD_CHARACTER'; 	btType: TABLETYPE_STR; fIsKey: TRUE;	nSize: 20 ), // 14 -> 20
										( szFieldName: 'FLD_MAKEINDEX'; 	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_INDEX'; 	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DURA';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DURAMAX';    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC0';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC1';	     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC2';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC3';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC4';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC5';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC6';	     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC7';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC8';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC9';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC10';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC11';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC12';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_DESC13';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_TYPE';	    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_COLORR';    	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_COLORG';     	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_COLORB';	  	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 4 ),
										( szFieldName: 'FLD_NAMEPREFIX';  btType: TABLETYPE_STR; fIsKey: FALSE;	nSize: 13 )
								);

  __SKILLFIELDS: array[0..3] of TMIRDB_FIELDS  = (
                  ( szFieldName: 'FLD_CHARACTER';		btType: TABLETYPE_STR; fIsKey: TRUE;  nSize: 0 ),
									( szFieldName: 'FLD_SKILLINDEX';	btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
									( szFieldName: 'FLD_RESERVED';		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 ),
									( szFieldName: 'FLD_CURTRAIN';		btType: TABLETYPE_INT; fIsKey: FALSE; nSize: 0 )
								);


  __CHAR_INFOTABLE: TMIRDB_TABLE = (
                      szTableName  : 'TBL_CHAR_INFO';
                      nNumOfFields : sizeof(__CHAR_INFOFIELDS) div sizeof(TMIRDB_FIELDS);
                      lpFields     : @__CHAR_INFOFIELDS
                      );
  __ABILITYTABLE:   TMIRDB_TABLE = (
                      szTableName: 'TBL_ABILITY';
                      nNumOfFields: sizeof(__ABILITYFIELDS) div sizeof(TMIRDB_FIELDS);
                      lpFields: @__ABILITYFIELDS
                      );
  __BONUSABILITYTABLE: TMIRDB_TABLE = (
                      szTableName: 'TBL_BONUSABILITY';
                      nNumOfFields: sizeof(__BONUSABILITYFIELDS) div sizeof(TMIRDB_FIELDS);
                      lpFields: @__BONUSABILITYFIELDS
                      );
  __CHARACTERTABLE: TMIRDB_TABLE = (
                      szTableName: 'TBL_CHARACTER';
                      nNumOfFields: sizeof(__CHARACTERFIELDS) div sizeof(TMIRDB_FIELDS);
                      lpFields: @__CHARACTERFIELDS
                      );
  __CURRENTABILITYTABLE: TMIRDB_TABLE = (
                      szTableName: 'TBL_CURRENTABILITY';
                      nNumOfFields: sizeof(__CURRENTABILITYFIELDS) div sizeof(TMIRDB_FIELDS);
                      lpFields: @__CURRENTABILITYFIELDS
                      );
  __ITEMTABLE:      TMIRDB_TABLE = ( szTableName: 'TBL_ITEM';	    	nNumOfFields: sizeof(__ITEMFIELDS) div sizeof(TMIRDB_FIELDS);				lpFields: @__ITEMFIELDS );
  __MAGICTABLE:     TMIRDB_TABLE = ( szTableName: 'TBL_MAGIC';	  	nNumOfFields: sizeof(__MAGICFIELDS) div sizeof(TMIRDB_FIELDS);			lpFields: @__MAGICFIELDS );
  __QUESTTABLE:     TMIRDB_TABLE = ( szTableName: 'TBL_QUEST';	   	nNumOfFields: sizeof(__QUESTFIELDS) div sizeof(TMIRDB_FIELDS);			lpFields: @__QUESTFIELDS );
  __SAVEDITEMTABLE: TMIRDB_TABLE = ( szTableName: 'TBL_SAVEDITEM';  nNumOfFields: sizeof(__SAVEDITEMFIELDS) div sizeof(TMIRDB_FIELDS);	lpFields: @__SAVEDITEMFIELDS );
  __SKILLTABLE:     TMIRDB_TABLE = ( szTableName: 'TBL_SKILL';		 	nNumOfFields: sizeof(__SKILLFIELDS) div sizeof(TMIRDB_FIELDS);			lpFields: @__SKILLFIELDS );


type
  //人物信息字段结构
  TCHARINFO = packed record
    fld_userid: array[0..19] of AnsiChar;
    fld_character: array[0..19] of AnsiChar; // 14 -> 20
    fld_servername: array[0..8] of AnsiChar;
    fld_job: integer;
    fld_sex: integer;
  end;
  PTCHARINFO = ^TCHARINFO;

  //人物属性字段结构
  TAbilityFields = packed record
    fld_character: array[0..19] of AnsiChar;  // 14 -> 20
    fld_level: integer;
//	   fld_reserved1;
    fld_ac: integer;
    fld_mac: integer;
    fld_dc: integer;
    fld_mc: integer;
    fld_sc: integer;
    fld_hp: integer;
    fld_mp: integer;
    fld_maxhp: integer;
    fld_maxmp: integer;
    fld_exp: integer;
    fld_maxexp: integer;
    fld_weight: integer;
    fld_maxweight: integer;
    fld_wearweight: integer;
    fld_maxwearweight: integer;
    fld_handweight: integer;
    fld_maxhandweight: integer;
    fld_atomfire_mc: integer;
    fld_atomice_mc: integer;
    fld_atomlight_mc: integer;
    fld_atomwind_mc: integer;
    fld_atomholy_mc: integer;
    fld_atomdark_mc: integer;
    fld_atomphantom_mc: integer;
    fld_atomfire_mac: integer;
    fld_atomice_mac: integer;
    fld_atomlight_mac: integer;
    fld_atomwind_mac: integer;
    fld_atomholy_mac: integer;
    fld_atomdark_mac: integer;
    fld_atomphantom_mac: integer;
  end;
  PTAbilityFields = ^TAbilityFields;

  //人物字段结构
  TCharacterFields = packed record
    fld_character: array[0..19] of AnsiChar; // 14 -> 20
    fld_userid: array[0..19] of AnsiChar;
    fld_deleted: integer;
    fld_dbversion: integer;
    fld_mapname: array[0..19] of AnsiChar;
    fld_cx: integer;
    fld_cy: integer;
    fld_dir: integer;
    fld_hair: integer;
    fld_haircolorr: integer;
    fld_haircolorg: integer;
    fld_haircolorb: integer;
    fld_sex: integer;
    fld_job: integer;
    fld_level: integer;
    fld_hp: integer;		// To PDS
    fld_mp: integer;		// To PDS
    fld_exp: integer;	// To PDS
    fld_gold: integer;
    fld_potcash: integer;
    fld_GamePoint: integer;
    fld_homemap: array[0..19] of AnsiChar;
    fld_homex: integer;
    fld_homey: integer;
    fld_pkpoint: integer;
    fld_allowparty: integer;
    fld_fregulitycount: integer;
    fld_attackmode: integer;
    fld_fightzonedie: integer;
    fld_bodyluck: TDouble;
    fld_inchealth: integer;
    fld_incspell: integer;
    fld_inchealing: integer;
    fld_bonusapply: integer;
    fld_bonuspoint: integer;
    fld_hungrystate: integer;
    fld_testserverresetcount: integer;
    fld_cghusetime: integer;
    fld_enablegrecall: integer;
    fld_bytes_1: array[0..2] of AnsiChar;
    fld_horserace: integer;
//	   fld_state_dechealth: integer;
//	   fld_state_datagearmor: integer;
//	   fld_state_lockspell: integer;
//	   fld_state_dontmove: integer;
//	   fld_state_stone: integer;
//	   fld_state_transparent: integer;
//	   fld_state_deffenceup: integer;
//	   fld_state_magdefenceup: integer;
//	   fld_state_bubbledefenceup: integer;
    fld_famecur: integer; //疙己摹
    fld_famebase: integer; //疙己摹
    fld_seconds: Integer;
  end;
  PTCharacterFields = ^TCharacterFields;

  //物品字段结构
  TITEMFIELDS = packed record
    fld_character: array[0..19] of AnsiChar; // 14 -> 20
    fld_type: integer;
    fld_pos: integer;		// 眠啊 冠措己
    fld_makeindex: integer;
    fld_index: integer;
    fld_dura: integer;
    fld_duramax: integer;
    fld_desc: array[0..13] of Integer;
    fld_colorr: integer;
    fld_colorg: integer;
    fld_colorb: integer;
    Prefix: array[0..12] of AnsiChar;
  end;
  PTITEMFIELDS = ^TITEMFIELDS;

  //魔法字段结构
  TMagicFields = packed record
    fld_character: array[0..19] of AnsiChar; // 14 -> 20
    fld_magicid: integer;
    fld_pos: integer;			// 眠啊 冠措己
    fld_level: integer;
    fld_key: integer;
    fld_curtrain: integer;
  end;
  PTMagicFields = ^TMagicFields;

  //任务字段结构
  TQUESTFIELDS = packed record
    fld_character: array[0..19] of AnsiChar;	// 14 -> 20
    fld_questopenindex: array[0..63] of AnsiChar;
    fld_questfinindex: array[0..63] of AnsiChar;
    fld_quest: array[0..255] of AnsiChar;
  end;
  PTQUESTFIELDS = ^TQUESTFIELDS;

  //SQL处理类-------------------------------------------------
  TFDBSql  = class ( TObject )
  private
    FADOConnection: TADOConnection;
    FADOQuery: TADOQuery;
    FConnInfo: string;
    FServer: string;
    FUserID: string;
    FPassword: string;
    FDB_Game: string;
    FDB_Account: string;
    FLastConnTime: TDateTime;
    FLastConnMsec: DWord;
  public
    constructor Create;
    destructor Destroy; override;

    property SqlDB: TADOQuery read FADOQuery;
    property SqlCon: TADOConnection read FADOConnection;
    function Connect(server, id, password: string): Boolean;
    function ReConnect: Boolean;
    procedure DisConnect;
    function Connected: Boolean;
    function UseDB(dbdata: TDBType): Boolean;
    function OpenQuery(sqlstr: string): TADOQuery;
    function ExeCuteSQL(sqlstr: string): Integer;
    function Execute(sqlstr: string): TADOQuery;

    //查找编辑-------------------------
    function Find(uname: string; var rcd: FSQLHumRcd): integer;
    function FindLike(uname: string; flist: TStrings): integer;
    function FindId(uid: string; var rcd: FSQLIdRcd): integer;
    function FindUserId(uid: string; flist: TStrings): integer;
    function FindUserIdCount(uid: string): integer;
    function SetRecord(uname: string; rcd: FSQLHumRcd): Boolean;
    function AddRecord(rcd: FSQLHumRcd): Boolean;
    function GetRecordCount: integer;

    //加载保存操作--------------------------------------------------------------
    //输出SQL语句
    function MakeSql(var pszSQL: AnsiString; nSQLType: Integer; lpTable: PTMIRDB_TABLE; pData: PAnsiChar): Boolean;
    //输出带参数的SQL语句
    function MakeSqlParam(var pszSQL: AnsiString; nSQLType: Integer; lpTable: PTMIRDB_TABLE; const Args: array of const): Boolean;
    function UpdateRecord(pTable: PTMIRDB_TABLE; lpVal: PAnsiChar; fNew: Boolean): Boolean;
    procedure _GetFields(SqlDB: TADOQuery; lpTable: PTMIRDB_TABLE; pData: PAnsiChar);
    procedure _SetRecordTHuman(lpCharFields: PTCHARACTERFIELDS; lptHuman: PTHuman);
    procedure _SetRecordCharFields(lpCharFields: PTCHARACTERFIELDS; lptHuman: PTHuman);
    procedure _SetRecordTBagItem(lpItemFields: PTITEMFIELDS; lptBagItem: PTBagItem; pnBagItem: PInteger);
    procedure _SetRecordTItemFields(lpItemFields: PTITEMFIELDS; lpUserItem: PTUserItem; nType: integer; szName: string; nPos: integer);
    procedure _FieldsToStrucAbil(lpAbilFields: PTABILITYFIELDS; lptAbility: PTAbility);
    procedure _StrucToFieldsAbil(lpAbilFields: PTABILITYFIELDS; lptAbility: PTAbility; szName: string);
    procedure _FieldsToStrucUseMagic(lpMagicFields: PTMAGICFIELDS; lptUseMagicInfo: PTUseMagicInfo);
    procedure _StrucToFieldsUseMagic(lpMagicFields: PTMAGICFIELDS; lptUseMagicInfo: PTUseMagicInfo; szName: string; nPos: integer);

    function SaveUserItem(pTable: PTMIRDB_TABLE; pUserItem: PTUserItem; nType: integer; szName: string; nPos: integer): Boolean;
    function SaveBagItem(pBagItem: PTBagItem; szName: string): Boolean;
    function SaveSaveItem(pSaveItem: PTSaveItem; szName: string): Boolean;
    function SaveUseMagic(pUseMagic: PTUseMagic; szName: string): Boolean;
    function SaveQuest(lptHuman: PTHuman; szName: string): Boolean;
    function LoadQuest(lptHuman: PTHuman; szName: string): Boolean;
  end;

var
  g_FDBSQL: TFDBSQL;

implementation

uses
  DBSMain, DBShare;

//去掉后面空格并加结束符#0
procedure ChangeSpaceToNull(pszData: PAnsiChar);
var
  pszCheck: PAnsiChar;
begin
	pszCheck := pszData;
	if (pszCheck <> nil) then begin
		while (pszCheck^ <> '') do begin
			if (pszCheck^ = AnsiChar($20)) and ((pszCheck + 1)^ = AnsiChar($20)) then begin
				pszCheck^ := #0;
				Break;
			end;
			Inc(pszCheck);
		end;
	end;
end;

constructor TFDBSql.Create;
begin
  FADOConnection := TADOConnection.Create(nil);
  FADOQuery := TADOQuery.Create(nil);
  FConnInfo := '';
  FDB_Game := 'Game';    //多区需要改的
  FDB_Account := 'Account';  //多区需要改的
  FLastConnTime := 0;
  FLastConnMSec := 0;
end;

destructor TFDBSql.Destroy;
begin
  Disconnect;
  FADOConnection.Free;
  FADOQuery.Free;
  inherited;
end;

function TFDBSql.Connect(server, id, password: string): Boolean;
begin
  Result := false;
  FServer := server;
  FUserID := id;
  FPassword := password;

  FConnInfo := 'Provider=SQLOLEDB.1;Password='         + password +
               ';Persist Security Info=True;User ID='  + id +
               ';Initial Catalog='                     + 'master' +
               ';Data Source='                         + server ;

  try
    if FConnInfo <> '' then begin
      // Try Connect...
      FADOConnection.Connected := FALSE;
      FADOConnection.ConnectionString := FConnInfo;
      FADOConnection.LoginPrompt := false;
      FADOConnection.Connected := true;
      Result := FADOConnection.Connected;
      if Result = true then begin
        // ADO_Query setting...
        FADOQuery.Active := false;
        FADOQuery.Connection := FADOConnection;
        FLastConnTime := Now;
        MainOutMessage(0, 'SUCCESS DBSQL CONNECTION');
      end;
    end
    else begin
      MainOutMessage(0, g_Config.SERVERNAME + ' : DBSQL CONNECTION INFO IS NULL!');
    end;
  except
    MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
  end;
  FlastConnMSec := GetTickCount;
end;

function TFDBSql.Connected: Boolean;
begin
  if not UseDB(tMaster) then ReConnect;
  Result := FADOConnection.Connected;
end;

procedure TFDBSql.DisConnect;
begin
  FAdoQuery.Active := false;
  FADOConnection.Connected := false;
end;

function TFDBSql.ReConnect: Boolean;
begin
  Result := false;
  // 15 檬俊 茄锅究 促矫 府目池记 秦夯促.
  //if (FlastConnMSec + 15 * 1000) < GetTickCount then begin
  DisConnect;

//   MainOutMessage('[TestCode]Try to reconnect with DBSQL');
  Result := Connect(FServer, FUserID, FPassword);
  MainOutMessage(0, 'CAUTION! DBSQL RECONNECTION');
  //end;
end;

function TFDBSql.UseDB(dbdata: TDBType): Boolean;
var
  sdb: string;
begin
  try
    case dbdata of
      tMaster:
        sdb := 'master';
      tGame:
        sdb := FDB_Game;
      tAccount:
        sdb := FDB_Account;
    end;
    FADOConnection.Execute('use ' + sdb);
    Result := TRUE;
  except
    Result := FALSE;
    FADOConnection.Connected := FALSE;
    MainOutMessage(RGB(255, 0, 0), '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TFDBSql.OpenQuery(sqlstr: string): TADOQuery;
begin
  try
    FADOQuery.Close;
    FADOQuery.SQL.Clear;
    FADOQuery.SQL.Add(sqlstr); // := sqlstr;
    FADOQuery.Open;
    Result := FADOQuery;
  except
    Result := nil;
    MainOutMessage(RGB(255, 0, 0), '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TFDBSql.Execute(sqlstr: string): TADOQuery;
begin
  try
    FADOQuery.Close;
    FADOQuery.SQL.Text := sqlstr;
    FADOQuery.ExecSQL;
    Result := FADOQuery;
  except
    Result := nil;
    MainOutMessage(RGB(255, 0, 0), '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TFDBSql.ExeCuteSQL(sqlstr: string): Integer;
begin
  try
    FADOQuery.Close;
    FADOQuery.SQL.Text := sqlstr;
    Result := FADOQuery.ExecSQL;
  except
    Result := 0;
    MainOutMessage(RGB(255, 0, 0), '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TFDBSql.Find(uname: string; var rcd: FSQLHumRcd): integer;
var
  szQuery: string;
begin
  Result := -1;
  szQuery := Format('SELECT FLD_CHARACTER, FLD_USERID, FLD_DELETED, FLD_RESERVED, ' +
                    'FLD_UPDATEDATETIME FROM TBL_CHARACTER '+
                    'WHERE FLD_CHARACTER=N''%s'' ORDER BY FLD_UPDATEDATETIME DESC',
                    [uname]);
  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      Open;
    except
      MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
      exit;
    end;
    if RecordCount > 0 then begin
      rcd.Block.ChrName := Trim(FieldByName('FLD_CHARACTER').AsString);
      rcd.Block.UserId := Trim(FieldByName('FLD_USERID').AsString);
      rcd.Block.Delete := (FieldByName('FLD_DELETED').AsInteger = 1);
      rcd.Block.DeleteDate := FieldByName('FLD_UPDATEDATETIME').AsDateTime;
      rcd.Block.Mark := Str_ToInt(Trim(FieldByName('FLD_RESERVED').AsString), 0);
      rcd.Key := rcd.Block.ChrName;
      Result := RecordCount;
    end;
    Close;
  end;
end;

function TFDBSql.FindLike(uname: string; flist: TStrings): integer;
var
  szQuery: string;
  rcd: PFSQLHumRcd;
begin
  Result := -1;
  szQuery := Format('SELECT FLD_CHARACTER, FLD_USERID, FLD_DELETED, FLD_RESERVED, ' +
                    'FLD_UPDATEDATETIME FROM TBL_CHARACTER '+
                    'WHERE FLD_CHARACTER LIKE N''%s%%'' ORDER BY FLD_UPDATEDATETIME DESC',
                    [uname]);
  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      Open;
    except
      exit;
    end;
    if RecordCount > 0 then begin
      First;
      while not Eof do begin
        New(rcd);
        FillChar(rcd^, SizeOf(FSQLHumRcd), #0);
        rcd.Block.ChrName := Trim(FieldByName('FLD_CHARACTER').AsString);
        rcd.Block.UserId := Trim(FieldByName('FLD_USERID').AsString);
        rcd.Block.Delete := (FieldByName('FLD_DELETED').AsInteger = 1);
        rcd.Block.DeleteDate := FieldByName('FLD_UPDATEDATETIME').AsDateTime;
        rcd.Block.Mark := Str_ToInt(Trim(FieldByName('FLD_RESERVED').AsString), 0);
        rcd.Key := rcd.Block.ChrName;
        flist.AddObject(rcd.Block.ChrName, TObject(rcd));
        Next;
      end;
      Result := RecordCount;
    end;
    Close;
  end;
end;

function TFDBSql.FindId(uid: string; var rcd: FSQLIdRcd): integer;
var
  szQuery: string;
begin
  Result := -1;
  FillChar (rcd, SizeOf(FSQLIdRcd), #0);
  szQuery := Format('SELECT A.FLD_LOGINID, FLD_PASSWORD, FLD_MAKETIME'+
                    ',FLD_USERNAME, B.FLD_SSNO, FLD_BIRTHDAY'+
                    ',FLD_PHONE, FLD_EMAIL, FLD_MOBILEPHONE'+
                    ',FLD_QUIZ1, FLD_ANSWER1, FLD_QUIZ2, FLD_ANSWER2'+
                    ' FROM TBL_ACCOUNT A,TBL_ACCOUNTADD B WHERE A.FLD_LOGINID'+
                    ' = N''%s'' AND A.FLD_LOGINID = B.FLD_LOGINID',
                    [uid]);
  UseDB(tAccount);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      Open;
    except
      exit;
    end;
    if RecordCount > 0 then begin
      rcd.MakeRcdDateTime := FieldByName('FLD_MAKETIME').AsDateTime;
      rcd.UpdateDateTime := Now;
      with rcd.UserInfo do begin
        UInfo.LoginId := FieldByName('FLD_LOGINID').AsString;
        UInfo.Password := FieldByName('FLD_PASSWORD').AsString;
        UInfo.UserName := FieldByName('FLD_USERNAME').AsString;
        UInfo.SSNo := FieldByName('FLD_SSNO').AsString;
        UInfo.Phone := FieldByName('FLD_PHONE').AsString;
        UInfo.Quiz := FieldByName('FLD_QUIZ1').AsString;
        UInfo.Answer := FieldByName('FLD_ANSWER1').AsString;
        UInfo.EMail := FieldByName('FLD_EMAIL').AsString;
        UAdd.Birthday := FieldByName('FLD_BIRTHDAY').AsString;
        UAdd.MobilePhone := FieldByName('FLD_MOBILEPHONE').AsString;
        UAdd.Quiz2 := FieldByName('FLD_QUIZ2').AsString;
        UAdd.Answer2 := FieldByName('FLD_ANSWER2').AsString;
        UAdd.Memo1 := '';
        UAdd.Memo2 := '';
      end;
      Result := RecordCount;
    end;
    Close;
  end;
end;

function TFDBSql.FindUserId(uid: string; flist: TStrings): integer;
var
  szQuery: string;
  rcd: PFSQLHumRcd;
begin
  Result := -1;
  szQuery := Format('SELECT FLD_CHARACTER, FLD_USERID, FLD_DELETED, FLD_RESERVED, ' +
                    'FLD_UPDATEDATETIME FROM TBL_CHARACTER '+
                    'WHERE FLD_USERID=N''%s'' ORDER BY FLD_UPDATEDATETIME DESC',
                    [uid]);
  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      Open;
    except
      exit;
    end;
    if RecordCount > 0 then begin
      First;
      while not Eof do begin
        New(rcd);
        FillChar(rcd^, SizeOf(FSQLHumRcd), #0);
        rcd.Block.ChrName := Trim(FieldByName('FLD_CHARACTER').AsString);
        rcd.Block.UserId := Trim(FieldByName('FLD_USERID').AsString);
        rcd.Block.Delete := (FieldByName('FLD_DELETED').AsInteger = 1);
        rcd.Block.DeleteDate := FieldByName('FLD_UPDATEDATETIME').AsDateTime;
        rcd.Block.Mark := Str_ToInt(Trim(FieldByName('FLD_RESERVED').AsString), 0);
        rcd.Key := rcd.Block.ChrName;
        flist.AddObject(rcd.Block.ChrName, TObject(rcd));
        Next;
      end;
      Result := RecordCount;
    end;
    Close;
  end;
end;

function  TFDBSql.FindUserIdCount (uid: string): integer;
var
  szQuery: string;
begin
  Result := 0;
  szQuery := Format('SELECT FLD_CHARACTER FROM TBL_CHARACTER '+
                    'WHERE FLD_USERID=N''%s'' AND FLD_DELETED=0',
                    [uid]);
  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      Open;
    except
      exit;
    end;
    if RecordCount > 0 then
      Result := RecordCount;
    Close;
  end;
end;

function  TFDBSql.SetRecord (uname: string; rcd: FSQLHumRcd): Boolean;
var
  szQuery: string;
begin
  Result := FALSE;
  szQuery := Format('UPDATE TBL_CHARACTER SET ' +
                    ' FLD_DELETED = %d, FLD_UPDATEDATETIME = GETDATE(),' +
                    ' FLD_RESERVED = ''%s''' +
                    ' WHERE FLD_CHARACTER=N''%s''',
                    [BoolToInt(rcd.Block.Delete), IntToStr(rcd.Block.Mark), uname]);
  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      ExecSQL;
    except
      exit;
    end;
  end;
  Result := TRUE;
end;

function TFDBSql.AddRecord(rcd: FSQLHumRcd): Boolean;
var
  temp: FSQLHumRcd;
  szQuery: string;
begin
  Result := FALSE;
  if Find (rcd.Key, temp) > 0 then begin
    Result := FALSE;
    exit;
  end;

  szQuery := Format( 'INSERT INTO TBL_CHARACTER(FLD_CHARACTER, FLD_USERID, '+
                     'FLD_DELETED, FLD_UPDATEDATETIME, FLD_MAKEDATE, '+
                     'FLD_JOB, FLD_HAIR, FLD_LEVEL, FLD_SEX)' +
                     ' VALUES(''%s'', ''%s'', %d, GetDate(), GetDate(), 0, 0, 0, 0)',
                     [rcd.Block.ChrName, rcd.Block.UserId, BoolToInt(rcd.Block.Delete)] );
  //SetLog(0, szQuery );
  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := szQuery;
    try
      ExecSQL;
    except
      exit;
    end;
  end;
  Result := TRUE;
end;

function TFDBSql.GetRecordCount: integer;
begin
  Result := 0;

  UseDB(tGame);
  with FADOQuery do begin
    Close;
    SQL.Text := 'SELECT COUNT(1) FROM TBL_CHARACTER';
    try
      Open;
      Result := Fields[0].AsInteger;
    except
    end;
    Close;
  end;
end;

{游戏服务数据库操作}
function TFDBSql.MakeSql(var pszSQL: AnsiString; nSQLType: Integer;
  lpTable: PTMIRDB_TABLE; pData: PAnsiChar): Boolean;
var
  nCnt, nCnt2, i: integer;
  szTemp, szWhere, szWhereFull: string;
begin
	nCnt := 0; nCnt2 := 0;
  szTemp := '';

	case (nSQLType) of
		SQLTYPE_SELECT:
      begin
		   	pszSQL := Format('SELECT * FROM %s', [lpTable.szTableName]);
		  	Result := TRUE;
      end;
		SQLTYPE_SELECTWHERE:
		  begin
			  pszSQL := Format('SELECT * FROM %s WHERE ', [lpTable.szTableName]);

		   	for i:=0 to lpTable.nNumOfFields-1 do
			  begin

				  if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
			  	begin
				  	if (nCnt >= 1) then
					  	pszSQL := pszSQL + 'AND ';

				  	if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
					  	szTemp := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PAnsiChar(pData)])
					  else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_INT) then
					  	szTemp := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Pinteger(pData)^])
				   	else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DBL) then
					  	szTemp := Format('%s=%.3f ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PDouble(pData)^]);

            Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);

				  	pszSQL := pszSQL + szTemp;
				  	Inc(nCnt);
			  	end;
		  	end;
		  	Result := TRUE;
	  	end;
		SQLTYPE_UPDATE:
	  	begin
		  	pszSQL := Format('UPDATE %s SET ', [lpTable.szTableName]);

			  szWhereFull := ' WHERE ';

		  	for i:=0 to lpTable.nNumOfFields-1 do
		  	begin
			  	if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
				  begin
				  	if (nCnt >= 1) then
					  	szWhereFull := szWhereFull + 'AND ';

				  	if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
					  	szWhere := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PAnsiChar(pData)])
				  	else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_INT) then
					  	szWhere := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PInteger(pData)^])
				  	else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DBL) then
					  	szWhere := Format('%s=%.3f ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PDouble(pData)^]);

            Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);

				  	szWhereFull := szWhereFull + szWhere;
				  	Inc(nCnt);
			  	end
			  	else
				  begin
				  	if (nCnt2 >= 1) then
					  	pszSQL := pszSQL + ', ';

				  	if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
				  	begin
					   	szTemp := Format('%s=N''%s''', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PAnsiChar(pData)]);
              Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
				  	end
				  	else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DAT) then
				  	begin
					  	szTemp := Format('%s=GETDATE()', [TMirDBFields(lpTable.lpFields)[i].szFieldName]);
				  	end
				  	else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_INT) then
				  	begin
					  	szTemp := Format('%s=%d', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PInteger(pData)^]);
              Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
				  	end
				  	else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DBL) then
				  	begin
					  	szTemp := Format('%s=%.3f', [TMirDBFields(lpTable.lpFields)[i].szFieldName, PDouble(pData)^]);
              Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
				  	end;

				  	pszSQL := pszSQL + szTemp;
				  	Inc(nCnt2);
			  	end;
		  	end;
		  	pszSQL := pszSQL + szWhereFull;

{$IFDEF DEBUG}
		  	//_RPT1(_CRT_WARN, "%s\n", pszSQL);
{$ENDIF}
		  	Result := TRUE;
	  	end;
		SQLTYPE_INSERT:
	  	begin
		  	pszSQL := Format('INSERT %s ( ', [lpTable.szTableName]);

		  	for i:=0 to lpTable.nNumOfFields-1 do
			  begin
			  	pszSQL := pszSQL + TMirDBFields(lpTable.lpFields)[i].szFieldName;

			   	if (i + 1) <> lpTable.nNumOfFields then
				  	pszSQL := pszSQL + ', '
			  	else
				  	pszSQL := pszSQL + ') ';
		   	end;

		  	pszSQL := pszSQL + 'VALUES ( ';

		  	for i:=0 to lpTable.nNumOfFields-1 do
		  	begin
			  	if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
			  	begin
				  	if (CompareStr(TMirDBFields(lpTable.lpFields)[i].szFieldName, 'FLD_NAMEPREFIX') = 0) then
				  	begin
{			  			int dataLen = strlen( (char *) pData );
					  	FILE *fp = fopen( "d:\\moya.log", "wb" );
					  	fprintf( fp, "\r\n\r\nDataSize: %d Bytes\r\n", dataLen );
					  	if ( dataLen <= 10000 ) then
						  	fwrite( pData, 1, dataLen, fp );
					  	fclose( fp );
}
					  	szTemp := QuotedStr('');
				  	end	else
					  	szTemp := Format('N''%s''', [PAnsiChar(pData)]);

            Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
			  	end	else
          if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DAT) then
				  	szTemp := 'GETDATE()'
			  	else
          if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_INT) then
			  	begin
				  	szTemp := Format('%d', [PInteger(pData)^]);
            Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
			  	end	else
          if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DBL) then
			  	begin
				  	szTemp := Format('%.3f', [PDouble(pData)^]);
            Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
			  	end;

			  	pszSQL := pszSQL + szTemp;

			  	if (i + 1) <> lpTable.nNumOfFields then
				  	pszSQL := pszSQL + ', '
			  	else
				  	pszSQL := pszSQL + ') ';
		  	end;
		  	Result := TRUE;
	  	end;
  end;
	Result := FALSE;
end;

function TFDBSql.MakeSqlParam(var pszSQL: AnsiString; nSQLType: Integer;
  lpTable: PTMIRDB_TABLE; const Args: array of const): Boolean;
var
  v: va_list;
  i, nCnt, nCnt2: integer;
  szTemp, szWhere, szWhereFull: AnsiString;
begin
  Result := FALSE;
	nCnt := 0; nCnt2 := 0;
	szTemp := '';

	case nSQLType of
		SQLTYPE_SELECT:
      begin
        pszSQL := Format('SELECT * FROM %s', [lpTable.szTableName]);
        Result := TRUE;
      end;
		SQLTYPE_SELECTWHERE:
      begin
        pszSQL := Format('SELECT * FROM %s WHERE ', [lpTable.szTableName]);

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
          begin
            if nCnt > High(Args) then Break;  //大于参数个数停止
            if (nCnt >= 1) then
              pszSQL := pszSQL + 'AND ';

            if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
              szTemp := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
            else
              szTemp := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);

            pszSQL := pszSQL + szTemp;
            Inc(nCnt);
          end;
        end;
        Result := TRUE;
      end;
		SQLTYPE_SELECTWHERENOT: // TO PDS
      begin
        pszSQL := Format('SELECT * FROM %s WHERE ', [lpTable.szTableName]);

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
          begin
            if nCnt > High(Args) then Break;  //大于参数个数停止
            if (nCnt >= 1) then
              pszSQL := pszSQL + 'AND ';

            if ( nCnt > 0 ) then
            begin
              if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
                szTemp := Format('%s<>N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
              else
                szTemp := Format('%s<>%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);
            end
            else
            begin
              if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
                szTemp := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
              else
                szTemp := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);
            end;

            pszSQL := pszSQL + szTemp;
            Inc(nCnt);
          end;
        end;
        Result := TRUE;
      end;
		SQLTYPE_UPDATE:
      begin
        pszSQL := Format('UPDATE %s SET ', [lpTable.szTableName]);

        szWhereFull := ' WHERE ';

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          if nCnt > High(Args) then Break;  //大于参数个数停止

          if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
          begin
            if (nCnt >= 1) then
              szWhereFull := szWhereFull + 'AND ';

            if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
              szWhere := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
            else
              szWhere := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);

            szWhereFull := szWhereFull + szWhere;
            Inc(nCnt);
          end
          else
          begin
            if (nCnt2 >= 1) then
              pszSQL := pszSQL + ', ';

            if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
              szTemp := Format('%s=N''%s''', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
            else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DAT) then  //此处nCnt是否要减1？？
              szTemp := Format('%s=GETDATE()', [TMirDBFields(lpTable.lpFields)[i].szFieldName])
            else
              szTemp := Format('%s=%d', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);

            pszSQL := pszSQL + szTemp;
            Inc(nCnt);
            Inc(nCnt2);
          end;
        end;
        pszSQL := pszSQL + szWhereFull;
        Result := TRUE;
      end;
		SQLTYPE_INSERT:
      begin
        pszSQL := Format('INSERT %s (', [lpTable.szTableName]);

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          pszSQL := pszSQL + TMirDBFields(lpTable.lpFields)[i].szFieldName;

          if ((i + 1) <> lpTable.nNumOfFields) and (i < High(Args)) then
            pszSQL := pszSQL + ', '
          else begin
            pszSQL := pszSQL + ') ';
            Break;
          end;
        end;

        pszSQL := pszSQL + 'VALUES (';

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
            szTemp := Format('N''%s''', [AnsiString(Args[i].VAnsiString)])
          else if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DAT) then
            szTemp := 'GETDATE()'
          else
            szTemp := Format('%d', [Args[i].VInteger]);

          pszSQL := pszSQL + szTemp;

          if ((i + 1) <> lpTable.nNumOfFields) and (i < High(Args)) then
            pszSQL := pszSQL + ', '
          else begin
            pszSQL := pszSQL + ')';
            Break;
          end;
        end;
        Result := TRUE;
      end;
		SQLTYPE_DELETE:
      begin
        pszSQL := Format('DELETE FROM %s WHERE ', [lpTable.szTableName]);

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
          begin
            if nCnt > High(Args) then Break;  //大于参数个数停止
            if (nCnt >= 1) then
              pszSQL := pszSQL + 'AND ';

            if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
              szTemp := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
            else
              szTemp := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);

            pszSQL := pszSQL + szTemp;

            Inc(nCnt);
          end;
        end;
        Result := TRUE;
      end;
		SQLTYPE_DELETENOT:
      begin
        pszSQL := Format('DELETE FROM %s WHERE ', [lpTable.szTableName]);

        for i := 0 to lpTable.nNumOfFields - 1 do
        begin
          if (TMirDBFields(lpTable.lpFields)[i].fIsKey) then
          begin
            if nCnt > High(Args) then Break;  //大于参数个数停止
            if (nCnt >= 1) then
              pszSQL := pszSQL + 'AND ';

            if ( nCnt > 0 ) then
            begin
              if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
                szTemp := Format('%s<>N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
              else
                szTemp := Format('%s<>%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);
            end
            else
            begin
              if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then
                szTemp := Format('%s=N''%s'' ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, AnsiString(Args[nCnt].VAnsiString)])
              else
                szTemp := Format('%s=%d ', [TMirDBFields(lpTable.lpFields)[i].szFieldName, Args[nCnt].VInteger]);
            end;

            pszSQL := pszSQL + szTemp;

            Inc(nCnt);
          end;
        end;
        Result := TRUE;
      end;
	end;
end;

function TFDBSql.UpdateRecord(pTable: PTMIRDB_TABLE; lpVal: PAnsiChar; fNew: Boolean): Boolean;
var
  szQuery: AnsiString;
begin
  Result := FALSE;
	if (fNew) then
		MakeSql(szQuery, SQLTYPE_INSERT, pTable, lpVal)
	else
		MakeSql(szQuery, SQLTYPE_UPDATE, pTable, lpVal);
//  SetLog( 0, szQuery );
	if ExecuteSQL (szQuery) > 0 then
	begin
	  Result := TRUE;
	end;
	//m_TransLog.Log ( szQuery, true );
end;

procedure TFDBSql._GetFields(SqlDB: TADOQuery; lpTable: PTMIRDB_TABLE; pData: PAnsiChar);
var
  pszData: PAnsiChar;
  i: integer;
begin
	pszData := nil;
	for i := 0 to lpTable.nNumOfFields - 1 do begin
		if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_STR) then begin
       pszData := PAnsiChar(AnsiString(SqlDB.FieldByName(TMirDBFields(lpTable.lpFields)[i].szFieldName).AsString));
			 ChangeSpaceToNull(pszData);
       StrCopy(pData, pszData);
       Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
		end	else
    if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_INT) then begin
       PInteger(pData)^ := SqlDB.FieldByName(TMirDBFields(lpTable.lpFields)[i].szFieldName).AsInteger;
       Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
		end else
    if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DBL) then begin
       PDouble(pData)^ := SqlDB.FieldByName(TMirDBFields(lpTable.lpFields)[i].szFieldName).AsFloat;
       Inc(pData, TMirDBFields(lpTable.lpFields)[i].nSize);
		end	else
    if (TMirDBFields(lpTable.lpFields)[i].btType = TABLETYPE_DAT) then begin
    end;
	end;
end;

procedure TFDBSql._SetRecordTHuman(lpCharFields: PTCHARACTERFIELDS; lptHuman: PTHuman);
begin
	strcopy(lptHuman.UserName, lpCharFields.fld_character);
	strcopy(lptHuman.MapName, lpCharFields.fld_mapname);

	lptHuman.CX	:= lpCharFields.fld_cx;
	lptHuman.CY	:= lpCharFields.fld_cy;
	lptHuman.Dir	:= lpCharFields.fld_dir;
	lptHuman.Hair	:= lpCharFields.fld_hair;
	lptHuman.Sex	:= lpCharFields.fld_sex;
	lptHuman.Job	:= lpCharFields.fld_job;
	lptHuman.Gold	:= lpCharFields.fld_gold;
  lptHuman.PotCash	:= lpCharFields.fld_potcash;
  lptHuman.GamePoint	:= lpCharFields.fld_GamePoint;

	lptHuman.HairColorR	:= lpCharFields.fld_haircolorr;
	lptHuman.HairColorG	:= lpCharFields.fld_haircolorg;
	lptHuman.HairColorB	:= lpCharFields.fld_haircolorb;
	// TO PDS:
	//lptHuman.Abil.Level := lpCharFields.fld_level;
	lptHuman.Abil_Level	:= lpCharFields.fld_level;
	lptHuman.Abil_HP		:= lpCharFields.fld_hp;
	lptHuman.Abil_MP		:= lpCharFields.fld_mp;
	lptHuman.Abil_EXP		:= lpCharFields.fld_exp;

	strcopy(lptHuman.HomeMap, lpCharFields.fld_homemap);

	lptHuman.HomeX				:= lpCharFields.fld_homex;
	lptHuman.HomeY				:= lpCharFields.fld_homey;

	lptHuman.PkPoint			:= lpCharFields.fld_pkpoint;
	lptHuman.AllowParty		:= lpCharFields.fld_allowparty;
	lptHuman.FreeGulityCount	:= lpCharFields.fld_fregulitycount;
	lptHuman.AttackMode		:= lpCharFields.fld_attackmode;
	lptHuman.IncHealth			:= lpCharFields.fld_inchealth;
	lptHuman.IncSpell			:= lpCharFields.fld_incspell;
	lptHuman.IncHealing		:= lpCharFields.fld_inchealing;
	lptHuman.FightZoneDie		:= lpCharFields.fld_fightzonedie;

	strcopy(lptHuman.UserID, lpCharFields.fld_userid);

	lptHuman.DBVersion				:= lpCharFields.fld_dbversion;
	lptHuman.BonusApply			:= lpCharFields.fld_bonusapply;
	lptHuman.BonusPoint			:= lpCharFields.fld_bonuspoint;
	lptHuman.HorseRide				:= lpCharFields.fld_hungrystate;
	lptHuman.DailyQuest			:= lpCharFields.fld_testserverresetcount;
	lptHuman.CGHIUseTime			:= lpCharFields.fld_cghusetime;
	lptHuman.BodyLuck				:= lpCharFields.fld_bodyluck;
  lptHuman.BoEnableGRecall := Boolean(lpCharFields.fld_enablegrecall);

	lptHuman.HorseRace		:= lpCharFields.fld_horserace;

	lptHuman.Abil_FameCur		:= lpCharFields.fld_famecur;
	lptHuman.Abil_FameBase		:= lpCharFields.fld_famebase;
  lptHuman.Seconds		:= lpCharFields.fld_seconds;
end;

procedure TFDBSql._SetRecordCharFields(lpCharFields: PTCHARACTERFIELDS; lptHuman: PTHuman);
begin
	ZeroMemory(lpCharFields, sizeof(TCHARACTERFIELDS));

	strcopy(lpCharFields.fld_character, lptHuman.UserName);
	strcopy(lpCharFields.fld_mapname, lptHuman.MapName);

	lpCharFields.fld_cx	:= lptHuman.CX;
	lpCharFields.fld_cy	:= lptHuman.CY;
	lpCharFields.fld_dir	:= lptHuman.Dir;
	lpCharFields.fld_hair	:= lptHuman.Hair;
	lpCharFields.fld_sex	:= lptHuman.Sex;
	lpCharFields.fld_job	:= lptHuman.Job;
	lpCharFields.fld_gold	:= lptHuman.Gold;
  lpCharFields.fld_potcash	:= lptHuman.PotCash;
  lpCharFields.fld_GamePoint	:= lptHuman.GamePoint;

	lpCharFields.fld_haircolorr	:= lptHuman.HairColorR;
	lpCharFields.fld_haircolorg	:= lptHuman.HairColorG;
	lpCharFields.fld_haircolorb	:= lptHuman.HairColorB;

	// TO PDS
	lpCharFields.fld_level := lptHuman.Abil_Level;
	lpCharFields.fld_hp	:= lptHuman.Abil_HP;
	lpCharFields.fld_mp	:= lptHuman.Abil_MP;
	lpCharFields.fld_exp	:= lptHuman.Abil_EXP;

	strcopy(lpCharFields.fld_homemap, lptHuman.HomeMap);

	lpCharFields.fld_homex				:= lptHuman.HomeX;
	lpCharFields.fld_homey				:= lptHuman.HomeY;
{$IFDEF DEBUG}
	MainOutMessage( CDBG, Format('%s -> %s, %d, %d', [lptHuman.UserName, lptHuman.MapName, lptHuman.CX, lptHuman.CY]) );
{$ENDIF}
	lpCharFields.fld_pkpoint			:= lptHuman.PkPoint;
	lpCharFields.fld_allowparty		:= lptHuman.AllowParty;
	lpCharFields.fld_fregulitycount	:= lptHuman.FreeGulityCount;
	lpCharFields.fld_attackmode		:= lptHuman.AttackMode;
	lpCharFields.fld_inchealth			:= lptHuman.IncHealth;
	lpCharFields.fld_incspell			:= lptHuman.IncSpell;
	lpCharFields.fld_inchealing		:= lptHuman.IncHealing;
	lpCharFields.fld_fightzonedie		:= lptHuman.FightZoneDie;

	strcopy(lpCharFields.fld_userid, lptHuman.UserID);

	lpCharFields.fld_dbversion					:= lptHuman.DBVersion;
	lpCharFields.fld_bonusapply				:= lptHuman.BonusApply;
	lpCharFields.fld_bonuspoint				:= lptHuman.BonusPoint;
	lpCharFields.fld_hungrystate				:= lptHuman.HorseRide;
	lpCharFields.fld_testserverresetcount		:= lptHuman.DailyQuest;
	lpCharFields.fld_cghusetime				:= lptHuman.CGHIUseTime;
	lpCharFields.fld_bodyluck					:= lptHuman.BodyLuck;
	lpCharFields.fld_enablegrecall				:= BoolToInt(lptHuman.BoEnableGRecall);

	lpCharFields.fld_horserace		:= lptHuman.HorseRace;

	//疙己摹
	lpCharFields.fld_famecur	:= lptHuman.Abil_FameCur;
	lpCharFields.fld_famebase	:= lptHuman.Abil_FameBase;
  lpCharFields.fld_seconds := lpthuman.Seconds;
end;

procedure TFDBSql._SetRecordTItemFields(lpItemFields: PTITEMFIELDS; lpUserItem: PTUserItem; nType: integer; szName: string; nPos: integer);
var
  i: integer;
begin
	strcopy(lpItemFields.fld_character, PAnsiChar(AnsiString(szName)));

	lpItemFields.fld_type := nType;
	lpItemFields.fld_pos  := nPos;

	lpItemFields.fld_makeindex	:= lpUserItem.MakeIndex;
	lpItemFields.fld_index		:= lpUserItem.Index;
	lpItemFields.fld_dura		:= lpUserItem.Dura;
	lpItemFields.fld_duramax	:= lpUserItem.DuraMax;

	for i := 0 to 13 do
		lpItemFields.fld_desc[i] := lpUserItem.Desc[i];

//	lpItemFields.fld_colorr	:= lpUserItem.ColorR;
//	lpItemFields.fld_colorg	:= lpUserItem.ColorG;
//	lpItemFields.fld_colorb	:= lpUserItem.ColorB;

//	if (strlen(lpUserItem.Prefix) > 0) then
//	begin
////		strcopy(lpItemFields.Prefix, lpUserItem.Prefix);
//		SetLog( 0, Format('SavedItem[SAVE] : %c %c %c', [lpUserItem.Prefix[0], lpUserItem.Prefix[1], lpUserItem.Prefix[2]]) );
//		ZeroMemory(@lpItemFields.Prefix, sizeof(lpItemFields.Prefix));
//	end else
//	begin
//		ZeroMemory(@lpItemFields.Prefix, sizeof(lpItemFields.Prefix));
//	end;
end;

procedure TFDBSql._StrucToFieldsAbil(lpAbilFields: PTABILITYFIELDS; lptAbility: PTAbility;  szName: string);
begin
	strcopy(lpAbilFields.fld_character, PAnsiChar(AnsiString(szName)));

	lpAbilFields.fld_level		:= lptAbility.Level;

	lpAbilFields.fld_ac		:= lptAbility.AC;
	lpAbilFields.fld_mac		:= 0;
	lpAbilFields.fld_dc		:= lptAbility.DC;
	lpAbilFields.fld_mc		:= 0;
	lpAbilFields.fld_sc		:= 0;

	lpAbilFields.fld_hp		:= lptAbility.HP;
	lpAbilFields.fld_mp		:= lptAbility.MP;

	lpAbilFields.fld_maxhp		:= lptAbility.MaxHP;
	lpAbilFields.fld_maxmp		:= lptAbility.MAXMP;

	lpAbilFields.fld_exp		:= lptAbility.Exp;
	lpAbilFields.fld_maxexp	:= lptAbility.MaxExp;

	lpAbilFields.fld_weight	:= lptAbility.Weight;
	lpAbilFields.fld_maxweight	:= lptAbility.MaxWeight;

	lpAbilFields.fld_wearweight		:= lptAbility.WearWeight;
	lpAbilFields.fld_maxwearweight		:= lptAbility.MaxWearWeight;
	lpAbilFields.fld_handweight		:= lptAbility.HandWeight;
	lpAbilFields.fld_maxhandweight		:= lptAbility.MaxHandWeight;

(*	lptAbility.FameLevel;
	lptAbility.MiningLevel;
	lptAbility.FramingLevel;
	lptAbility.FishingLevel;

	lptAbility.FameExp;
	lptAbility.FameMaxExp;
	lptAbility.MiningExp;
	lptAbility.MiningMaxExp;
	lptAbility.FramingExp;
	lptAbility.FramingMaxExp;
	lptAbility.FishingExp;
	lptAbility.FishingMaxExp; *)
//	lpAbilFields.fld_atomfire_mc		:= lptAbility.ATOM_MC[ATOM_FIRE];
//	lpAbilFields.fld_atomice_mc		:= lptAbility.ATOM_MC[ATOM_ICE];
//	lpAbilFields.fld_atomlight_mc		:= lptAbility.ATOM_MC[ATOM_LIGHT];
//	lpAbilFields.fld_atomwind_mc		:= lptAbility.ATOM_MC[ATOM_WIND];
//	lpAbilFields.fld_atomholy_mc		:= lptAbility.ATOM_MC[ATOM_HOLY];
//	lpAbilFields.fld_atomdark_mc		:= lptAbility.ATOM_MC[ATOM_DARK];
//	lpAbilFields.fld_atomphantom_mc	:= lptAbility.ATOM_MC[ATOM_PHANTOM];
//	lpAbilFields.fld_atomfire_mac		:= lptAbility.ATOM_MAC[ATOM_FIRE];
//	lpAbilFields.fld_atomice_mac		:= lptAbility.ATOM_MAC[ATOM_ICE];
//	lpAbilFields.fld_atomlight_mac		:= lptAbility.ATOM_MAC[ATOM_LIGHT];
//	lpAbilFields.fld_atomwind_mac		:= lptAbility.ATOM_MAC[ATOM_WIND];
//	lpAbilFields.fld_atomholy_mac		:= lptAbility.ATOM_MAC[ATOM_HOLY];
//	lpAbilFields.fld_atomdark_mac		:= lptAbility.ATOM_MAC[ATOM_DARK];
//	lpAbilFields.fld_atomphantom_mac	:= lptAbility.ATOM_MAC[ATOM_PHANTOM];
end;

procedure TFDBSql._FieldsToStrucAbil(lpAbilFields: PTABILITYFIELDS; lptAbility: PTAbility);
begin
	lptAbility.Level		:= lpAbilFields.fld_level;
	                      
	lptAbility.AC			:= lpAbilFields.fld_ac;
	lptAbility.DC			:= lpAbilFields.fld_dc;
	                      
	lptAbility.HP			:= lpAbilFields.fld_hp;
	lptAbility.MP			:= lpAbilFields.fld_mp;
	                      
	lptAbility.MaxHP		:= lpAbilFields.fld_maxhp;
	lptAbility.MAXMP		:= lpAbilFields.fld_maxmp;
	                      
	lptAbility.Exp			:= lpAbilFields.fld_exp;
	lptAbility.MaxExp		:= lpAbilFields.fld_maxexp;
	                      
	lptAbility.Weight		:= lpAbilFields.fld_weight;
	lptAbility.MaxWeight	:= lpAbilFields.fld_maxweight;

	lptAbility.WearWeight		:= lpAbilFields.fld_wearweight;
	lptAbility.MaxWearWeight	:= lpAbilFields.fld_maxwearweight;
	lptAbility.HandWeight		:= lpAbilFields.fld_handweight;
	lptAbility.MaxHandWeight	:= lpAbilFields.fld_maxhandweight;

//	lptAbility.ATOM_MC[ATOM_FIRE]		:= lpAbilFields.fld_atomfire_mc;
//	lptAbility.ATOM_MC[ATOM_ICE]		:= lpAbilFields.fld_atomice_mc;
//	lptAbility.ATOM_MC[ATOM_LIGHT]		:= lpAbilFields.fld_atomlight_mc;
//	lptAbility.ATOM_MC[ATOM_WIND]		:= lpAbilFields.fld_atomwind_mc;
//	lptAbility.ATOM_MC[ATOM_HOLY]		:= lpAbilFields.fld_atomholy_mc;
//	lptAbility.ATOM_MC[ATOM_DARK]		:= lpAbilFields.fld_atomdark_mc;
//	lptAbility.ATOM_MC[ATOM_PHANTOM]	:= lpAbilFields.fld_atomphantom_mc;
//	lptAbility.ATOM_MAC[ATOM_FIRE]		:= lpAbilFields.fld_atomfire_mac;
//	lptAbility.ATOM_MAC[ATOM_ICE]		:= lpAbilFields.fld_atomice_mac;
//	lptAbility.ATOM_MAC[ATOM_LIGHT]	:= lpAbilFields.fld_atomlight_mac;
//	lptAbility.ATOM_MAC[ATOM_WIND]		:= lpAbilFields.fld_atomwind_mac;
//	lptAbility.ATOM_MAC[ATOM_HOLY]		:= lpAbilFields.fld_atomholy_mac;
//	lptAbility.ATOM_MAC[ATOM_DARK]		:= lpAbilFields.fld_atomdark_mac;
//	lptAbility.ATOM_MAC[ATOM_PHANTOM]	:= lpAbilFields.fld_atomphantom_mac;
(*	lptAbility.FameLevel;
	lptAbility.MiningLevel;			  
	lptAbility.FramingLevel;
	lptAbility.FishingLevel;

	lptAbility.FameExp;
	lptAbility.FameMaxExp;
	lptAbility.MiningExp;
	lptAbility.MiningMaxExp;
	lptAbility.FramingExp;
	lptAbility.FramingMaxExp;
	lptAbility.FishingExp;
	lptAbility.FishingMaxExp; *)
end;

procedure TFDBSql._StrucToFieldsUseMagic(lpMagicFields: PTMAGICFIELDS; lptUseMagicInfo: PTUseMagicInfo; szName: string; nPos: integer);
begin
	strcopy(lpMagicFields.fld_character, PAnsiChar(AnsiString(szName)));

	lpMagicFields.fld_pos		  	:= nPos;
	lpMagicFields.fld_magicid		:= lptUseMagicInfo.MagicId;
	lpMagicFields.fld_level	  	:= lptUseMagicInfo.Level;
	lpMagicFields.fld_key		  	:= byte(lptUseMagicInfo.Key);  //Str_ToInt(lptUseMagicInfo.Key, 0);
	lpMagicFields.fld_curtrain	:= lptUseMagicInfo.Curtrain;
end;

procedure TFDBSql._FieldsToStrucUseMagic(lpMagicFields: PTMAGICFIELDS; lptUseMagicInfo: PTUseMagicInfo );
begin
	lptUseMagicInfo.MagicId	:= lpMagicFields.fld_magicid;
	lptUseMagicInfo.Level		:= lpMagicFields.fld_level;
	lptUseMagicInfo.Key		:= AnsiChar(lpMagicFields.fld_key);  //IntToStr(lpMagicFields.fld_key)[1];
	lptUseMagicInfo.Curtrain	:= lpMagicFields.fld_curtrain;
end;

procedure TFDBSql._SetRecordTBagItem(lpItemFields: PTITEMFIELDS; lptBagItem: PTBagItem; pnBagItem: PInteger);
var
  lpUserItem: PTUserItem;
  i: integer;
begin
	lpUserItem := nil;

	case lpItemFields.fld_type of
		U_DRESS:
			lpUserItem := @lptBagItem.uDress;
		U_WEAPON:
			lpUserItem := @lptBagItem.uWeapon;
		U_RIGHTHAND:
			lpUserItem := @lptBagItem.uRightHand;
		U_NECKLACE:
			lpUserItem := @lptBagItem.uNecklace;
		U_HELMET:
			lpUserItem := @lptBagItem.uHelmet;
		U_ARMRINGL:
			lpUserItem := @lptBagItem.uArmRingL;
		U_ARMRINGR:
			lpUserItem := @lptBagItem.uArmRingR;
		U_RINGL:
			lpUserItem := @lptBagItem.uRingL;
		U_RINGR:
			lpUserItem := @lptBagItem.uRingR;
		U_BUJUK:
			lpUserItem := @lptBagItem.uBujuk;
		U_BELT:
			lpUserItem := @lptBagItem.uBelt;
		U_BOOTS:
			lpUserItem := @lptBagItem.uBoots;
		U_CHARM:
			lpUserItem := @lptBagItem.uCharm;
		U_TRANS:
			lpUserItem := @lptBagItem.uTrans
		else
			lpUserItem := @(lptBagItem.Bags[pnBagItem^]);
			pnBagItem^ := pnBagItem^ + 1;
	end;

	lpUserItem.MakeIndex	:= lpItemFields.fld_makeindex;
	lpUserItem.Index		:= lpItemFields.fld_index;
	lpUserItem.Dura		:= lpItemFields.fld_dura;
	lpUserItem.DuraMax		:= lpItemFields.fld_duramax;
	for i := 0 to 13 do
		lpUserItem.Desc[i]	:= BYTE(lpItemFields.fld_desc[i]);
//	lpUserItem.ColorR		:= lpItemFields.fld_colorr;
//	lpUserItem.ColorG		:= lpItemFields.fld_colorg;
//	lpUserItem.ColorB		:= lpItemFields.fld_colorb;
//
//	if (strlen(lpItemFields.Prefix) > 0) then
//		strcopy(lpUserItem.Prefix, lpItemFields.Prefix)
//	else
//		ZeroMemory(@lpUserItem.Prefix, sizeof(lpUserItem.Prefix));
end;

function TFDBSql.SaveUserItem(pTable: PTMIRDB_TABLE; pUserItem: PTUserItem; nType: integer; szName: string; nPos: integer): Boolean;
var
  ItemFields: TITEMFIELDS;
begin
  Result := FALSE;
	ZeroMemory(@ItemFields, sizeof(TITEMFIELDS));
	_SetRecordTItemFields(@ItemFields, pUserItem, nType, szName, nPos);

	if (UpdateRecord(pTable, @ItemFields, true)) then
	begin
		Result := TRUE;
	end;
end;

function TFDBSql.SaveBagItem(pBagItem: PTBagItem; szName: string): Boolean;
var
  szQuery: AnsiString;
  i: integer;
begin
  Result := FALSE;

	if (makesqlparam(szQuery, SQLTYPE_DELETENOT, @__ITEMTABLE, [AnsiString(szName) , U_SAVE])) then
 	begin
//    SetLog( 0, szQuery);
    ExeCuteSQL (szQuery);
//		if ( pRec <> nil ) then
//		begin
//				fFail = true;
//		end;
 	end;

	if (pBagItem.uDress.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uDress, U_DRESS, szName , 0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uDress, U_DRESS, szName)) then
//			Exit;
	end;

	if (pBagItem.uWeapon.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uWeapon, U_WEAPON, szName , 0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uWeapon, U_WEAPON, szName))
//			Exit;
	end;

	if (pBagItem.uRightHand.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uRightHand, U_RIGHTHAND, szName , 0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uRightHand, U_RIGHTHAND, szName))
//			Exit;
	end;

	if (pBagItem.uHelmet.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uHelmet, U_HELMET, szName ,0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uHelmet, U_HELMET, szName))
//			Exit;
	end;

	if (pBagItem.uNecklace.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uNecklace, U_NECKLACE, szName ,0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uNecklace, U_NECKLACE, szName))
//			Exit;
	end;

	if (pBagItem.uArmRingL.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uArmRingL, U_ARMRINGL, szName ,0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uArmRingL, U_ARMRINGL, szName))
//			Exit;
	end;

	if (pBagItem.uArmRingR.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uArmRingR, U_ARMRINGR, szName ,0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uArmRingR, U_ARMRINGR, szName))
//			Exit;
	end;

	if (pBagItem.uRingL.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uRingL, U_RINGL, szName, 0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uRingL, U_RINGL, szName))
//			Exit;
	end;

	if (pBagItem.uRingR.MakeIndex > 0) then
	begin
		SaveUserItem(@__ITEMTABLE, @pBagItem.uRingR, U_RINGR, szName , 0);
//		if (not SaveUserItem(@__ITEMTABLE, @pBagItem.uRingR, U_RINGR, szName))
//			Exit;
	end;

	if (pBagItem.uBujuk.MakeIndex > 0) then
		SaveUserItem(@__ITEMTABLE, @pBagItem.uBujuk, U_BUJUK, szName ,0);

	if (pBagItem.uBelt.MakeIndex > 0) then
		SaveUserItem(@__ITEMTABLE, @pBagItem.uBelt, U_BELT, szName, 0);


	if (pBagItem.uBoots.MakeIndex > 0) then
		SaveUserItem(@__ITEMTABLE, @pBagItem.uBoots, U_BOOTS, szName, 0);
	
	// TO PDS:
	if (pBagItem.uCharm.MakeIndex > 0) then
		SaveUserItem(@__ITEMTABLE, @pBagItem.uCharm, U_CHARM, szName, 0);

	if (pBagItem.uTrans.MakeIndex > 0) then
		SaveUserItem(@__ITEMTABLE, @pBagItem.uTrans, U_TRANS, szName, 0);
	for i := 0 to MAXBAGITEM - 1 do
	begin
		if (pBagItem.Bags[i].MakeIndex > 0) then
		begin
			SaveUserItem(@__ITEMTABLE, @pBagItem.Bags[i], U_BAG, szName , i);
//			if (not SaveUserItem(@__ITEMTABLE, @pBagItem.Bags[i], U_BAG, szName))
//				Exit;
		end;
	end;
	Result := TRUE;
end;

function TFDBSql.SaveSaveItem(pSaveItem: PTSaveItem; szName: string): Boolean;
var
  szQuery: AnsiString;
  i: integer;
begin
  Result := FALSE;
	// TO PDS:_makesqlparam(szQuery, SQLTYPE_DELETE, @__ITEMTABLE, U_SAVE ,szName))肺
	// if (_makesqlparam(szQuery, SQLTYPE_DELETE, @__SAVEDITEMTABLE, szName))
	if (MakeSqlParam(szQuery, SQLTYPE_DELETE, @__ITEMTABLE, [AnsiString(szName) , U_SAVE])) then
	begin
    ExeCuteSQL (szQuery);
//		if ( pRec <> nil ) then
//		begin
//				fFail = true;
//		end;
	end;

	for i := 0 to MAXSAVEITEM - 1 do
	begin
		if (pSaveItem.Items[i].MakeIndex > 0) then
		begin
			// TO PDS:SaveUserItem(@__ITEMTABLE, @pSaveItem.Items[i], U_SAVE, szName);
			// SaveUserItem(@__SAVEDITEMTABLE, @pSaveItem.Items[i], U_SAVE, szName);
			SaveUserItem(@__ITEMTABLE, @pSaveItem.Items[i], U_SAVE, szName , i);
//			if (not SaveUserItem(@__SAVEDITEMTABLE, @pSaveItem.Items[i], U_SAVE, szName)) then
//				Result := false;
		end;
	end;
	Result := TRUE;
end;

function TFDBSql.SaveUseMagic(pUseMagic: PTUseMagic; szName: string): Boolean;
var
  szQuery: AnsiString;
  MagicFields: TMAGICFIELDS;
  i: integer;
begin
  Result := FALSE;
	if makesqlparam(szQuery, SQLTYPE_DELETE, @__MAGICTABLE, [AnsiString(szName)]) then
	begin
    ExeCuteSQL (szQuery);
//		if ( pRec <> nil ) then
//		begin
//				fFail := true;
//		end;
	end;

	for i := 0 to MAXUSERMAGIC - 1 do
	begin
		if (pUseMagic.Magics[i].MagicId > 0) then
		begin
			_StrucToFieldsUseMagic(@MagicFields, @pUseMagic.Magics[i], szName , i);
			UpdateRecord(@__MAGICTABLE, @MagicFields, true);
		end;
	end;
	Result := TRUE;
end;

function TFDBSql.SaveQuest(lptHuman: PTHuman; szName: string): Boolean;
var
  szQuery: AnsiString;
  QuestFields: TQUESTFIELDS;
begin
	ZeroMemory(@QuestFields, sizeof(TQUESTFIELDS));

  StrPCopy( QuestFields.fld_questopenindex,
    EncodeBuffer( @lptHuman.QuestOpenIndex, sizeof(lptHuman.QuestOpenIndex) ) );
  StrPCopy( QuestFields.fld_questfinindex,
    EncodeBuffer( @lptHuman.QuestFinIndex, sizeof(lptHuman.QuestFinIndex) ) );
  StrPCopy( QuestFields.fld_quest,
    EncodeBuffer( @lptHuman.Quest, sizeof(lptHuman.Quest) ) );

	strcopy(QuestFields.fld_character, PAnsiChar(AnsiString(szName)));

	MakeSql(szQuery, SQLTYPE_UPDATE, @__QUESTTABLE, @QuestFields);
  //SetLog( 0, szQuery );
	if ( ExeCuteSQL (szQuery) > 0 ) then
	begin
		Result := TRUE;
	end;
	//m_TransLog.Log ( szQuery, true );   e
	Result := FALSE;
end;

function TFDBSql.LoadQuest(lptHuman: PTHuman; szName: string): Boolean;
var
  szQuery: AnsiString;
  QuestFields: TQUESTFIELDS;
begin
  Result := FALSE;

	MakeSqlParam(szQuery, SQLTYPE_SELECTWHERE, @__QUESTTABLE, [AnsiString(szName)]);
  //SetLog( 0, szQuery );
  OpenQuery( szQuery );

  if ( FADOQuery.RecordCount > 0 ) then
  begin
    _GetFields(SqlDB, @__QUESTTABLE, @QuestFields);

    if (strlen(QuestFields.fld_questopenindex) > 0) then
      DecodeBuffer(QuestFields.fld_questopenindex, @lptHuman.QuestOpenIndex, sizeof(lptHuman.QuestOpenIndex));
    if (strlen(QuestFields.fld_questfinindex) > 0) then
      DecodeBuffer(QuestFields.fld_questfinindex, @lptHuman.QuestFinIndex, sizeof(lptHuman.QuestFinIndex));
    if (strlen(QuestFields.fld_quest) > 0) then
      DecodeBuffer(QuestFields.fld_quest, @lptHuman.Quest, sizeof(lptHuman.Quest));
  end;

	FADOQuery.Close;
	Result := TRUE;
end;

end.
