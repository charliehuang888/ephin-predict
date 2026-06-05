
print,'Plot program for SOHO/COSTEP binned data'
yearstr='2008'                            ;*****
tage=366.                                 ;*****
finamp=findfile('/Users/aposner/Documents/Kiel_data/archived/bin/l2bin_p_n'+yearstr+'*.asc',count=pnum)
finamhe=findfile('/Users/aposner/Documents/Kiel_data/archived/bin/l2bin_he_n'+yearstr+'*.asc',count=henum)
finame=findfile('/Users/aposner/Documents/Kiel_data/archived/bin/l2binz_e_'+yearstr+'*.asc',count=henum)

;***********************status,deadtime*****************************************
ttt=1440.*tage

stat=dblarr(ttt)
namest='/Users/aposner/Documents/Kiel_data/archived/hires/estat_n'+yearstr+'.asc'
openr,3,namest
readf,3,stat
CLOSE, /ALL


namedt='/Users/aposner/Documents/Kiel_data/archived/hires/edead_n'+yearstr+'.asc'   ;*****
agrel=dblarr(ttt)&corfac=dblarr(ttt)&crit=dblarr(ttt)

openr,3,namedt
readf,3,corfac,crit,agrel
CLOSE, /ALL

;**********************HELIUM************************************
;tage=366.                                  ;*****
;tmn=1440.*tage
;yearstr='2002'                             ;*****
;begh=10.                             ;*****
;*********************specify*********************************************
;monthstr='9'                             ;*****
;dayofmonthbeg=24.                             ;*****
;dayofmonthend=26.                             ;*****
;dombeg=dayofmonthbeg-1
;domend=dayofmonthend-1
;montha=9                             ;*****
;monthb=9                             ;*****
;*************************************************************************
mstrarr=[' ','01','02','03','04','05','06','07','08','09','10','11','12']
houname=['0h',' ','4h',' ','8h',' ','12h',' ','16h',' ','20h',' ','0h']
mname=['    Jan.','    Feb.','    Mar.','    Apr.','    May','    Jun.',$
'    Jul.','    Aug.','    Sept.','    Oct.','    Nov.','    Dec.',' ']
;mnstr=mname(montha-1)
montharrny=[0.,31.,59.,90.,120.,151.,181.,212.,243.,273.,304.,334.,365.]
montharrsy=[0.,31.,60.,91.,121.,152.,182.,213.,244.,274.,305.,335.,366.]
;tbeg=montharrsy(montha-1)+dombeg                             ;*****
CLOSE, /ALL
enl_arr=fltarr(30)
enh_arr=fltarr(30)
wid_arr=fltarr(30)
FOR a=0.,29. DO BEGIN
 enl_arr(a)=10^(-1.+a/10.)
 enh_arr(a)=10^(-1.+(a+1.)/10.)
 wid_arr(a)=enh_arr(a)-enl_arr(a)
 ENDFOR
FOR opener=0,pnum-1 DO BEGIN 
 yrstr=STRMID(finamp(opener),57,4)    ;sensitive to file tree and name change
 doystr=STRMID(finamp(opener),62,3)
 namep=yrstr+'_'+doystr
 print,namep
 f_square=dblarr(720,22)
 g_square=dblarr(720,22)
 h_square=dblarr(720,22)
 f_squ_he=dblarr(720,22)
 g_squ_he=dblarr(720,22)
 h_squ_he=dblarr(720,22)
 rel_squ=fltarr(720,22)
 relpl_squ=fltarr(720,22)
 e_square=dblarr(1440,17)
 ;************************************plot*********************************
 ;print,tbeg
 set_plot,'ps'
 device,/close
 device,filename='/Users/aposner/Documents/Kiel_data/archived/plots/binstat4_all_n'+namep+'.ps',$
 xoffset=2.3,yoffset=1.5,xsize=16.8,ysize=26.,/color,bits=8     ;**********
 loadct,39
 !p.thick=3.0
 !p.font = 0
 !p.multi=[0,1,10]
 ;!p.noerase=5
 !p.charsize=2.5
 !x.ticks=12
 !x.minor=6
 ;!x.ticklen=0.05
 DEVICE,/TIMES
