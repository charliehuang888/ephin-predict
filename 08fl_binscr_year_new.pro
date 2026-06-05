;pro fl_binscr_year_new
dayin=43
yds=365


;**********************YEAR************************************
print,dayin
tage=yds                                 ;*****
;**********************YEAR************************************
;tage=365.                                 ;*****
tmn=1440.*tage
;yearstr='2008'                             ;*****
;ynamestr='i08'                            ;h95 ... i10
;*****************He curve He, p boxes non penetr**************************
age=dblarr(400)&ege=dblarr(400)
for xxx=178.,577. DO BEGIN
 aage=10.^(-0.7+(138.9-0.389*(xxx-250.)+668./(xxx-147.6))/100.)
 aege=10.^(0.3+xxx/200.)
 age(xxx-178)=alog10(aege)*0.707107+alog10(aage)*0.707107
 ege(xxx-178)=alog10(aege)*0.707107+alog10(aage)*(-0.707107)
endfor
;*****************p and He boxes penetrating*********************************
;extended proton box----------------------
xp_51=fltarr(5)
xx=[2.46,2.48,2.50,2.56,2.6]
FOR a=0,4 DO BEGIN
 xp_51(a)=xx(a)
ENDFOR 
yp_51=fltarr(4,4) ;ymin1, ymin2, ymin3, ymax1
yy=[2.,1.97,1.95,2.05] ;ymin 26-33 MeV
FOR a=0,3 DO BEGIN
 yp_51(a,0)=yy(a)
ENDFOR 
yy=[2.05,2.05,2.,2.]   ;ymin 33-38 MeV
FOR a=0,3 DO BEGIN
 yp_51(a,1)=yy(a)
ENDFOR 
yy=[2.1,2.1,2.1,2.1]   ;ymin 38-53 MeV
FOR a=0,3 DO BEGIN
 yp_51(a,2)=yy(a)
ENDFOR 
yy=[2.2,2.4,2.6,2.6]   ;ymax 26-53 MeV
FOR a=0,3 DO BEGIN
 yp_51(a,3)=yy(a)
ENDFOR 
;--------------------Helium-------------------------
xhe_51=fltarr(8)
xx=[2.4,2.43,2.44,2.45,2.46,2.48,2.5,2.6]
FOR a=0,7 DO BEGIN
 xhe_51(a)=xx(a)
ENDFOR 
yhe_51=fltarr(7,5)
yy=[1.9,1.875,1.85,1.83,1.81,1.78,1.76] ;ymin 52-112 MeV
FOR a=0,6 DO BEGIN
 yhe_51(a,0)=yy(a)
ENDFOR
yy=[1.95,1.95,1.95,1.95,1.95,1.9,1.9] ;ymin 112-142 MeV
FOR a=0,6 DO BEGIN
 yhe_51(a,1)=yy(a)
ENDFOR
yy=[2.,2.,2.,2.,2.,2.,2.] ;ymin 142-212 MeV
FOR a=0,6 DO BEGIN
 yhe_51(a,2)=yy(a)
ENDFOR
yy=[2.1,2.1,2.1,2.1,2.1,2.1,2.1] ;ymax 52-112 MeV
FOR a=0,6 DO BEGIN
 yhe_51(a,3)=yy(a)
ENDFOR
yy=[2.2,2.2,2.2,2.2,2.2,2.2,2.6] ;ymax 112-212 MeV
FOR a=0,6 DO BEGIN
 yhe_51(a,4)=yy(a)
ENDFOR

;*********************electrons for comparison with gammas,protons*********
e150=dblarr(tmn)
yn=dblarr(tmn)
p4=dblarr(tmn)&p8=dblarr(tmn)&p25=dblarr(tmn)&h4=dblarr(tmn)
h8=dblarr(tmn)&h25=dblarr(tmn)
e300=dblarr(tmn)&e1300=dblarr(tmn)&intc=dblarr(tmn)

