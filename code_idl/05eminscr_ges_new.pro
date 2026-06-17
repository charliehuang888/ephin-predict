;pro eminscr_ges_new
filelistsci=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/sci/epi02*.sci',count=scict) 
; findfile('$scil1/ep*.sci',count=scict)  ;*****
filelistphx=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/phx/epi02*.phx',count=phxct) 
; findfile('$phxl1/ep*.phx',count=phxct)  ;*****
IF phxct NE scict THEN PRINT,'WARNING! Check source files'
IF phxct NE scict THEN PRINT,phxct,' phx-files'
IF phxct NE scict THEN PRINT,scict,' sci-files'
md=[0.,31.,59.,90.,120.,151.,181.,212.,243.,273.,304.,334.]
mds=[0.,31.,60.,91.,121.,152.,182.,213.,244.,274.,305.,335.]
;yds=1.
;*****************Kurve He************************************************
age=dblarr(400)&ege=dblarr(400)
for xxx=178.,577. DO BEGIN
aage=10.^(-0.7+(138.9-0.389*(xxx-250.)+668./(xxx-147.6))/100.)
aege=10.^(0.3+xxx/200.)
age(xxx-178)=alog10(aege)*0.707107+alog10(aage)*0.707107
ege(xxx-178)=alog10(aege)*0.707107+alog10(aage)*(-0.707107)
endfor
xp=dblarr(2)&yp=dblarr(2)
;*************************************************************************
;COMMON
;ereignis,tmin,tt,e150,e300,e1300,e3000,p4,p8,p25,h4,h8,h25,intc,vs,$
;vv,vw,aver,vp,e0,ele150,gese150,ele300,gese300,ele1300,gese1300,prop4,$
;gesp4,prop8,gesp8,prop25,gesp25,helhe4,geshe4,helhe8,geshe8,helhe25,$
;geshe25,tage
a=0
yds=365.                       ;***

tage=yds
;print,"Beginn x-ter Tag ab dem 7. Dez. 1995"
;read,int 
;tt=dblarr(96.*tage)&zeit=0.                         ;Zeitarray
;FOR zeit=0.,96.*tage-1 DO BEGIN
;tt(zeit)=(900000.*zeit+450000.)/864.0e+05
;endfor   
;th=dblarr(24*tage)&zeit=0.                         ;Zeitarray
;FOR zeit=0.,24.*tage-1 DO BEGIN
; th(zeit)=(3600.*zeit+1800.)/86400.
;endfor
;t2h=dblarr(12*tage)&zeit=0.                         ;Zeitarray
;FOR zeit=0.,12.*tage-1 DO BEGIN
;t2h(zeit)=(7200000.*zeit+3600000.)/864.0e+05
;endfor
tmin=dblarr(1440.*tage) 
;FOR zeit=0.,1440.*tage-1 DO BEGIN
;tmin(zeit)=(60.*zeit+30.)/86400.
;endfor
count=0

