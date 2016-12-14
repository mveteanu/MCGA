CONST
  CMS1DataPortOffset = $00;  { CM/S 1-6  Data port.             Write Only. }
  CMS1AddrPortOffset = $01;  { CM/S 1-6  Address port.          Write Only. }
  CMS2DataPortOffset = $02;  { CM/S 7-12 Data port.             Write Only. }
  CMS2AddrPortOffset = $03;  { CM/S 7-12 Address port.          Write Only. }

  MixAddrPortOffset  = $04;  { Mixer register port.             Write Only. }
  MixDataPortOffset  = $05;  { Mixer data port.                 Read/Write. }

  FMStatPortOffset   = $08;  { Mono FM Status port.             Read  Only. }
  FMAddrPortOffset   = $08;  { Mono FM Address port.            Write Only. }
  FMDataPortOffset   = $09;  { Mono FM Data port.               Write Only. }

  LFMStatPortOffset  = $00;  { Left FM Status port.             Read  Only. }
  LFMAddrPortOffset  = $00;  { Left FM Address port.            Write Only. }
  LFMDataPortOffset  = $01;  { Left FM Data port.               Write Only. }

  RFMStatPortOffset  = $02;  { Right FM Status port.            Read  Only. }
  RFMAddrPortOffset  = $02;  { Right FM Address port.           Write Only. }
  RFMDataPortOffset  = $03;  { Right FM Data port.              Write Only. }

  DSPResetPortOffset = $06;  { DSP Reset port.                  Write Only. }
  DSPReadPortOffset  = $0A;  { DSP Read data port.              Read  Only. }
  DSPLifePortOffset  = $0A;  { DSP Read data port.              Read  Only. }
  DSPWStatPortOffset = $0C;  { DSP Write buffer status port.    Write Only. }
  DSPWritePortOffset = $0C;  { DSP Write data port.             Write Only. }
  DSPRStatPortOffset = $0E;  { DSP Read buffer status port.     Read  Only. }
  DSP8AckPortOffset  = $0E;  {  8 bit DMA IRQ Acknowledge port. Write Only. }
  DSP16AckPortOffset = $0F;  { 16 bit DMA IRQ Acknowledge port. Write Only. }

  CDDataPortOffset   = $10;  { CD-ROM Data port.                Read  Only. }
  CDCmdPortOffset    = $10;  { CD-ROM Command port.             Write Only. }
  CDStatPortOffset   = $11;  { CD-ROM Status port.              Read  Only. }
  CDResetPortOffset  = $12;  { CD-ROM Reset port.               Write Only. }
  CDEnablePortOffset = $13;  { CD-ROM Enable port.              Write Only. }


{ I/O Ports. Same as above. }

CONST
  CMS1DataPort : WORD    = $220 + CMS1DataPortOffset;
  CMS1AddrPort : WORD    = $220 + CMS1AddrPortOffset;
  CMS2DataPort : WORD    = $220 + CMS2DataPortOffset;
  CMS2AddrPort : WORD    = $220 + CMS2AddrPortOffset;

  MixAddrPort  : WORD    = $220 + MixAddrPortOffset;
  MixDataPort  : WORD    = $220 + MixDataPortOffset;

  FMStatPort   : WORD    = $220 + FMStatPortOffset;
  FMAddrPort   : WORD    = $220 + FMAddrPortOffset;
  FMDataPort   : WORD    = $220 + FMDataPortOffset;

  LFMStatPort  : WORD    = $220 + LFMStatPortOffset;
  LFMAddrPort  : WORD    = $220 + LFMAddrPortOffset;
  LFMDataPort  : WORD    = $220 + LFMDataPortOffset;

  RFMStatPort  : WORD    = $220 + RFMStatPortOffset;
  RFMAddrPort  : WORD    = $220 + RFMAddrPortOffset;
  RFMDataPort  : WORD    = $220 + RFMDataPortOffset;

  DSPResetPort : WORD    = $220 + DSPResetPortOffset;
  DSPReadPort  : WORD    = $220 + DSPReadPortOffset;
  DSPLifePort  : WORD    = $220 + DSPLifePortOffset;
  DSPWStatPort : WORD    = $220 + DSPWStatPortOffset;
  DSPWritePort : WORD    = $220 + DSPWritePortOffset;
  DSPRStatPort : WORD    = $220 + DSPRStatPortOffset;
  DSP8AckPort  : WORD    = $220 + DSP8AckPortOffset;
  DSP16AckPort : WORD    = $220 + DSP16AckPortOffset;

  CDDataPort   : WORD    = $220 + CDDataPortOffset;
  CDCmdPort    : WORD    = $220 + CDCmdPortOffset;
  CDStatPort   : WORD    = $220 + CDStatPortOffset;
  CDResetPort  : WORD    = $220 + CDResetPortOffset;
  CDEnablePort : WORD    = $220 + CDEnablePortOffset;


