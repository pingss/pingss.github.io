;;; 框选多个闭合图形画质心点
(defun c:zzxx (/ oldosmode en ent i obj pt plsts ss j obj_base basic_pt)
	(setvar "cmdecho" 0)
	
	;;定义错误处理函数
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
	;;end定义错误处理函数
	
	
	
	(princ "\n选择要复制的对象")
	(setq obj_base (ssget))
	(setq basic_pt (getpoint "基点"))
	(princ "\n选择封闭直线、多段线、圆等")
	(if (setq ss (ssget '((0 . "PLINE,LWPOLYLINE,LINE,ARC,CIRCLE,SPLINE,ELLIPSE"))))
		(progn
			(setvar "OSMODE" 0)	;关闭对象捕捉
			(command "._undo" "begin")	;标记起始位置，撤销8到40行面域操作
			(setq en (entlast))
			(command ".region" ss "") ;创建面域
			(if en
				(progn
					(setq ss (ssadd));创建空选择集
					(while (setq en (entnext en))
						(ssadd en ss)
					)
					(if (zerop (sslength ss))
						(setq ss nil)
					)
				)
				(setq ss (ssget "_x"));entlast为空时（空文件），全选
			)
			(setq plsts '())	;存放各面域的形心坐标，如 '( (515.64 881.182) (189.49 1077.9) )
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
					;优化了代码，采用连续复制模式
					(command ".copy" obj_base "" "m" basic_pt)
					(foreach j plsts
						(command j)						
					)
					(command "")
				)
				
				(princ "\n未找到封闭图形")
			)
			(setvar "OSMODE" oldosmode)
		)
		(princ "\n没有选择对象.")
	)
	(princ)
)