;xrange:
;xmin=tbeg+10./24.      ;*****
;xmax=tbeg+18./24.      ;*****
;tbegmin=xmin*1440.


 colpha=[255,75,130]
 hi=255
 med=75
 lo=130
 xx=dblarr(2)&yy=dblarr(2)
 var=dblarr(18)

 ;***************electron template*************************
 ;plot_io,xx,yy,position=[0.15,0.5,0.85,0.7],xstyle=1,ystyle=1,$
 ;xrange=[xmin,xmax],yrange=[0.25,10.4],$
 ;xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$
                                ;psym=3,ytitle= 'electron PHAs !C E
 ;[MeV]',/nodata       ;*****n/s**** 


 ;***************alpha/proton template *************************
 ;plot_io,xx,yy,position=[0.15,0.7,0.82,0.9],xstyle=1,ystyle=1,$
 ;xrange=[xmin,xmax],yrange=[0.01,2],$
 ;xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$
 ;psym=3,ytitle= 'He/p ratio',/nodata       ;*****n/s**** 
 ;FOR a=0.,tmn-1. DO BEGIN
 ; xx(0)=timer(a)
 ; xx(1)=timer(a)
 ; IF p4(a) GT 0 THEN BEGIN
 ;  yy(0)=h4(a)/p4(a)
 ;  yy(1)=h4(a)/p4(a)
 ;  IF yy(0) NE 0. THEN BEGIN
 ;   oplot,xx,yy,PSYM=3,color=hi
 ;  ENDIF
 ; ENDIF
 ; IF p8(a) GT 0 THEN BEGIN
 ;  yy(0)=h8(a)/p8(a)
 ;  yy(1)=h8(a)/p8(a)
 ;  IF yy(0) NE 0. THEN BEGIN
 ;   oplot,xx,yy,PSYM=3,color=med
 ;  ENDIF
 ; ENDIF
 ; IF p25(a) GT 0 THEN BEGIN
 ;  yy(0)=h25(a)/p25(a)
 ;  yy(1)=h25(a)/p25(a)
 ;  IF yy(0) NE 0. THEN BEGIN
 ;   oplot,xx,yy,PSYM=3,color=lo
 ;  ENDIF
 ; ENDIF
 ;ENDFOR

 ;FOR a=0.,tmn-2. DO BEGIN
 ; xx(0)=timer(a)
 ; xx(1)=timer(a+1.)
 ; IF p4(a) GT 0 AND p4(a+1.) GT 0 THEN BEGIN
 ;  yy(0)=h4(a)/p4(a)
 ;  yy(1)=h4(a+1.)/p4(a+1.)
 ;  IF yy(0) NE 0. AND yy(1) NE 0. THEN BEGIN
 ;   oplot,xx,yy,PSYM=0,color=hi
 ;  ENDIF
 ; ENDIF
 ; IF p8(a) GT 0 AND p8(a+1.) GT 0 THEN BEGIN
 ;  yy(0)=h8(a)/p8(a)
 ;  yy(1)=h8(a+1.)/p8(a+1.)
 ;  IF yy(0) NE 0. AND yy(1) NE 0. THEN BEGIN
 ;   oplot,xx,yy,PSYM=0,color=med
 ;  ENDIF
 ; ENDIF
 ; IF p25(a) GT 0 AND p25(a+1.) GT 0 THEN BEGIN
 ;  yy(0)=h25(a)/p25(a)
 ;  yy(1)=h25(a+1.)/p25(a+1.)
 ;  IF yy(0) NE 0. AND yy(1) NE 0. THEN BEGIN
 ;   oplot,xx,yy,PSYM=0,color=lo
 ;  ENDIF
 ; ENDIF
 ;ENDFOR
 xxx=dblarr(4)
 yyy=dblarr(4)
 ;10:48-11:01 p25
 ;***************square filling template****************
 ;xxx(0)=tbeg+6./24.+0./60./24.&xxx(3)=xxx(0)
 ;xxx(1)=tbeg+6./24.+6./60./24.&xxx(2)=xxx(1)
 ;yyy(0)=0.1&yyy(1)=yyy(0)
 ;yyy(2)=0.15&yyy(3)=yyy(2)
 ;polyfill,xxx,yyy,color=0

 ;**************channel annotations template****************
 ;xyouts,xmin+0.7*(xmax-xmin),1./2.,'4-8 MeV/n',$
 ;charsize=0.9,/data,color=hi,alignment=0.
 ;xyouts,xmin+0.7*(xmax-xmin),1./4.,'8-25 MeV/n',$
 ;charsize=0.9,/data,color=med,alignment=0.
 ;xyouts,xmin+0.7*(xmax-xmin),1./8.,'25-53 MeV/n',$
 ;charsize=0.9,/data,color=lo,alignment=0.
 ;xyouts,xmin+0.03*(xmax-xmin),0.1,'Dispersion Curve',$
 ;charsize=0.9,/data,color=0,alignment=0.

 ;*************************************************************************
 ;read in routine

 openr,3,finamp(opener)
 entry=dblarr(22)
 header=' '
 FOR a=0,4 DO BEGIN
  ;readf,3,header
 ENDFOR
 entry=fltarr(22)
 FOR a=0.,720.-1. DO BEGIN
  readf,3,entry
  FOR b=0,21 DO BEGIN
   f_square(a,b)=entry(b)
  ENDFOR
 ENDFOR
 close,3

 openr,3,finamhe(opener)
 entry=dblarr(22)
 ;header=' '
 FOR a=0,4 DO BEGIN
  ;readf,3,header
 ENDFOR
 entry=fltarr(22)
 FOR a=0.,720.-1. DO BEGIN
  readf,3,entry
  FOR b=0,21 DO BEGIN
   f_squ_he(a,b)=entry(b)
  ENDFOR
 ENDFOR
 close,3

 openr,3,finame(opener)
 entry=dblarr(17)
 header=' '
 FOR a=0,4 DO BEGIN
  ;readf,3,header
 ENDFOR
 entry=fltarr(17)
 FOR a=0.,1440.-1. DO BEGIN
  readf,3,entry
  FOR b=0,16 DO BEGIN
   e_square(a,b)=entry(b)
  ENDFOR
 ENDFOR

 vx=dblarr(4)&vy=dblarr(4)

 ;ct_squ_p=intarr(240,22)
 ;ct_squ_he=intarr(240,22)

 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   rel_squ(tt,ee)=f_squ_he(tt,ee)/(f_square(tt,ee)+1.0e-06)
   ;IF rel_squ(tt,ee) LT 0.01 THEN rel_squ(tt,ee)=0.01
  ENDFOR
 ENDFOR

 relpl_squ=(alog10(rel_squ)+2.)*254./3. ;relative values log 0.01-10

 ;print,max(f_squ_he)
 ;print,max(g_squ_he)

 h_square=FIX((alog10(f_square)+6.)*254/8.)  ;10^-6 up to 10^2
 h_squ_he=FIX((alog10(f_squ_he)+6.)*254/8.)
 h_squ_e=FIX((alog10(e_square)+3.)*254/8.)   ;10^-3 up to 10^4

 plot_io,xx,yy,yrange=[0.14,8.2],xrange=[0,1440],xstyle=1,ystyle=1,$
 PSYM=0,position=[0.15,0.7,0.82,0.9],/nodata,xticklen=-0.02,yticklen=-0.02,$
 xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$ 
 ytitle='electrons [MeV]',title='SOHO/COSTEP DOY '+doystr+', '+yrstr

 FOR tt=0.,1439. DO BEGIN
  FOR ee=0.,16. DO BEGIN
   vx(0)=tt
   vx(1)=vx(0)
   vx(2)=tt+1
   vx(3)=vx(2) 

   vy(0)=enl_arr(ee+2)
   ;print,vy(0)
   vy(2)=enh_arr(ee+2)
   vy(1)=vy(2)
   vy(3)=vy(0)
   IF h_squ_e(tt,ee) GT 254 THEN h_squ_e(tt,ee)=254   ;exclude largest values (bad stats)   
   IF h_squ_e(tt,ee) LT 0 THEN h_squ_e(tt,ee)=255
   polyfill,vx,vy,color=h_squ_e(tt,ee),/data
  ENDFOR
 ENDFOR

 plot,xx,yy,/nodata,xstyle=5,ystyle=5,xrange=[0,1],yrange=[0,1],$
 position=[0.82,0.7,0.97,0.9],xtickname=[' ',' '],xtitle='DOY $
 ytickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']

 FOR vs=0.,254. DO BEGIN
  vx(0)=0.1
  vx(1)=vx(0)
  vx(2)=0.3
  ;IF vs EQ 4 OR vs EQ 18 OR vs EQ 30 THEN vx(2)=begm+domend+0.13
  vx(3)=vx(2)
  vy(0)=0.8*(vs+1.)/255.
  vy(2)=0.8*(vs+2.)/255.
  vy(1)=vy(2)
  vy(3)=vy(0)
  polyfill,vx,vy,color=vs,/data
 ENDFOR
 xyouts,0.4,0.-0.02,'10!A-3!N',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8/4.-0.02,'10!A-1!N',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8*2./4.-0.02,'10',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8*3./4.-0.02,'10!A3!N',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8-0.02,'10!A5!N',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.05,0.88,'[cm!A2!N s sr MeV]!A-1!N',/data,color=0,alignment=0.,$
 charsize=0.7
 xx(0)=0.3&xx(1)=0.35
 yy(0)=0.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8/4.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8*2./4.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8*3./4.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0


 plot_io,xx,yy,yrange=[3.8,53],xrange=[0,720],xstyle=1,ystyle=1,$
 PSYM=0,position=[0.15,0.5,0.82,0.7],/nodata,xticklen=-0.02,yticklen=-0.02,$
 xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$ 
 ytitle='protons [MeV]'

 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   vx(0)=tt
   vx(1)=vx(0)
   vx(2)=tt+1
   vx(3)=vx(2) 

   vy(0)=10.^(0.6+ee*0.05)
   ;print,vy(0)
   vy(2)=10.^(0.6+(ee+1.)*0.05)
   vy(1)=vy(2)
   vy(3)=vy(0)
   IF h_square(tt,ee) GT 254 THEN h_square(tt,ee)=254   
   IF h_square(tt,ee) LT 0 THEN h_square(tt,ee)=0
   polyfill,vx,vy,color=h_square(tt,ee),/data
  ENDFOR
 ENDFOR


 plot,xx,yy,/nodata,xstyle=5,ystyle=5,xrange=[0,1],yrange=[0,1],$
 position=[0.82,0.5,0.97,0.7],xtickname=[' ',' '],xtitle='DOY $
 ytickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']

 FOR vs=0.,254. DO BEGIN
  vx(0)=0.1
  vx(1)=vx(0)
  vx(2)=0.3
  ;IF vs EQ 4 OR vs EQ 18 OR vs EQ 30 THEN vx(2)=begm+domend+0.13
  vx(3)=vx(2)
  vy(0)=0.8*(vs+1.)/255.
  vy(2)=0.8*(vs+2.)/255.
  vy(1)=vy(2)
  vy(3)=vy(0)
  polyfill,vx,vy,color=vs,/data
 ENDFOR
 xyouts,0.4,0.-0.02,'10!A-6!N',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8/4.-0.02,'10!A-4!N',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8*2./4.-0.02,'0.01',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8*3./4.-0.02,'1',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8-0.02,'100',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.05,0.85,'[cm!A2!N s sr MeV]!A-1!N',/data,color=0,alignment=0.,$
 charsize=0.7
 xx(0)=0.3&xx(1)=0.35
 yy(0)=0.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8/4.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8*2./4.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8*3./4.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0

 plot_io,xx,yy,yrange=[3.8,53],xrange=[0,720],xstyle=1,ystyle=1,$
 PSYM=0,position=[0.15,0.3,0.82,0.5],/nodata,xticklen=-0.02,yticklen=-0.02,$
 xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$ 
 ytitle='helium [MeV/n]' 

 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   vx(0)=tt
   vx(1)=vx(0)
   vx(2)=tt+1
   vx(3)=vx(2)

   vy(0)=10.^(0.6+ee*0.05)
   ;print,vy(0)
   vy(2)=10.^(0.6+(ee+1.)*0.05)
   vy(1)=vy(2)
   vy(3)=vy(0)
   IF h_squ_he(tt,ee) LT 0 THEN h_squ_he(tt,ee)=0.
   IF h_squ_he(tt,ee) GT 254 THEN h_squ_he(tt,ee)=254   
   polyfill,vx,vy,color=h_squ_he(tt,ee),/data
  ENDFOR
 ENDFOR

 plot,xx,yy,/nodata,xstyle=5,ystyle=5,xrange=[0,1],yrange=[0,1],$
 position=[0.82,0.3,0.97,0.5],xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$
 ytickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '] 

 FOR vs=0.,254. DO BEGIN
   vx(0)=0.1
   vx(1)=vx(0)
   vx(2)=0.3
   ;IF vs EQ 4 OR vs EQ 18 OR vs EQ 30 THEN vx(2)=begm+domend+0.13
   vx(3)=vx(2)
   vy(0)=0.8*(vs+1.)/255.
   vy(2)=0.8*(vs+2.)/255.
   vy(1)=vy(2)
   vy(3)=vy(0)
   polyfill,vx,vy,color=vs,/data
  ENDFOR
  xyouts,0.4,0.-0.02,'10!A-6!N',/data,color=0,alignment=0.,charsize=0.9
  xyouts,0.4,0.8/4.-0.02,'10!A-4!N',/data,color=0,alignment=0.,charsize=0.9
  xyouts,0.4,0.8*2./4.-0.02,'0.01',/data,color=0,alignment=0.,charsize=0.9
  xyouts,0.4,0.8*3./4.-0.02,'1',/data,color=0,alignment=0.,charsize=0.9
  xyouts,0.4,0.8-0.02,'100',/data,color=0,alignment=0.,charsize=0.9
  xyouts,0.05,0.85,'[cm!A2!N s sr MeV/n]!A-1!N',/data,color=0,alignment=0.,$
  charsize=0.7
  xx(0)=0.3&xx(1)=0.35
  yy(0)=0.&yy(1)=yy(0)
  oplot,xx,yy,PSYM=0,color=0
  yy(0)=0.8/4.&yy(1)=yy(0)
  oplot,xx,yy,PSYM=0,color=0
  yy(0)=0.8*2./4.&yy(1)=yy(0)
  oplot,xx,yy,PSYM=0,color=0
  yy(0)=0.8*3./4.&yy(1)=yy(0)
  oplot,xx,yy,PSYM=0,color=0
  yy(0)=0.8&yy(1)=yy(0)
  oplot,xx,yy,PSYM=0,color=0



 plot_io,xx,yy,yrange=[3.8,53],xrange=[0,720],xstyle=1,ystyle=1,$
 PSYM=0,position=[0.15,0.1,0.82,0.3],/nodata,xticklen=-0.02,yticklen=-0.02,$
 xtitle=' ',xtickname=houname,$ 
 ytitle='He/p ratio [MeV/n]'


 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   vx(0)=tt
   vx(1)=vx(0)
   vx(2)=tt+1
   vx(3)=vx(2)

   vy(0)=10.^(0.6+ee*0.05)
   ;print,vy(0)
   vy(2)=10.^(0.6+(ee+1.)*0.05)
   vy(1)=vy(2)
   vy(3)=vy(0)
   IF relpl_squ(tt,ee) GT 254 THEN relpl_squ(tt,ee)=254
   IF relpl_squ(tt,ee) LT 1 THEN relpl_squ(tt,ee)=255
   IF rel_squ(tt,ee) LT 0.01 AND f_square(tt,ee) GT 0. THEN relpl_squ(tt,ee)=0
   polyfill,vx,vy,color=relpl_squ(tt,ee),/data
  ENDFOR
 ENDFOR


 plot,xx,yy,/nodata,xstyle=5,ystyle=5,xrange=[0,1],yrange=[0,1],$
 position=[0.82,0.1,0.97,0.3],xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$
 ytickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']

 FOR vs=0.,254. DO BEGIN
  vx(0)=0.1
  vx(1)=vx(0)
  vx(2)=0.3
  ;IF vs EQ 4 OR vs EQ 18 OR vs EQ 30 THEN vx(2)=begm+domend+0.13
  vx(3)=vx(2)
  vy(0)=0.8*(vs+1.)/255.
  vy(2)=0.8*(vs+2.)/255.
  vy(1)=vy(2)
  vy(3)=vy(0)
  polyfill,vx,vy,color=vs,/data
 ENDFOR
 xyouts,0.4,0.-0.02,'0.01',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8/3.-0.02,'0.1',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8*2./3.-0.02,'1',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.4,0.8-0.02,'10',/data,color=0,alignment=0.,charsize=0.9
 xyouts,0.3,0.85,'He/p',/data,color=0,alignment=0.5,$
 charsize=0.8
 xx(0)=0.3&xx(1)=0.35
 yy(0)=0.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8/3.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8*2./3.&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
 yy(0)=0.8&yy(1)=yy(0)
 oplot,xx,yy,PSYM=0,color=0
