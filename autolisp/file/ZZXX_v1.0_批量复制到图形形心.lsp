;;; ��ѡ����պ�ͼ�λ����ĵ�
(defun c:zzxx (/ oldosmode en ent i obj pt plsts ss j obj_base basic_pt)
	(setvar "cmdecho" 0)
	
	;;�����������
	(setq olderr *error*
		oldosmode (getvar "osmode")
	)
	(defun *error* (msg)
	    (princ "\n")
		(princ msg)
		(setvar "osmode" oldosmode)
		(setq *error* olderr)
		(princ)
	)
	;;end�����������
	
	
	
	(princ "\nѡ��Ҫ���ƵĶ���")
	(setq obj_base (ssget))
	(setq basic_pt (getpoint "����"))
	(princ "\nѡ����ֱ�ߡ�����ߡ�Բ��")
	(if (setq ss (ssget '((0 . "PLINE,LWPOLYLINE,LINE,ARC,CIRCLE,SPLINE,ELLIPSE"))))
		(progn
			(setvar "OSMODE" 0)	;�رն���׽
			(command "._undo" "begin")	;�����ʼλ�ã�����8��40���������
			(setq en (entlast))
			(command ".region" ss "") ;��������
			(if en
				(progn
					(setq ss (ssadd));������ѡ��
					(while (setq en (entnext en))
						(ssadd en ss)
					)
					(if (zerop (sslength ss))
						(setq ss nil)
					)
				)
				(setq ss (ssget "_x"));entlastΪ��ʱ�����ļ�����ȫѡ
			)
			(setq plsts '())	;��Ÿ�������������꣬�� '( (515.64 881.182) (189.49 1077.9) )
			(if ss 
				(progn
					(setq i (sslength ss))
					(repeat i
						(setq ent (ssname ss (setq i (1- i))))
						(if (= (cdr (assoc 0 (entget ent))) "REGION")
							(progn
								(vl-load-com)
								(setq obj (vlax-ename->vla-object ent))
								(setq pt (vlax-safearray->list (vlax-variant-value (vla-get-centroid obj)))
									area (vla-get-area obj)
								)
								(setq plsts (cons pt plsts))
							)
						);end if
					);end repeat
				);end progn
			);enf if
			
			(command "._undo" "end")
			(command "._undo" 1)
						
			(if plsts	
				(progn
					;�Ż��˴��룬������������ģʽ
					(command ".copy" obj_base "" "m" basic_pt)
					(foreach j plsts
						(command j)						
					)
					(command "")
				)
				
				(princ "\nδ�ҵ����ͼ��")
			)
			(setvar "OSMODE" oldosmode)
		)
		(princ "\nû��ѡ�����.")
	)
	(princ)
)