{ Configuration. }

CONST
  SbPort       : WORD    = $FFFF; { Base port. $FFFF Means Autodetect.      }
  SbIrq        : WORD    = 7;     { DMA IRQ level.                          }
  SbDMAChan    : WORD    = 1;     { DMA channel.                            }
  SbDefTimeout : WORD    = 5000;  { Default DSP timeout.                    }
  SbHiSpeed    : BOOLEAN = TRUE;  { User Desires HS DMA mode if TRUE.       }
  SbForce      : BOOLEAN = FALSE; { Force TRUE the detection of the SB.     }
  MixerForce   : BOOLEAN = FALSE; { Force TRUE the detection of the Mixer.  }
  SbProForce   : BOOLEAN = FALSE; { Force TRUE the detection of the SB Pro. }
  Sb16Force    : BOOLEAN = FALSE; { Force TRUE the detection of the SB 16.  }


{ Card information. }

CONST
  SbVersionMin : BYTE       = 0;
  SbVersionMaj : BYTE       = 0;
  SbVersionStr : STRING[ 5] = '';
  SbCopyright  : STRING[80] = '';
  SbResponse1  : BYTE       = 0;
  SbResponse2  : BYTE       = 0;

VAR
  SbVersion    : WORD    ABSOLUTE SbVersionMin;


{ Run-time information. }

CONST
  SbRegDetected     : BOOLEAN = FALSE;
  SbRegInited       : BOOLEAN = FALSE;
  SbProDetected     : BOOLEAN = FALSE;
  SbProInited       : BOOLEAN = FALSE;
  Sb16Detected      : BOOLEAN = FALSE;
  Sb16Inited        : BOOLEAN = FALSE;
  MixerDetected     : BOOLEAN = FALSE;

  SbWorksOk         : BOOLEAN = TRUE;  { Set to FALSE if DSP timeouts.         }
  HSBlockSpecified  : WORD    = 0;     { Set to the last hi-speed block size.  }
  Sb16BlockSpecified: WORD    = 0;     { Set to the last Sb 16 block size.     }
  SbStereo          : BOOLEAN = FALSE; { Stereo DMA mode if TRUE.              }
  SbFilter          : BOOLEAN = FALSE; { SB Pro output filter ON if TRUE.      }

  DoHiSpeed         : BOOLEAN = FALSE; { Hi speed DMA mode if TRUE.            }
  Sb16Bit           : BOOLEAN = FALSE; { 16 bit output if TRUE.                }

  TimeConst         : BYTE    = 0;

  DMAStart          : BOOLEAN = FALSE;
  DMAStop           : BOOLEAN = FALSE;
  DMAStopped        : BOOLEAN = FALSE;

  DMAIrqWatch       : BYTE    = 0;



{ DSP Commands. }

CONST
  sdcSendOneSample  = $10;  { Send a sample to the DAC directly (mono mode only). }
  sdcStartLSpeedDMA = $14;  { Start a low-speed DMA transfer.                     }
  sdcSetTimeConst   = $40;  { Set the time constant.                              }
  sdcSetHSpeedSize  = $48;  { Set hi-speed DMA transfer length.                   }
  sdcStartHSpeedDMA = $91;  { Start a hi-speed DMA transfer.                      }
  sdcTurnOnSpeaker  = $D1;  { Turn on the SB speaker.                             }
  sdcTurnOffSpeaker = $D3;  { Turn off the SB speaker.                            }
  sdcGetDSPVersion  = $E1;  { Get the DSP version number.                         }
  sdcGetCopyright   = $E3;  { Get the card copyright string.                      }


{ Mixer registers. }

CONST
  mxrDataReset    = $00;
  mxrDACVolume    = $04;
  mxrMicMixing    = $0A;
  mxrInSetting    = $0C;
  mxrOutSetting   = $0E;
  mxrMasterVolume = $22;
  mxrFMVolume     = $26;
  mxrCDVolume     = $28;
  mxrLineVolume   = $2E;


{ Bit masks for the mixer registers. }

CONST
  mxiFilterVal = $38;
  mxiADCVal    = $06;
  mxoFilterNeg = $20;
  mxoStereoOn  = $02;

TYPE
  TMixerVolume = (mvMaster,
                  mvVoice,
                  mvFM,
                  mvLine,
                  mvMicrophone,
                  mvSpeaker,
                  mvCD);

CONST
  SbProRegs : ARRAY[mvMaster..mvCD] OF BYTE = ( $22, $04, $26, $2E, $0A, $00, $28 );
  Sb16Regs  : ARRAY[mvMaster..mvCD] OF BYTE = ( $30, $32, $34, $38, $3A, $3B, $34 );