openr,3,'/Users/aposner/Documents/Kiel_data/archived/hires/eflr_n2002.asc'  ;****
readf,3,yn,e150,e300,e1300,p4,p8,p25,h4,h8,h25,intc
CLOSE,/ALL


;*********************pha weighting for each particle*********
ele150=dblarr(tmn)
elyn=dblarr(tmn)
prop4=dblarr(tmn)&prop8=dblarr(tmn)&prop25=dblarr(tmn)&helh4=dblarr(tmn)
helh8=dblarr(tmn)&helh25=dblarr(tmn)
ele300=dblarr(tmn)&ele1300=dblarr(tmn)
ctp4=dblarr(tmn)

openr,3,'/Users/aposner/Documents/Kiel_data/archived/hires/epherr_n2002.asc'  ;****
readf,3,elyn,ele150,ele300,ele1300,prop4,prop8,prop25,helh4,helh8,helh25
CLOSE,/ALL
;********************gammas: deadtime plotter***************************
;ages=dblarr(tmn)
;openr,3,'$gammafi'
;readf,3,ages
;CLOSE,/ALL

namedt='/Users/aposner/Documents/Kiel_data/archived/hires/edead_n2002.asc'   ;****
agrel=dblarr(tmn)&corfac=dblarr(tmn)&crit=dblarr(tmn)

openr,3,namedt
readf,3,corfac,crit,agrel
CLOSE, /ALL
FOR a=0.,tmn-1. DO BEGIN 
 p4(a)=p4(a)*corfac(a)
 p8(a)=p8(a)*corfac(a)
 p25(a)=p25(a)*corfac(a)
 h4(a)=h4(a)*corfac(a)
 h8(a)=h8(a)*corfac(a)
 h25(a)=h25(a)*corfac(a)
 e150(a)=e150(a)*corfac(a)
 e300(a)=e300(a)*corfac(a)
 e1300(a)=e1300(a)*corfac(a)
 intc(a)=intc(a)*corfac(a)
 ;print,corfac(a+tbeg*1440.)
ENDFOR

;**************************status*****************************************
ttt=1440.*tage
stat=dblarr(ttt)
namest='/Users/aposner/Documents/Kiel_data/archived/hires/estat_n2002.asc'   ;****
openr,3,namest
readf,3,stat
CLOSE, /ALL
FOR a=0.,ttt-1. DO BEGIN 
 IF stat(a) GE 2 THEN BEGIN   ;ring off
  p4(a)=p4(a)*28.56
  p8(a)=p8(a)*28.56
  p25(a)=p25(a)*26.49
  h4(a)=h4(a)*28.56
  h8(a)=h8(a)*28.56
  h25(a)=h25(a)*26.49
  e150(a)=e150(a)*25.
  e300(a)=e300(a)*12.71
  e1300(a)=e1300(a)*16.75
  intc(a)=intc(a)*12.56
 ENDIF
ENDFOR

