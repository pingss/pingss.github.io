(defun C:PTX(/ olderr oldosmode old_pl_wid pt1 pt2 pt3 ltx pp1 pp2 pp3 pp4 pp5 pp6 pp7 pp8)
	(setvar "cmdecho" 0)
	
	;;�����������
	(setq olderr *error*
		oldosmode (getvar "osmode")
		old_pl_wid (getvar "plinewid")
	)
	(defun *error* (msg)
	    (princ "\n")
		(princ msg)
		(setvar "plinewid" old_pl_wid)
		(setvar "osmode" oldosmode)
		(setq *error* olderr)
		(princ)
	)
	;;end�����������	

	(setq pt1 (getpoint "\n ����¥�ݵ�1���¶˵㣺")
		pt2 (getpoint pt1 "\n ����¥�ݵ�1���϶˵㣺")
		pt3 (getpoint pt2 "\n �����ݶ��ϲ��˵㣺")
	)
	;�ж��ݶη���
	(if (< (car pt2) (car pt3))
		(setq ltx 1)
		(setq ltx -1)
	)
	(setq pp4 (polar pt2 (/ pi 2) 2200)
		pp3 (polar pp4 pi (* 300 ltx))
		pp2 (polar pp3 (/ pi -2) (+ 200 (- (cadr pt2) (cadr pt1))))
		pp1 (polar pp2 pi (* 4000 ltx))
		pp5 (polar pt3 (/ pi 2) 2200)
		pp6 (polar pp5 0 (* 300 ltx))
		pp7 (polar pp6 (/ pi -2) 200)
		pp8 (polar pp7 0 (* 4000 ltx))
	)
	
	(command "_.undo" "_group")
	(setvar "plinewid" 0)
	(setvar "osmode" 0)
	
	(command "._pline" pp1 pp2 pp3 pp4 pp5 pp6 pp7 pp8 "")
	
	(setvar "plinewid" old_pl_wid)
	(setvar "osmode" oldosmode)
	(command "_.undo" "_end")
	
	(prin1)
)
(prompt "\n ����ͷ�ߣ����PTX")
(prin1)