;***********************sci-Daten*********************************************
tmn=1440.*tage
tintd=1440.
stat1=0.&xstat1=0.&stat5=0.&xstat5=0.
yn=fltarr(tmn)
stat=intarr(tmn)
g0=dblarr(tmn)&a00=dblarr(tmn)&a01=dblarr(tmn)&a02=dblarr(tmn)
a03=dblarr(tmn)&a04=dblarr(tmn)&a05=dblarr(tmn)&b00=dblarr(tmn)
b01=dblarr(tmn)&b02=dblarr(tmn)&b03=dblarr(tmn)&b04=dblarr(tmn)
b05=dblarr(tmn)&c0=dblarr(tmn)&d0=dblarr(tmn)&e0=dblarr(tmn)
f0=dblarr(tmn)&p4gm=dblarr(tmn)&p4gr=dblarr(tmn)&p4s=dblarr(tmn)
p8gm=dblarr(tmn)&p8gr=dblarr(tmn)&p8s=dblarr(tmn)&h4gm=dblarr(tmn)
h4gr=dblarr(tmn)&h4s1=dblarr(tmn)&h4s23=dblarr(tmn)&h8gm=dblarr(tmn)
h8gr=dblarr(tmn)&h8s1=dblarr(tmn)&h8s23=dblarr(tmn)&e150=dblarr(tmn)
e300=dblarr(tmn)&e1300=dblarr(tmn)&e3000=dblarr(tmn)&intc=dblarr(tmn)
p25gm=dblarr(tmn)&p25gr=dblarr(tmn)&p25s=dblarr(tmn)&p41gm=dblarr(tmn)
p41gr=dblarr(tmn)&p41s=dblarr(tmn)&h25gm=dblarr(tmn)&h25gr=dblarr(tmn)
h25s1=dblarr(tmn)&h25s23=dblarr(tmn)&h41gm=dblarr(tmn)&h41gr=dblarr(tmn)
h41s1=dblarr(tmn)&h41s23=dblarr(tmn)&ct0=dblarr(tmn)&ct1=dblarr(tmn)
ct2=dblarr(tmn)&ct3=dblarr(tmn)&ct4=dblarr(tmn)&ct5=dblarr(tmn)
p4=dblarr(tmn)&p8=dblarr(tmn)&p25=dblarr(tmn)&h4=dblarr(tmn)
h8=dblarr(tmn)&h25=dblarr(tmn);&h34=dblarr(tmn)
;total time per interval for normalization
tg0=dblarr(tmn)&ta00=dblarr(tmn)&ta01=dblarr(tmn)&ta02=dblarr(tmn)
ta03=dblarr(tmn)&ta04=dblarr(tmn)&ta05=dblarr(tmn)&tb00=dblarr(tmn)
tb01=dblarr(tmn)&tb02=dblarr(tmn)&tb03=dblarr(tmn)&tb04=dblarr(tmn)
tb05=dblarr(tmn)&tc0=dblarr(tmn)&td0=dblarr(tmn)&te0=dblarr(tmn)
tf0=dblarr(tmn)&tp4gm=dblarr(tmn)&tp4gr=dblarr(tmn)&tp4s=dblarr(tmn)
tp8gm=dblarr(tmn)&tp8gr=dblarr(tmn)&tp8s=dblarr(tmn)&th4gm=dblarr(tmn)
th4gr=dblarr(tmn)&th4s1=dblarr(tmn)&th4s23=dblarr(tmn)&th8gm=dblarr(tmn)
th8gr=dblarr(tmn)&th8s1=dblarr(tmn)&th8s23=dblarr(tmn)&te150=dblarr(tmn)
te300=dblarr(tmn)&te1300=dblarr(tmn)&te3000=dblarr(tmn)&tintc=dblarr(tmn)
tp25gm=dblarr(tmn)&tp25gr=dblarr(tmn)&tp25s=dblarr(tmn)&tp41gm=dblarr(tmn)
tp41gr=dblarr(tmn)&tp41s=dblarr(tmn)&th25gm=dblarr(tmn)&th25gr=dblarr(tmn)
th25s1=dblarr(tmn)&th25s23=dblarr(tmn)&th41gm=dblarr(tmn)&th41gr=dblarr(tmn)
th41s1=dblarr(tmn)&th41s23=dblarr(tmn)&tct0=dblarr(tmn)&tct1=dblarr(tmn)
tct2=dblarr(tmn)&tct3=dblarr(tmn)&tct4=dblarr(tmn)&tct5=dblarr(tmn)

tmax=dblarr(tage)
;*******************open sci-files******************************************
;print,filelistsci," total number sci-files"