;*******************energy loss interpolation table************************
;protons 51 MeV - 80 MeV  step 1 MeV translates to seen E of
epobs=[50.080152,48.594421,47.158568,45.772306,44.435348,43.150115,$
41.918669,40.740436,39.614838,38.541295,37.521275,36.555943,35.644461,$
34.785984,33.979681,33.226171,32.525860,31.873842,31.258102,30.677536,$
30.131151,29.611858,29.118525,28.650741,28.203265,27.774884,27.366393,$
26.976103,26.600055,26.238061]
;helium 54 MeV/n - 160 MeV/n step 1 MeV/n translates to seen E of
eheobs=[216.00000,196.09328,182.47760,173.12253,165.79015,159.68270,$
154.41583,149.76859,145.59741,141.76695,138.25327,135.04894,132.08684,$
129.30582,126.70324,124.27421,121.97867,119.80185,117.74270,115.79925,$
113.94324,112.16181,110.46121,108.84710,107.30873,105.82869,104.40662,$
103.04241,101.73536,100.47187,99.246477,98.059262,96.910303,95.798232,$
94.713591,93.662946,92.647724,91.667942,90.722382,89.802744,88.907544,$
88.036848,87.190727,86.368476,85.560893,84.765342,83.981891,83.214711,$
82.467802,81.741213,81.034990,80.349183,79.683840,79.039010,78.410929,$
77.791363,77.180068,76.577089,75.982466,75.397047,74.825512,74.268647,$
73.726490,73.199079,72.686454,72.185519,71.690979,71.202773,70.720932,$
70.245485,69.776462,69.313894,68.860283,68.418053,67.987231,67.567848,$
67.158537,66.754556,66.355529,65.961477,65.572421,65.188382,64.809382,$
64.435442,64.067045,63.706903,63.355472,63.012634,62.674918,62.340835,$
62.010400,61.683627,61.360530,61.041124,60.725425,60.413446,60.105204,$
59.802416,59.506753,59.217421,58.931695,58.649364,58.370440,58.094935,$
57.822860,57.554228,57.289051]       


FOR ddd=dayin,tage DO BEGIN  ;1,tage******************************!!!!!!!!!!!!!!!!!!!!!
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
 f_square=dblarr(720,22)
 ;g_square=dblarr(720,22)
 ;h_square=dblarr(720,22)
 f_squ_he=dblarr(720,22)
 ;g_squ_he=dblarr(720,22)
 ;h_squ_he=dblarr(720,22)
 ;rel_squ=dblarr(720,22)
 ;relpl_squ=dblarr(720,22)
 print,tbeg
 xmin=tbeg     ;*****
 xmax=tbeg+1.     ;*****
 tbegmin=xmin*1440.
 ;*******************************************************************

 xx=dblarr(2)&yy=dblarr(2)
 var=dblarr(18)
 namepha='/Users/aposner/Documents/Kiel_data/archived/phx/epi02'+daystr+'.phx'
 openr,3,namepha            ;***
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
  t_fill=(zraum-tbegmin)/2.
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
   ;IF coinc LT 3 THEN BEGIN ;electrons
   ; xx(0)=tp
   ; xx(1)=xx(0)
   ; yy(0)=dtot
   ; yy(1)=yy(0)
   ;ENDIF
   IF coinc GT 2 AND coinc LT 11 THEN BEGIN
;******************particle species*****************************************
    xp=alog10(dtot)*0.707107+alog10(ade(0))*(-0.707107)
    yp=alog10(dtot)*0.707107+alog10(ade(0))*0.707107
    ;print,'XP',xp 
   IF xp(0) GT 2.65 THEN xp(0)=2.65
    xxx=0.
    WHILE (ege(xxx) LT xp(0)) DO BEGIN   ;xp
     xxx=xxx+1.
    ENDWHILE
    teso=-1&teson=0.
    IF yp(0)-age(xxx) GT -3. AND yp(0)-age(xxx) LT 1. THEN BEGIN
     teson=age(xxx)-yp(0)+1.
     ;print,teson 
   ENDIF
