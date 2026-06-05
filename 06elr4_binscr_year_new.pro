;pro elr4_binscr_year_new
dayin=43
yds=365.                                 ;*****

;**********************YEAR************************************
print,dayin
tage=365.                                 ;*****
tmn=1440.*tage
;yearstr=''                              ;*****
;ynamestr='i07'                            ;h95 ... i10
close,/all
;*******************electron simulation results************************
;filelistela=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/el_matrix/ela0*.dat',count=elct)
;print,"filenames",filelistela
namee150='/Users/aposner/Documents/Kiel_data/archived/el_matrix/ela101.dat'
openr,3,namee150
opener=0
;openr,3,filelistela(opener)
e150_m=fltarr(30,30)
e150_g=fltarr(30)
e150_i=fltarr(30)
FOR a=0,29 DO BEGIN
 FOR b=0,29 DO BEGIN
  readf,3,inp
  e150_m(a,b)=inp
  e150_g(a)=e150_g(a)+inp           ;sum observed gfs
  IF inp GT 0 THEN print,a,b,inp
 ENDFOR
ENDFOR
close,3
FOR a=0,29 DO BEGIN
 FOR b=0,29 DO BEGIN
  e150_i(a)=e150_i(a)+e150_m(b,a)   ;sum injected gfs
 ENDFOR
ENDFOR 

namee300='/Users/aposner/Documents/Kiel_data/archived/el_matrix/ela102.dat'
openr,3,namee300
e300_m=fltarr(30,30)
e300_g=fltarr(30)
e300_i=fltarr(30)
FOR a=0,29 DO BEGIN
 FOR b=0,29 DO BEGIN
  readf,3,inp
  e300_m(a,b)=inp
  e300_g(a)=e300_g(a)+inp           ;sum observed gfs
 ENDFOR
ENDFOR
close,3
FOR a=0,29 DO BEGIN
 FOR b=0,29 DO BEGIN
  e300_i(a)=e300_i(a)+e300_m(b,a)  ;sum injected gfs
 ENDFOR
ENDFOR 

namee1300='/Users/aposner/Documents/Kiel_data/archived/el_matrix/ela103.dat'
openr,3,namee1300
e1300_m=fltarr(30,30)
e1300_g=fltarr(30)
FOR a=0,29 DO BEGIN
 FOR b=0,29 DO BEGIN
  readf,3,inp
  e1300_m(a,b)=inp
  e1300_g(a)=e1300_g(a)+inp
 ENDFOR
ENDFOR
close,3

namee3000='/Users/aposner/Documents/Kiel_data/archived/el_matrix/ela104.dat'
openr,3,namee3000
e3000_m=fltarr(30,30)
e3000_g=fltarr(30)
FOR a=0,29 DO BEGIN
 FOR b=0,29 DO BEGIN
  readf,3,inp
  e3000_m(a,b)=inp
  e3000_g(a)=e3000_g(a)+inp
 ENDFOR
ENDFOR
close,3
enl_arr=fltarr(30)
enh_arr=fltarr(30)
wid_arr=fltarr(30)
FOR a=0.,29. DO BEGIN
 enl_arr(a)=10^(-1.+a/10.)
 enh_arr(a)=10^(-1.+(a+1.)/10.)
 wid_arr(a)=enh_arr(a)-enl_arr(a)
ENDFOR
numbins_15=[0.,0.,1.,3.,4.,6.,7.,8.,9.,10.,10.,12.,12.,12.,11.,12.,11.,13.,11.,$
12.,12.,10.,6.,8.,0.,0.,0.,0.,0.,0.]
numbins_30=[0.,0.,0.,0.,0.,0.,0.,2.,2.,4.,4.,5.,6.,8.,8.,9.,10.,11.,12.,13.,$
14.,12.,10.,8.,0.,0.,0.,0.,0.,0.]
;numbins_15=[0.,1.,3.,4.,5.,6.,7.,8.,9.,10.,9.,10.,8.,10.,9.,10.,9.,9.,8.,8.]
;numbins_30=[0.,0.,0.,0.,0.,1.,2.,3.,4.,5.,6.,6.,8.,9.,10.,11.,11.,13.,14.,11.]

;*********************electron countrate uncorrected*********
e150=dblarr(tmn)
yn=dblarr(tmn)
p4=dblarr(tmn)&p8=dblarr(tmn)&p25=dblarr(tmn)&h4=dblarr(tmn)
h8=dblarr(tmn)&h25=dblarr(tmn)
e300=dblarr(tmn)&e1300=dblarr(tmn)