counter=1
for opener = 0.,scict-1. do begin     ;Loop that determines number of cycles
 close,3 
 openr,3,filelistsci(opener),max(opener);, /GET_LUN
 ;print,opener
 ;FREE_LUN,opener
 ;*****************endfor
 var=dblarr(101)
 readf,3,var
 ;IF opener EQ int THEN tnull=var(4)-var(2)
 CLOSE, /ALL
 ON_IOERROR,NULL
 a=0
 openr,3,filelistsci(opener)            ;***
 WHILE a EQ 0 DO BEGIN 
  ON_IOERROR,bbad
  readf,3,var
  IF var(1) GT 0. THEN zraum=float(var(2))/1000./60.+(float(var(1))-1.)*tintd
  ;zraum=(var(4)-tnull)/60000-((var(4)-tnull) MOD 60000)/60000
  ;print,opener,zraum
  stat(zraum)=var(100) MOD 4    ;GE 2: ring off
  xstat1=stat1
  xstat5=stat5
  stat1=var(93)
  stat5=var(97)
  ;print,stat1,xstat1
  ;print,stat5,xstat5
  IF stat5 GE 224 AND stat1 GE 64 AND stat1 LT 128 THEN BEGIN
   IF xstat5 GE 224 AND xstat1 GE 64 AND xstat1 LT 128 THEN BEGIN
    yn(zraum)=yn(zraum)+1.
    IF var(5) NE -707. AND zraum LT tmn THEN BEGIN
     g0(zraum)=g0(zraum)+var(5)/59.95312
     tg0(zraum)=tg0(zraum)+1.
    ENDIF
    IF var(6) NE -707. AND zraum LT tmn THEN BEGIN
     a00(zraum)=a00(zraum)+var(6)/59.95312
     ta00(zraum)=ta00(zraum)+1.
    ENDIF
    IF var(7) NE -707. AND zraum LT tmn THEN BEGIN
     a01(zraum)=a01(zraum)+var(7)/59.95312
     ta01(zraum)=ta01(zraum)+1.
    ENDIF
    IF var(8) NE -707. AND zraum LT tmn THEN BEGIN
     a02(zraum)=a02(zraum)+var(8)/59.95312
     ta02(zraum)=ta02(zraum)+1.
    ENDIF
    IF var(9) NE -707. AND zraum LT tmn THEN BEGIN
     a03(zraum)=a03(zraum)+var(9)/59.95312
     ta03(zraum)=ta03(zraum)+1.
    ENDIF
    IF var(10) NE -707. AND zraum LT tmn THEN BEGIN
     a04(zraum)=a04(zraum)+var(10)/59.95312
     ta04(zraum)=ta04(zraum)+1.
    ENDIF
    IF var(11) NE -707. AND zraum LT tmn THEN BEGIN
     a05(zraum)=a05(zraum)+var(11)/59.95312
     ta05(zraum)=ta05(zraum)+1.
    ENDIF
    IF var(12) NE -707. AND zraum LT tmn THEN BEGIN
     b00(zraum)=b00(zraum)+var(12)/59.95312
     tb00(zraum)=tb00(zraum)+1.
    ENDIF
    IF var(13) NE -707. AND zraum LT tmn THEN BEGIN
     b01(zraum)=b01(zraum)+var(13)/59.95312
     tb01(zraum)=tb01(zraum)+1.
    ENDIF
    IF var(14) NE -707. AND zraum LT tmn THEN BEGIN
     b02(zraum)=b02(zraum)+var(14)/59.95312
     tb02(zraum)=tb02(zraum)+1.
    ENDIF
    IF var(15) NE -707. AND zraum LT tmn THEN BEGIN
     b03(zraum)=b03(zraum)+var(15)/59.95312
     tb03(zraum)=tb03(zraum)+1.
    ENDIF
    IF var(16) NE -707. AND zraum LT tmn THEN BEGIN
     b04(zraum)=b04(zraum)+var(16)/59.95312
     tb04(zraum)=tb04(zraum)+1.
    ENDIF
    IF var(17) NE -707. AND zraum LT tmn THEN BEGIN
     b05(zraum)=b05(zraum)+var(17)/59.95312
     tb05(zraum)=tb05(zraum)+1.
    ENDIF
     IF var(18) NE -707. AND zraum LT tmn THEN BEGIN
     c0(zraum)=c0(zraum)+var(18)/59.95312
     tc0(zraum)=tc0(zraum)+1.
    ENDIF
    IF var(19) NE -707. AND zraum LT tmn THEN BEGIN
     d0(zraum)=d0(zraum)+var(19)/59.95312
     td0(zraum)=td0(zraum)+1.
    ENDIF
    IF var(20) NE -707. AND zraum LT tmn THEN BEGIN
     e0(zraum)=e0(zraum)+var(20)/59.95312
     te0(zraum)=te0(zraum)+1.
    ENDIF
    IF var(21) NE -707. AND zraum LT tmn THEN BEGIN
     f0(zraum)=f0(zraum)+var(21)/59.95312
     tf0(zraum)=tf0(zraum)+1.
    ENDIF
    IF var(22) NE -707. AND zraum LT tmn THEN BEGIN
     p4gm(zraum)=p4gm(zraum)+var(22)/59.95312
     tp4gm(zraum)=tp4gm(zraum)+1.
    ENDIF
    IF var(23) NE -707. AND zraum LT tmn THEN BEGIN
     p4gr(zraum)=p4gr(zraum)+var(23)/59.95312
     tp4gr(zraum)=tp4gr(zraum)+1.
    ENDIF  
    IF var(24) NE -707. AND zraum LT tmn THEN BEGIN
     p4s(zraum)=p4s(zraum)+var(24)/59.95312
     tp4s(zraum)=tp4s(zraum)+1.
    ENDIF
    IF var(25) NE -707. AND zraum LT tmn THEN BEGIN
     p8gm(zraum)=p8gm(zraum)+var(25)/59.95312
     tp8gm(zraum)=tp8gm(zraum)+1.
    ENDIF
    IF var(26) NE -707. AND zraum LT tmn THEN BEGIN
     p8gr(zraum)=p8gr(zraum)+var(26)/59.95312
     tp8gr(zraum)=tp8gr(zraum)+1.
    ENDIF
    IF var(27) NE -707. AND zraum LT tmn THEN BEGIN
     p8s(zraum)=p8s(zraum)+var(27)/59.95312
     tp8s(zraum)=tp8s(zraum)+1.
    ENDIF
    IF var(28) NE -707. AND zraum LT tmn THEN BEGIN
     h4gm(zraum)=h4gm(zraum)+var(28)/59.95312
     th4gm(zraum)=th4gm(zraum)+1.
    ENDIF
    IF var(29) NE -707. AND zraum LT tmn THEN BEGIN
     h4gr(zraum)=h4gr(zraum)+var(29)/59.95312
     th4gr(zraum)=th4gr(zraum)+1.
    ENDIF
    IF var(30) NE -707. AND zraum LT tmn THEN BEGIN
     h4s1(zraum)=h4s1(zraum)+var(30)/59.95312
     th4s1(zraum)=th4s1(zraum)+1.
    ENDIF
    IF var(31) NE -707. AND zraum LT tmn THEN BEGIN
     h4s23(zraum)=h4s23(zraum)+var(31)/59.95312
     th4s23(zraum)=th4s23(zraum)+1.
    ENDIF
    IF var(32) NE -707. AND zraum LT tmn THEN BEGIN
     h8gm(zraum)=h8gm(zraum)+var(32)/59.95312
     th8gm(zraum)=th8gm(zraum)+1.
    ENDIF
    IF var(33) NE -707. AND zraum LT tmn THEN BEGIN
     h8gr(zraum)=h8gr(zraum)+var(33)/59.95312
     th8gr(zraum)=th8gr(zraum)+1.
    ENDIF
    IF var(34) NE -707. AND zraum LT tmn THEN BEGIN
     h8s1(zraum)=h8s1(zraum)+var(34)/59.95312
     th8s1(zraum)=th8s1(zraum)+1.
    ENDIF
    IF var(35) NE -707. AND zraum LT tmn THEN BEGIN
     h8s23(zraum)=h8s23(zraum)+var(35)/59.95312
     th8s23(zraum)=th8s23(zraum)+1.
    ENDIF
    IF var(36) NE -707. AND zraum LT tmn THEN BEGIN
     e150(zraum)=e150(zraum)+var(36)/59.95312
     te150(zraum)=te150(zraum)+1.
    ENDIF
    IF var(37) NE -707. AND zraum LT tmn THEN BEGIN
     e300(zraum)=e300(zraum)+var(37)/59.95312
     te300(zraum)=te300(zraum)+1.
    ENDIF
    IF var(38) NE -707. AND zraum LT tmn THEN BEGIN
     e1300(zraum)=e1300(zraum)+var(38)/59.95312
     te1300(zraum)=te1300(zraum)+1.
    ENDIF
    IF var(39) NE -707. AND zraum LT tmn THEN BEGIN
     e3000(zraum)=e3000(zraum)+var(39)/59.95312
     te3000(zraum)=te3000(zraum)+1.
    ENDIF
    IF var(40) NE -707. AND zraum LT tmn THEN BEGIN
     intc(zraum)=intc(zraum)+var(40)/59.95312
     tintc(zraum)=tintc(zraum)+1.
    ENDIF
    IF var(41) NE -707. AND zraum LT tmn THEN BEGIN
     p25gm(zraum)=p25gm(zraum)+var(41)/59.95312
     tp25gm(zraum)=tp25gm(zraum)+1.
    ENDIF
    IF var(42) NE -707. AND zraum LT tmn THEN BEGIN
     p25gr(zraum)=p25gr(zraum)+var(42)/59.95312
     tp25gr(zraum)=tp25gr(zraum)+1.
    ENDIF
    IF var(43) NE -707. AND zraum LT tmn THEN BEGIN
     p25s(zraum)=p25s(zraum)+var(43)/59.95312
     tp25s(zraum)=tp25s(zraum)+1.
    ENDIF
    IF var(44) NE -707. AND zraum LT tmn THEN BEGIN
     p41gm(zraum)=p41gm(zraum)+var(44)/59.95312
     tp41gm(zraum)=tp41gm(zraum)+1.
    ENDIF
    IF var(45) NE -707. AND zraum LT tmn THEN BEGIN
     p41gr(zraum)=p41gr(zraum)+var(45)/59.95312
     tp41gr(zraum)=tp41gr(zraum)+1.
    ENDIF
    IF var(46) NE -707. AND zraum LT tmn THEN BEGIN
     p41s(zraum)=p41s(zraum)+var(46)/59.95312
     tp41s(zraum)=tp41s(zraum)+1.
    ENDIF
    IF var(47) NE -707. AND zraum LT tmn THEN BEGIN
     h25gm(zraum)=h25gm(zraum)+var(47)/59.95312
     th25gm(zraum)=th25gm(zraum)+1.
    ENDIF
    IF var(48) NE -707. AND zraum LT tmn THEN BEGIN
     h25gr(zraum)=h25gr(zraum)+var(48)/59.95312
     th25gr(zraum)=th25gr(zraum)+1.
    ENDIF
    IF var(49) NE -707. AND zraum LT tmn THEN BEGIN
     h25s1(zraum)=h25s1(zraum)+var(49)/59.95312
     th25s1(zraum)=th25s1(zraum)+1.
    ENDIF
    IF var(50) NE -707. AND zraum LT tmn THEN BEGIN
     h25s23(zraum)=h25s23(zraum)+var(50)/59.95312
     th25s23(zraum)=th25s23(zraum)+1.
    ENDIF
    IF var(51) NE -707. AND zraum LT tmn THEN BEGIN
     h41gm(zraum)=h41gm(zraum)+var(51)/59.95312
     th41gm(zraum)=th41gm(zraum)+1.
    ENDIF
    IF var(52) NE -707. AND zraum LT tmn THEN BEGIN
     h41gr(zraum)=h41gr(zraum)+var(52)/59.95312
     th41gr(zraum)=th41gr(zraum)+1.
    ENDIF
    IF var(53) NE -707. AND zraum LT tmn THEN BEGIN
     h41s1(zraum)=h41s1(zraum)+var(53)/59.95312
     th41s1(zraum)=th41s1(zraum)+1.
    ENDIF
    IF var(54) NE -707. AND zraum LT tmn THEN BEGIN
     h41s23(zraum)=h41s23(zraum)+var(54)/59.95312
     th41s23(zraum)=th41s23(zraum)+1.
    ENDIF
    IF var(55) NE -707. AND zraum LT tmn THEN BEGIN
     ct0(zraum)=ct0(zraum)+var(55)/59.95312
     tct0(zraum)=tct0(zraum)+1.
    ENDIF
    IF var(56) NE -707. AND zraum LT tmn THEN BEGIN
     ct1(zraum)=ct1(zraum)+var(56)/59.95312
     tct1(zraum)=tct1(zraum)+1.  
    ENDIF
    IF var(57) NE -707. AND zraum LT tmn THEN BEGIN
     ct2(zraum)=ct2(zraum)+var(57)/59.95312
     tct2(zraum)=tct2(zraum)+1.
    ENDIF
    IF var(58) NE -707. AND zraum LT tmn THEN BEGIN
     ct3(zraum)=ct3(zraum)+var(58)/59.95312
     tct3(zraum)=tct3(zraum)+1.
    ENDIF
    IF var(59) NE -707. AND zraum LT tmn THEN BEGIN
     ct4(zraum)=ct4(zraum)+var(59)/59.95312
     tct4(zraum)=tct4(zraum)+1.
    ENDIF
    IF var(60) NE -707. AND zraum LT tmn THEN BEGIN
     ct5(zraum)=ct5(zraum)+var(60)/59.95312
     tct5(zraum)=tct5(zraum)+1.
    ENDIF
   ENDIF                               
  ENDIF
  IF opener EQ tage THEN a=1
 ENDWHILE
 goto, ddone
 bbad: ON_IOERROR,NULL
 ;print,opener