;******************polyfill for ring off***********************************
 dayfl=FIX(STRCOMPRESS(STRMID(finamp(opener),62,3),/remove_all))*1. 
 plot,corfac,crit,position=[0.15,0.9,0.82,0.91],xstyle=5,ystyle=5,$
 xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],$
 xrange=[dayfl-1.,dayfl],yrange=[0,1],xticks=1,xthick=1.5,/nodata
 vx=fltarr(4)&vy=fltarr(4)
 vy(0)=0.&vy(1)=0.&vy(2)=1.&vy(3)=1.
 FOR a=(dayfl-1.)*1440.,dayfl*1440.-1. DO BEGIN
  IF crit(a) EQ 0 AND stat(a) GE 2 THEN BEGIN   ;ring off
   vx(0)=a/1440.&vx(3)=vx(0)
   vx(1)=(a+1.)/1440.&vx(2)=vx(1)
   IF vx(0) GT dayfl-1. AND vx(1) LT dayfl THEN BEGIN
    polyfill,vx,vy,color=205
   ENDIF
  ENDIF
  IF crit(a) EQ 1. THEN BEGIN
   vx(0)=a/1440.&vx(3)=vx(0)
   vx(1)=(a+1.)/1440.&vx(2)=vx(1)
   IF vx(0) GT dayfl-1. AND vx(1) LT dayfl THEN BEGIN
    polyfill,vx,vy,color=225
   ENDIF
  ENDIF
 ENDFOR
 device,/close
 close,3
ENDFOR

end