openr,3,'/Users/aposner/Documents/Kiel_data/archived/hires/ephgeszr_n2002.asc'   ;****
readf,3,yn,e150,e300,e1300,p4,p8,p25,h4,h8,h25
CLOSE,/ALL


;*********************pha weighting for each particle*********
ele150=dblarr(tmn)
elyn=dblarr(tmn)
prop4=dblarr(tmn)&prop8=dblarr(tmn)&prop25=dblarr(tmn)&helh4=dblarr(tmn)
helh8=dblarr(tmn)&helh25=dblarr(tmn)
ele300=dblarr(tmn)&ele1300=dblarr(tmn)
ctp4=dblarr(tmn)

openr,3,'/Users/aposner/Documents/Kiel_data/archived/hires/epherr_n2002.asc'   ;****
readf,3,elyn,ele150,ele300,ele1300,prop4,prop8,prop25,helh4,helh8,helh25
CLOSE,/ALL
;********************gammas***************************
; ages=dblarr(tmn)
;openr,3,'$gammafi'
;readf,3,ages
; CLOSE,/ALL
;**************************status*****************************************
ttt=1440.*tage
stat=dblarr(ttt)
namest='/Users/aposner/Documents/Kiel_data/archived/hires/estat_n2002.asc'   ;****
openr,3,namest
readf,3,stat
CLOSE, /ALL



FOR ddd=dayin,tage DO BEGIN  ;1,tage*********************************!!!!!!!!!
 daystr=STRCOMPRESS(ddd,/remove_all)
 IF ddd LT 10 THEN daystr='00'+STRCOMPRESS(ddd,/remove_all)
 IF ddd GE 10 AND ddd LT 100 THEN daystr='0'+STRCOMPRESS(ddd,/remove_all)
 print,'Day: ',daystr

 ;*********************specify*********************************************
 ;monthstr='9'                             ;*****
 ;dayofmonthbeg=24.                             ;*****
 ;dayofmonthend=26.                             ;*****
 ;dombeg=dayofmonthbeg-1
 ;montha=9                             ;*****
 ;monthb=9                             ;*****
 ;*************************************************************************
 ;mstrarr=[' ','01','02','03','04','05','06','07','08','09','10','11','12']
 ;mname=['    Jan.','    Feb.','    Mar.','    Apr.','    May','    Jun.',$
 ;'    Jul.','    Aug.','    Sept.','    Oct.','    Nov.','    Dec.',' ']
 ;mnstr=mname(montha-1)
 ;montharrny=[0.,31.,59.,90.,120.,151.,181.,212.,243.,273.,304.,334.,365.]
 ;montharrsy=[0.,31.,60.,91.,121.,152.,182.,213.,244.,274.,305.,335.,366.]
 ;tbeg=montharrny(montha-1)+dombeg                             ;*****
 tbeg=FLOAT(ddd-1)
 ;**********************small arrays***************************************
 tm=1440. ;*diff_days
 ;*******************raster*********************************
 e_squ_g_15=fltarr(1440,30,30)
 e_squ_g_30=fltarr(1440,30,30)
 e_squ_15=fltarr(1440,30)
 e_squ_30=fltarr(1440,30) 
 ;epl_squ=dblarr(1440,17)
 print,tbeg
 xmin=tbeg     ;*****
 xmax=tbeg+1.     ;*****
 tbegmin=xmin*1440.