ENDFOR 
ddone: print,""
CLOSE, /ALL
; print,'sci 1'
FOR zz=300,310 DO BEGIN
; print,'150 ',e150(zz),' 300 ',e300(zz)
ENDFOR
FOR zraum=0.,tmn-1. DO BEGIN
 IF tg0(zraum) GT 0 THEN g0(zraum)=g0(zraum)/tg0(zraum)
 IF ta00(zraum) GT 0 THEN a00(zraum)=a00(zraum)/ta00(zraum)
 IF ta01(zraum) GT 0 THEN a01(zraum)=a01(zraum)/ta01(zraum)
 IF ta02(zraum) GT 0 THEN a02(zraum)=a02(zraum)/ta02(zraum)
 IF ta03(zraum) GT 0 THEN a03(zraum)=a03(zraum)/ta03(zraum)
 IF ta04(zraum) GT 0 THEN a04(zraum)=a04(zraum)/ta04(zraum)
 IF ta05(zraum) GT 0 THEN a05(zraum)=a05(zraum)/ta05(zraum)
 IF tb00(zraum) GT 0 THEN b00(zraum)=b00(zraum)/tb00(zraum)
 IF tb01(zraum) GT 0 THEN b01(zraum)=b01(zraum)/tb01(zraum)
 IF tb02(zraum) GT 0 THEN b02(zraum)=b02(zraum)/tb02(zraum)
 IF tb03(zraum) GT 0 THEN b03(zraum)=b03(zraum)/tb03(zraum)
 IF tb04(zraum) GT 0 THEN b04(zraum)=b04(zraum)/tb04(zraum)
 IF tb05(zraum) GT 0 THEN b05(zraum)=b05(zraum)/tb05(zraum)
 IF tc0(zraum) GT 0 THEN c0(zraum)=c0(zraum)/tc0(zraum)
 IF td0(zraum) GT 0 THEN d0(zraum)=d0(zraum)/td0(zraum)
 IF te0(zraum) GT 0 THEN e0(zraum)=e0(zraum)/te0(zraum)
 IF tf0(zraum) GT 0 THEN f0(zraum)=f0(zraum)/tf0(zraum)
 IF tp4gm(zraum) GT 0 THEN p4gm(zraum)=p4gm(zraum)/tp4gm(zraum)
 IF tp4gr(zraum) GT 0 THEN p4gr(zraum)=p4gr(zraum)/tp4gr(zraum)
 IF tp4s(zraum) GT 0 THEN p4s(zraum)=p4s(zraum)/tp4s(zraum)
 p4(zraum)=p4gm(zraum)+p4gr(zraum)+p4s(zraum) 
 IF tp8gm(zraum) GT 0 THEN p8gm(zraum)=p8gm(zraum)/tp8gm(zraum)
 IF tp8gr(zraum) GT 0 THEN p8gr(zraum)=p8gr(zraum)/tp8gr(zraum)
 IF tp8s(zraum) GT 0 THEN p8s(zraum)=p8s(zraum)/tp8s(zraum)
 p8(zraum)=p8gm(zraum)+p8gr(zraum)+p8s(zraum) 
 IF th4gm(zraum) GT 0 THEN h4gm(zraum)=h4gm(zraum)/th4gm(zraum)
 IF th4gr(zraum) GT 0 THEN h4gr(zraum)=h4gr(zraum)/th4gr(zraum)
 IF th4s1(zraum) GT 0 THEN h4s1(zraum)=h4s1(zraum)/th4s1(zraum)
 IF th4s23(zraum) GT 0 THEN h4s23(zraum)=h4s23(zraum)/th4s23(zraum)
 h4(zraum)=h4gm(zraum)+h4gr(zraum)+h4s1(zraum)+h4s23(zraum) 
 IF th8gm(zraum) GT 0 THEN h8gm(zraum)=h8gm(zraum)/th8gm(zraum)
 IF th8gr(zraum) GT 0 THEN h8gr(zraum)=h8gr(zraum)/th8gr(zraum)
 IF th8s1(zraum) GT 0 THEN h8s1(zraum)=h8s1(zraum)/th8s1(zraum)
 IF th8s23(zraum) GT 0 THEN h8s23(zraum)=h8s23(zraum)/th8s23(zraum)
 h8(zraum)=h8gm(zraum)+h8gr(zraum)+h8s1(zraum)+h8s23(zraum) 
 IF te150(zraum) GT 0 THEN e150(zraum)=e150(zraum)/te150(zraum)
 IF te300(zraum) GT 0 THEN e300(zraum)=e300(zraum)/te300(zraum)
 IF te1300(zraum) GT 0 THEN e1300(zraum)=e1300(zraum)/te1300(zraum)
 IF te3000(zraum) GT 0 THEN e3000(zraum)=e3000(zraum)/te3000(zraum)
 e1300(zraum)=e1300(zraum)+e3000(zraum)
 IF tintc(zraum) GT 0 THEN intc(zraum)=intc(zraum)/tintc(zraum)
 IF tp25gm(zraum) GT 0 THEN p25gm(zraum)=p25gm(zraum)/tp25gm(zraum)
 IF tp25gr(zraum) GT 0 THEN p25gr(zraum)=p25gr(zraum)/tp25gr(zraum)
 IF tp25s(zraum) GT 0 THEN p25s(zraum)=p25s(zraum)/tp25s(zraum)
 IF tp41gm(zraum) GT 0 THEN p41gm(zraum)=p41gm(zraum)/tp41gm(zraum)
 IF tp41gr(zraum) GT 0 THEN p41gr(zraum)=p41gr(zraum)/tp41gr(zraum)
 IF tp41s(zraum) GT 0 THEN p41s(zraum)=p41s(zraum)/tp41s(zraum)
 p25(zraum)=p25gm(zraum)+p25gr(zraum)+p25s(zraum)+$
 p41gm(zraum)+p41gr(zraum)+p41s(zraum)
 IF th25gm(zraum) GT 0 THEN h25gm(zraum)=h25gm(zraum)/th25gm(zraum)
 IF th25gr(zraum) GT 0 THEN h25gr(zraum)=h25gr(zraum)/th25gr(zraum)
 IF th25s1(zraum) GT 0 THEN h25s1(zraum)=h25s1(zraum)/th25s1(zraum)
 IF th25s23(zraum) GT 0 THEN h25s23(zraum)=h25s23(zraum)/th25s23(zraum)
 h25(zraum)=h25gm(zraum)+h25gr(zraum)+h25s1(zraum)+h25s23(zraum)
 IF th41gm(zraum) GT 0 THEN h41gm(zraum)=h41gm(zraum)/th41gm(zraum)
 IF th41gr(zraum) GT 0 THEN h41gr(zraum)=h41gr(zraum)/th41gr(zraum)
 IF th41s1(zraum) GT 0 THEN h41s1(zraum)=h41s1(zraum)/th41s1(zraum)
 IF th41s23(zraum) GT 0 THEN h41s23(zraum)=h41s23(zraum)/th41s23(zraum)
 h25(zraum)=h25gm(zraum)+h25gr(zraum)+h25s1(zraum)+h25s23(zraum)+$
 h41gm(zraum)+h41gr(zraum)+h41s1(zraum)+h41s23(zraum)
 IF tct0(zraum) GT 0 THEN ct0(zraum)=ct0(zraum)/tct0(zraum)
 IF tct1(zraum) GT 0 THEN ct1(zraum)=ct1(zraum)/tct1(zraum)
 IF tct2(zraum) GT 0 THEN ct2(zraum)=ct2(zraum)/tct2(zraum)
 IF tct3(zraum) GT 0 THEN ct3(zraum)=ct3(zraum)/tct3(zraum)
 IF tct4(zraum) GT 0 THEN ct4(zraum)=ct4(zraum)/tct4(zraum)
 IF tct5(zraum) GT 0 THEN ct5(zraum)=ct5(zraum)/tct5(zraum)
ENDFOR


name='/Users/aposner/Documents/Kiel_data/archived/hires/ephgeszr_n2002.asc'   ;*****
openw,unit,name,/variable,/get_lun
printf,unit,yn,e150,e300,e1300,p4,p8,p25,h4,h8,h25
free_lun,unit
print,'Check:'
print,'yn',max(yn)
print,'e150',max(e150)
print,'e300',max(e300)
print,'e1300',max(e1300)
print,'p4',max(p4)
print,'p8',max(p8)
print,'p25',max(p25)
print,'h4',max(h4)
print,'h8',max(h8)
print,'h25',max(h25)

;print,helhe4
end
