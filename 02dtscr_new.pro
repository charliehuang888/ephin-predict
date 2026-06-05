;pro dtscr_new
filelistsci=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/sci/epi02*.sci',count=scict) 
; findfile('$scil1/ep*.sci',count=scict)  ;*****
filelistphx=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/phx/epi02*.phx',count=phxct) 
; findfile('$phxl1/ep*.phx',count=phxct)  ;*****
;print,filelistphx
IF phxct NE scict THEN PRINT,'WARNING! Check source files'
;IF phxct NE scict THEN PRINT,phxct,' phx-files'
;IF phxct NE scict THEN PRINT,scict,' sci-files'
a=0
yds=365.               ;***
tage=yds
tmn=1440.*tage
tintd=1440.
stat=dblarr(tmn)
tmax=dblarr(tage)
g0=dblarr(tmn)&a00=dblarr(tmn)&a01=dblarr(tmn)&a02=dblarr(tmn)
a03=dblarr(tmn)&a04=dblarr(tmn)&a05=dblarr(tmn)
tg0=dblarr(tmn)&ta00=dblarr(tmn)&ta01=dblarr(tmn)&ta02=dblarr(tmn)
ta03=dblarr(tmn)&ta04=dblarr(tmn)&ta05=dblarr(tmn)
;*******************open sci-files******************************************
;print,filelistsci," total number sci-files"
counter=1
for opener = 0.,scict-1. do begin     ;Loop that determines number of cycles
 close,3 
 openr,3,filelistsci(opener),max(opener);, /GET_LUN
; print,opener
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
  stat(zraum)=var(100) MOD 4
   IF var(5) NE -707. AND zraum LT tmn THEN BEGIN
    g0(zraum)=g0(zraum)+var(5)
    tg0(zraum)=tg0(zraum)+1.
   ENDIF
   IF var(6) NE -707. AND zraum LT tmn THEN BEGIN
    a00(zraum)=a00(zraum)+var(6)
    ta00(zraum)=ta00(zraum)+1.
   ENDIF
   IF var(7) NE -707. AND zraum LT tmn THEN BEGIN
    a01(zraum)=a01(zraum)+var(7)
    ta01(zraum)=ta01(zraum)+1.
   ENDIF
   IF var(8) NE -707. AND zraum LT tmn THEN BEGIN
    a02(zraum)=a02(zraum)+var(8)
    ta02(zraum)=ta02(zraum)+1.
   ENDIF
   IF var(9) NE -707. AND zraum LT tmn THEN BEGIN
    a03(zraum)=a03(zraum)+var(9)
    ta03(zraum)=ta03(zraum)+1.
   ENDIF
   IF var(10) NE -707. AND zraum LT tmn THEN BEGIN
    a04(zraum)=a04(zraum)+var(10)
    ta04(zraum)=ta04(zraum)+1.
   ENDIF
   IF var(11) NE -707. AND zraum LT tmn THEN BEGIN
    a05(zraum)=a05(zraum)+var(11)
    ta05(zraum)=ta05(zraum)+1.
   ENDIF
  IF opener EQ tage THEN a=1
 ENDWHILE
 goto, ddone
 bbad: ON_IOERROR,NULL