;********************counter***************************************
 se150s=dblarr(tm,30)   ;seen energy interval counts
 se300s=dblarr(tm,30)  
 se150t=dblarr(tm)     ;total seen energy interval counts
 se300t=dblarr(tm)

 ;*******************************************************************

 xx=dblarr(2)&yy=dblarr(2)
 var=dblarr(18)
 namepha='/Users/aposner/Documents/Kiel_data/archived/phx/epi02'+daystr+'.phx'    ;*****
 openr,3,namepha            ;***
 print,namepha
 abc=0
 WHILE abc EQ 0 DO BEGIN 
  ON_IOERROR,pbad
  readf,3,var
  ty=float(var(0))
  td=float(var(1))
  tms=float(var(2))
  zraum=(tms/1000.+(td-1.)*86400.)/60.
  ;print,zraum
  zraum=zraum-(zraum MOD 1)
  t_fill=(zraum-tbegmin)
  ;print,t_fill
  tp=zraum/60./24.
  IF tp GT xmin AND tp LT xmax THEN BEGIN
   min=var(3)
   min=min-(min MOD 1)
   coinc=var(4)
   aseg=var(5)
   bseg=var(6)
   apha=float(var(7))
   achn=var(8)
   bpha=float(var(9)) 
   bchn=var(10)
   cpha=float(var(11))
   cchn=var(12)
   dpha=float(var(13))
   dchn=var(14)
   epha=float(var(15))
   echn=var(16)
   prflag=var(17)
   IF achn EQ 0 THEN ade=3.0*apha/1023.
   IF achn NE 0 THEN ade=30.0*apha/1023.
   IF bchn EQ 0 THEN bde=3.0*bpha/1023.
   IF bchn NE 0 THEN bde=45.0*bpha/1023
   IF cchn EQ 0 THEN cde=16.07*cpha/1023.
   IF cchn NE 0 THEN cde=166.7*cpha/1023
   IF dchn EQ 0 THEN dde=20.0*dpha/1023.
   IF dchn NE 0 THEN dde=225.0*dpha/1023
   IF echn EQ 0 THEN ede=20.0*epha/1023.
   IF echn NE 0 THEN ede=225.0*epha/1023
   IF coinc EQ 3 THEN coinc=2    ;
   IF coinc EQ 7 THEN coinc=6    ;FME fuehrt zu falscher Zuordnung
   IF coinc EQ 11 THEN coinc=10  ;
   IF coinc EQ 0 or coinc EQ 4 OR coinc EQ 8 THEN dtot=ade+bde
   IF coinc EQ 1 OR coinc EQ 5 OR coinc EQ 9 THEN dtot=ade+bde+cde
   IF coinc EQ 2 OR coinc EQ 6 OR coinc EQ 10 THEN dtot=ade+bde+cde+dde+ede
   IF coinc EQ 12 THEN dtot=ade+bde+cde+dde+ede
   IF coinc EQ 0 THEN BEGIN   ;fill counters e150
    IF ade LT 0.27 THEN BEGIN
     IF achn LT 0.5 AND bchn LT 0.5 THEN BEGIN
      IF bchn+2.5*achn LT 250 THEN BEGIN 
       FOR g=0,29 DO BEGIN
        IF dtot GT enl_arr(g) AND dtot LE enh_arr(g) THEN $ 
        se150s(t_fill,g)=se150s(t_fill,g)+1.
       ENDFOR
      ENDIF
      se150t(t_fill)=se150t(t_fill)+1.
     ENDIF
    ENDIF
   ENDIF
   IF coinc EQ 1 THEN BEGIN   ;fill counters e300
    IF bde LT 2. THEN BEGIN   ;exclude protons 
     IF dtot LT 7. OR dtot GE 7. AND bde LT 1. THEN BEGIN
      IF dtot GE 7. THEN print,'B ',bde
      FOR g=0,29 DO BEGIN
       IF dtot GT enl_arr(g) AND dtot LE enh_arr(g) THEN $
       se300s(t_fill,g)=se300s(t_fill,g)+1.
      ENDFOR
     ENDIF
    ENDIF
    se300t(t_fill)=se300t(t_fill)+1.
   ENDIF 
     ;wait until day is over
  ENDIF
  IF tp GT xmax THEN abc=1
 ENDWHILE
 goto, pdone
 pbad: ON_IOERROR,NULL
 print,""
 pdone: print,""
 print,'phx 1'
 close,3
 ;ENDFOR
 ;timer=findgen(tage*1440.)/1440.+1./2880.