;**************************************************************************
    IF stat(zraum) GE 2 THEN BEGIN
     IF coinc EQ 4 THEN BEGIN
      IF teson GE 1.81 AND teson LT 1.90 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot)-0.6)*20)
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-4)   ;p4
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         ctp4(zraum)=ctp4(zraum)+1.
         ;print,'***',t_fill,prop4(zraum)-ctp4(zraum),'***'
         f_square(FIX(t_fill),dtotlog)=f_square(FIX(t_fill),dtotlog)+p4(zraum)/prop4(zraum)
        ENDIF
       ENDIF
      ENDIF
     ENDIF
     IF coinc EQ 5 THEN BEGIN
      IF teson GE 1.80 AND teson LT 1.90 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot)-0.6)*20)
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-4)   ;p8
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_square(FIX(t_fill),dtotlog)=f_square(FIX(t_fill),dtotlog)+p8(zraum)/prop8(zraum)
        ENDIF
       ENDIF
      ENDIF
     ENDIF
     IF coinc EQ 6 THEN BEGIN
      IF teson GE 1.70 AND teson LT 1.92 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot)-0.6)*20)
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-4)   ;p25
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_square(FIX(t_fill),dtotlog)=f_square(FIX(t_fill),dtotlog)+p25(zraum)/prop25(zraum)
        ENDIF
       ENDIF
      ENDIF
     ENDIF
     IF coinc EQ 8 THEN BEGIN
      IF teson GE 0.97 AND teson LT 1.03 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot/4.
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot/4.)-0.6)*20)
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         ;print,'*****************',t_fill,'********************'
         f_squ_he(FIX(t_fill),dtotlog)=f_squ_he(FIX(t_fill),dtotlog)+h4(zraum)/helh4(zraum)
        ENDIF
       ENDIF
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-8)   ;h4
      ENDIF
     ENDIF
     IF coinc EQ 9 THEN BEGIN
      IF teson GE 0.97 AND teson LT 1.03 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot/4.
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot/4.)-0.6)*20)
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_squ_he(FIX(t_fill),dtotlog)=f_squ_he(FIX(t_fill),dtotlog)+h8(zraum)/helh8(zraum)
        ENDIF
       ENDIF
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-8)   ;h8
      ENDIF
     ENDIF
     IF coinc EQ 10 THEN BEGIN
      IF teson GE 0.95 AND teson LT 1.05 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot/4.
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot/4.)-0.6)*20)
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_squ_he(FIX(t_fill),dtotlog)=f_squ_he(FIX(t_fill),dtotlog)+h25(zraum)/helh25(zraum)
        ENDIF
       ENDIF
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-8)   ;h25
      ENDIF
     ENDIF
     
    ENDIF ELSE BEGIN   ;ring on
    
     IF coinc EQ 4 THEN BEGIN
      IF teson GE 1.73 AND teson LT 1.92 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot)-0.6)*20)
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-4)   ;p4
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         ctp4(zraum)=ctp4(zraum)+1.
         ;print,'*****************',t_fill,prop4(zraum),ctp4(zraum)
         f_square(FIX(t_fill),dtotlog)=f_square(FIX(t_fill),dtotlog)+p4(zraum)/prop4(zraum)
        ENDIF
       ENDIF
      ENDIF
     ENDIF
     IF coinc EQ 5 THEN BEGIN
      IF teson GE 1.73 AND teson LT 1.92 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot)-0.6)*20)
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-4)   ;p8
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_square(FIX(t_fill),dtotlog)=f_square(FIX(t_fill),dtotlog)+p8(zraum)/prop8(zraum)
        ENDIF
       ENDIF
      ENDIF
     ENDIF
     IF coinc EQ 6 THEN BEGIN
      IF teson GE 1.65 AND teson LT 1.94 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot)-0.6)*20)
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-4)   ;p25
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_square(FIX(t_fill),dtotlog)=f_square(FIX(t_fill),dtotlog)+p25(zraum)/prop25(zraum)
        ENDIF
       ENDIF
      ENDIF
     ENDIF
     IF coinc EQ 8 THEN BEGIN
      IF teson GE 0.89 AND teson LT 1.08 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot/4.
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot/4.)-0.6)*20)
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         ;print,'*****************',t_fill,'********************'
         f_squ_he(FIX(t_fill),dtotlog)=f_squ_he(FIX(t_fill),dtotlog)+h4(zraum)/helh4(zraum)
        ENDIF
       ENDIF
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-8)   ;h4
      ENDIF
     ENDIF
     IF coinc EQ 9 THEN BEGIN
      IF teson GE 0.91 AND teson LT 1.08 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot/4.
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot/4.)-0.6)*20)
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_squ_he(FIX(t_fill),dtotlog)=f_squ_he(FIX(t_fill),dtotlog)+h8(zraum)/helh8(zraum)
        ENDIF
       ENDIF
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-8)   ;h8
      ENDIF
     ENDIF
     IF coinc EQ 10 THEN BEGIN
      IF teson GE 0.91 AND teson LT 1.08 THEN BEGIN
       xx(0)=tp
       xx(1)=xx(0)
       yy(0)=dtot/4.
       yy(1)=yy(0)
       dtotlog=FIX((alog10(dtot/4.)-0.6)*20)
       IF t_fill GE 0 AND t_fill LT 719 THEN BEGIN
        IF dtotlog GE 0 AND dtotlog LT 22 THEN BEGIN
         f_squ_he(FIX(t_fill),dtotlog)=f_squ_he(FIX(t_fill),dtotlog)+h25(zraum)/helh25(zraum)
        ENDIF
       ENDIF
       ;oplot,xx,yy,PSYM=3,color=colpha(coinc-8)   ;h25
      ENDIF
     ENDIF
    ENDELSE
   ENDIF
   IF coinc EQ 12 THEN BEGIN
    abcde=(ade+bde+cde)*5./3.45     ;detector thickness normalization
    sump=(ade+bde+cde)*5./3.45+dde+ede
    xval=(ede*2.5980762/sump+1.7320508+5.1961524*dde/sump)/1.7320508
    IF xval GT 2.4 AND xval LT 2.6 THEN BEGIN ;valid for all useful particles
     yval=1.+ede/sump*2.5980762
     IF dtot GE 26.24 AND dtot LT 50.08 THEN BEGIN   ;*****protons 51*****
      IF xval GT 2.46 AND xval LE 2.6 THEN BEGIN
       FOR a=0,3 DO BEGIN
        IF xval GT xp_51(a) AND xval LT xp_51(a+1) THEN BEGIN
         IF dtot LT 33. THEN el=0
         IF dtot GE 33. AND dtot LT 38. THEN el=1
         IF dtot GE 38. AND dtot LT 51. THEN el=2
         eh=3
         IF yval GE yp_51(a,el) AND yval LT yp_51(a,eh) THEN BEGIN
          ;interpolate total e and plot
          z=1
          WHILE dtot LT epobs(z) DO BEGIN
           z=z+1
          ENDWHILE
          ;print,z,epobs(z)
          diffe=epobs(z-1)-epobs(z)
          frace=epobs(z-1)-dtot
          ratio=frace/diffe
          dtot_int=51.+z-1.+ratio
          print,'***',dtot_int
          xx(0)=tp
          xx(1)=xx(0)
          yy(0)=dtot_int
          yy(1)=yy(0)
          ;oplot,xx,yy,PSYM=3,color=10
          ;ip51(zraum)=ip51(zraum)+1.
         ENDIF
        ENDIF
       ENDFOR
      ENDIF
     ENDIF
     IF dtot GE 57.29 AND dtot LT 216. THEN BEGIN      ;*****helium 51*****
      FOR a=0,6 DO BEGIN
       IF xval GT xhe_51(a) AND xval LT xhe_51(a+1) THEN BEGIN
        IF dtot LT 112. THEN el=0
        IF dtot GE 112. AND dtot LT 142. THEN el=1
        IF dtot GE 142. AND dtot LT 212. THEN el=2
        IF dtot LT 112. THEN eh=3
        IF dtot GE 112. AND dtot LT 212. THEN eh=4
        IF yval GE yhe_51(a,el) AND yval LT yhe_51(a,eh) THEN BEGIN
         ;interpolate total e and plot
         z=1
         WHILE dtot LT eheobs(z) DO BEGIN
          z=z+1
         ENDWHILE
         ;print,z,eheobs(z)
         diffe=eheobs(z-1)-eheobs(z)
         frace=eheobs(z-1)-dtot
         ratio=frace/diffe
         dtot_int=54.+z-1.+ratio
         ;print,'***he',dtot_int
         xx(0)=tp
         xx(1)=xx(0)
         yy(0)=dtot_int
         yy(1)=yy(0)
         ;oplot,xx,yy,PSYM=3,color=10
         ;ihe51(zraum)=ihe51(zraum)+1.
        ENDIF
       ENDIF
      ENDFOR
     ENDIF
    ENDIF      
   ENDIF
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
 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   IF ee LE 5 THEN wid=7.8-4.3
   IF ee GT 5 AND ee LE 15 THEN wid=25.-7.8
   IF ee GT 15 THEN wid=53.-25.
   binwid=10.^(0.6+0.05*(ee+1.))-10.^(0.6+0.05*ee)  
   f_square(tt,ee)=f_square(tt,ee)/2.*wid/binwid
   ;g_square(tt,ee)=(alog10(f_square(tt,ee)+0.00001)+5.) ;for plotting
   f_squ_he(tt,ee)=f_squ_he(tt,ee)/2.*wid/binwid
   ;g_squ_he(tt,ee)=(alog10(f_squ_he(tt,ee)+0.00001)+5.) ;for plotting
   ;rel_squ(tt,ee)=f_squ_he(tt,ee)/f_square(tt,ee)
  ENDFOR
 ENDFOR
 ;relpl_squ=(alog10(rel_squ)+2.)*255./3. ;plotting relative values log 0.01-10
 
 print,'He: ',max(f_squ_he)

 ;h_square=FIX((alog10(f_square)+4.)*255/6.)  ;plotting 10^-4 up to 10^2
 ;h_squ_he=FIX((alog10(f_squ_he)+4.)*255/6.)  ;plotting 10^-4 up to 10^2
 nameouthe='/Users/aposner/Documents/Kiel_data/archived/bin/l2bin_he_n2002_'+daystr+'.asc' ;***
 openw,unit,nameouthe,/variable,/get_lun
