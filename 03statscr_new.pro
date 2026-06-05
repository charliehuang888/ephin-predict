;pro statscr_new
filelistsci=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/sci/epi02*.sci',count=scict) 
; findfile('$scil1/ep*.sci',count=scict)  ;*****
filelistphx=FILE_SEARCH('/Users/aposner/Documents/Kiel_data/archived/phx/epi02*.phx',count=phxct) 
; findfile('$phxl1/ep*.phx',count=phxct)  ;*****
IF phxct NE scict THEN PRINT,'WARNING! Check source files'
IF phxct NE scict THEN PRINT,phxct,' phx-files'
IF phxct NE scict THEN PRINT,scict,' sci-files'
a=0
yds=365.                                 ;***
tage=yds
tmn=1440.*tage
tintd=1440.
stat=dblarr(tmn)
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
;  print, var(100) mod 4
  stat(zraum)=var(100) MOD 4
  IF opener EQ tage THEN a=1
 ENDWHILE
 goto, ddone
 bbad: ON_IOERROR,NULL
 ;print,opener
ENDFOR 
ddone: print,""
CLOSE, /ALL
name='/Users/aposner/Documents/Kiel_data/archived/hires/estat_n2002.asc'   ;*****
openw,unit,name,/variable,/get_lun
printf,unit,stat
print,'Check:'
print,'stat',max(stat)
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