print,daystr
 FOR tt=0,1439 DO BEGIN
  FOR g=0,29 DO BEGIN  
   FOR t=0,29 DO BEGIN
    IF e150_g(g) GT 0 AND se150t(tt) GT 0 THEN BEGIN
     e_squ_g_15(tt,g,t)=e150_m(g,t)/e150_g(g)*se150s(tt,g)*$
     e150(tbegmin+tt)/se150t(tt)
     ;print,'m ',e150_m(g,t),' s ',se150s(tt,g),' e150 ',e150(tbegmin+tt)
    ENDIF
    IF e300_g(g) GT 0 AND se300t(tt) GT 0 THEN BEGIN
     e_squ_g_30(tt,g,t)=e300_m(g,t)/e300_g(g)*se300s(tt,g)*$
     e300(tbegmin+tt)/se300t(tt)
     ;print,'m ',e300_m(g,t),' s ',se300s(tt,g),' e300 ',e300(tbegmin+tt)
    ENDIF
   ENDFOR
   IF tt EQ 1000. THEN print,g,'15sum g ',se150s(tt,g),' e150 ',$
   60.*e150(tbegmin+tt),'phas ',se150t(tt)
   IF tt EQ 1000. THEN print,g,'30sum g ',se300s(tt,g),' e300 ',$
   60.*e300(tbegmin+tt),'phas ',se300t(tt)
  ENDFOR
 ENDFOR
 FOR tt=0,1439 DO BEGIN
  FOR t=0,29 DO BEGIN
   FOR g=0,29 DO BEGIN
    IF e150_m(g,t) GT 0 THEN BEGIN
     e_squ_15(tt,t)=e_squ_15(tt,t)+e_squ_g_15(tt,g,t)  
                                                       ;alt:/e150_m(g,t)/wid_arr(t)
    ENDIF
    IF e300_m(g,t) GT 0 THEN BEGIN
     e_squ_30(tt,t)=e_squ_30(tt,t)+e_squ_g_30(tt,g,t)  
                                                       ;alt:/e300_m(g,t)/wid_arr(t)
    ENDIF
   ENDFOR
   IF tt EQ 1000. THEN print,'15 ',e_squ_15(tt,t)
   IF tt EQ 1000. THEN print,'30 ',e_squ_30(tt,t)
  ENDFOR
 ENDFOR


 FOR tt=0,1439 DO BEGIN
  FOR t=0,29 DO BEGIN
   IF e150_i(t) GT 0 THEN BEGIN 
    e_squ_15(tt,t)=e_squ_15(tt,t)/e150_i(t)/wid_arr(t)    
                                                  ;not weighted
   ENDIF
   IF stat(tbegmin+tt) GE 2 THEN e_squ_15(tt,t)=e_squ_15(tt,t)*25.
                                                  ;ring off
   IF e300_i(t) GT 0 THEN BEGIN 
    e_squ_30(tt,t)=e_squ_30(tt,t)/e300_i(t)/wid_arr(t)
                                                  ;not weighted
   ENDIF
   IF stat(tbegmin+tt) GE 2 THEN e_squ_30(tt,t)=e_squ_30(tt,t)*12.71
                                                  ;ring off   
   IF tt EQ 1000. THEN print,t,'15norm ',e_squ_15(tt,t)
   IF tt EQ 1000. THEN print,t,'30norm ',e_squ_30(tt,t)
  ENDFOR 
 ENDFOR




;******************************************************************

 
 ;print,'e: ',max(e_square)

 ;h_square=FIX((alog10(f_square)+4.)*255/6.)  ;plotting 10^-4 up to 10^2
 ;h_squ_he=FIX((alog10(f_squ_he)+4.)*255/6.)  ;plotting 10^-4 up to 10^2

 nameoute='/Users/aposner/Documents/Kiel_data/archived/bin/l2binz_e_2002_'+daystr+'.asc'  ;***
 openw,unit,nameoute,/variable,/get_lun
; printf,unit,'COSTEP 1 min resolution electron data in 16 log energy bins'
; printf,unit,'Lower energy boundary [MeV]:'
 line1=fltarr(17)
 FOR a=2.,18. DO BEGIN
  line1(a-2)=enl_arr(a)
 ENDFOR
; printf,unit, FORMAT = '(17(G, "  "))', line1
; printf,unit,'Upper energy boundary [MeV]:'
 FOR a=2.,18. DO BEGIN
  line1(a-2)=enh_arr(a)
 ENDFOR
; printf,unit, FORMAT = '(17(G, "  "))', line1
 FOR tt=0,1440-1 DO BEGIN
  FOR ee=2.,18. DO BEGIN
   IF ee LT 7.5 THEN BEGIN
    line1(ee-2)=e_squ_15(tt,ee)
   ENDIF
   IF ee GT 7.5 THEN BEGIN
    line1(ee-2)=e_squ_30(tt,ee)
   ENDIF   
  ENDFOR
  printf,unit, FORMAT = '(17(G, "  "))', line1
 ENDFOR
 free_lun,unit
 print,'Check per day ',ddd
 print,'line1',max(line1)
ENDFOR
end