; printf,unit,'COSTEP 2 min resolution helium data in 22 log energy bins'
; printf,unit,'Lower energy boundary [MeV/n]:'
 line1=fltarr(22)
 FOR a=0.,21. DO BEGIN
  line1(a)=10.^(0.6+0.05*a)
 ENDFOR
; printf,unit, FORMAT = '(22(G, "  "))', line1
; printf,unit,'Upper energy boundary:'
 FOR a=0.,21. DO BEGIN
  line1(a)=10.^(0.6+0.05*(a+1.))
 ENDFOR
; printf,unit, FORMAT = '(22(G, "  "))', line1
 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   line1(ee)=f_squ_he(tt,ee)
  ENDFOR
  printf,unit, FORMAT = '(22(G, "  "))', line1
 ENDFOR
 free_lun,unit
 nameoutp='/Users/aposner/Documents/Kiel_data/archived/bin/l2bin_p_n2002_'+daystr+'.asc' ;***
 openw,unit,nameoutp,/variable,/get_lun
; printf,unit,'COSTEP 2 min resolution proton data in 22 log energy bins'
; printf,unit,'Lower energy boundary [MeV]:'
 line1=fltarr(22)
 FOR a=0.,21. DO BEGIN
  line1(a)=10.^(0.6+0.05*a)
 ENDFOR
; printf,unit, FORMAT = '(22(G, "  "))', line1
; printf,unit,'Upper energy boundary [MeV]:'
 FOR a=0.,21. DO BEGIN
  line1(a)=10.^(0.6+0.05*(a+1.))
 ENDFOR
; printf,unit, FORMAT = '(22(G, "  "))', line1
 FOR tt=0,719 DO BEGIN
  FOR ee=0.,21. DO BEGIN
   line1(ee)=f_square(tt,ee)
  ENDFOR
  printf,unit, FORMAT = '(22(G, "  "))', line1
 ENDFOR
 free_lun,unit
ENDFOR
end