; print,opener
ENDFOR 
ddone: print,""
CLOSE, /ALL
ages=dblarr(tmn)&tdead=dblarr(tmn)&corfac=dblarr(tmn)&crit=dblarr(tmn)
agrel=dblarr(tmn)
FOR zraum=0.,tmn-1. DO BEGIN
 IF tg0(zraum) GT 0 THEN g0(zraum)=g0(zraum)/tg0(zraum)
 IF ta00(zraum) GT 0 THEN a00(zraum)=a00(zraum)/ta00(zraum)
 IF ta01(zraum) GT 0 THEN a01(zraum)=a01(zraum)/ta01(zraum)
 IF ta02(zraum) GT 0 THEN a02(zraum)=a02(zraum)/ta02(zraum)
 IF ta03(zraum) GT 0 THEN a03(zraum)=a03(zraum)/ta03(zraum)
 IF ta04(zraum) GT 0 THEN a04(zraum)=a04(zraum)/ta04(zraum)
 IF ta05(zraum) GT 0 THEN a05(zraum)=a05(zraum)/ta05(zraum)
 ages(zraum)=a00(zraum)+a01(zraum)+a02(zraum)+a03(zraum)+a04(zraum)+a05(zraum)
 agrel(zraum)=-1.
 IF g0(zraum) GT 0 Then BEGIN
  agrel(zraum)=(ages(zraum)*3.e-06+a00(zraum)*2.e-06)/(g0(zraum)*400.e-09)
 ENDIF
 IF ages(zraum) GT 59.95312*47500. THEN crit(zraum)=1
 IF g0(zraum) GT 59.95312*2500000. THEN crit(zraum)=1 
 tdead(zraum)=g0(zraum)*400.e-09+ages(zraum)*3.e-06+a00(zraum)*2.e-06
 ;to take into account 5 us analog dt in a-seg, 3 us coincidence dt    
 corfac(zraum)=59.95312/(59.95312-tdead(zraum))
ENDFOR
name='/Users/aposner/Documents/Kiel_data/archived/hires/edead_n2002.asc'   ;*****
openw,unit,name,/variable,/get_lun
printf,unit,corfac,crit,agrel
print,'Check:'
print,'corfac',max(corfac)
print,'crit',max(crit)
print,'agrel',max(agrel)
free_lun,unit
end

;IF stat(a) LT 2 THEN:
; e150(a)=e150(a)/0.25/0.45*ele150(a)/gese150(a)          ;
; e300(a)=e300(a)/1.78/2.33*ele300(a)/gese300(a)          ;
; e1300(a)=e1300(a)/2.01/7.76*ele1300(a)/gese1300(a)      ;
; p4(a)=p4(a)/5.1413/3.5*prop4(a)/gesp4(a)                ;RING
; p8(a)=p8(a)/5.1413/17.2*prop8(a)/gesp8(a)               ; AN
; p25(a)=p25(a)/4.7686/28.*prop25(a)/gesp25(a)            ;
; h4(a)=h4(a)/5.1413/3.5*helhe4(a)/geshe4(a)              ;
; h8(a)=h8(a)/5.1413/17.2*helhe8(a)/geshe8(a)             ;
; h25(a)=h25(a)/4.7686/28.*helhe25(a)/geshe25(a)          ;
; intc(a)=intc(a)/4.5211

;IF stat GE 2 THEN:
; e150(a)=e150(a)/0.01/0.45*ele150(a)/gese150(a)          ;
; e300(a)=e300(a)/0.14/2.33*ele300(a)/gese300(a)          ;
; e1300(a)=e1300(a)/0.12/7.76*ele1300(a)/gese1300(a)      ;
; p4(a)=p4(a)/0.18/3.5*prop4(a)/gesp4(a)                  ;RING 
; p8(a)=p8(a)/0.18/17.2*prop8(a)/gesp8(a)                 ; AUS
; p25(a)=p25(a)/0.18/28.*prop25(a)/gesp25(a)              ;(A0-B0)
; h4(a)=h4(a)/0.18/3.5*helhe4(a)/geshe4(a)                ;
; h8(a)=h8(a)/0.18/17.2*helhe8(a)/geshe8(a)               ;
; h25(a)=h25(a)/0.18/28.*helhe25(a)/geshe25(a)            ;
; intc(a)=intc(a)/0.36

; e150: *25.
; e300: *12.71
; e1300:*16.75
; p4:*28.56
; p8:*28.56
; p25:*26.49
; h4:*28.56
; h8:*28.56
; h25:*26.49
; intc:*12.56
