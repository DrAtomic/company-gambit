(require 'company)

;;;###autoload
(defun company-gambit--backend (command &optional arg &rest ignored)
  (case command
    (prefix (and (eq major-mode 'scheme-mode)
                 (company-grab-symbol)))
    
    (candidates (all-completions
                 arg
                 (if (and (boundp 'procedure-hash)
                          procedure-hash)
                     procedure-hash
		   
		   (with-temp-buffer
		     (insert-file-contents "/usr/share/doc/gambit-c/gambit.txt")
		     (goto-char (point-min))
		     (let ((test-list '()))
		       (while (re-search-forward "-- procedure.*" (point-max) t)
			 (let ((procedure-name-with-args (cadr (split-string (match-string 0) "-- procedure: "))))
			   (push (car (split-string procedure-name-with-args)) test-list)))
		       (setq procedure-hash test-list))))))))


					; TODO(#1): make the arguments list show up, also maybe use a hashtable instead of a list
					; TODO: make it also match special forms

;; (defun gambit-hash ()
;;   "makes hash of procedure names as well as arguments"
;;   (with-temp-buffer
;;     (insert-file-contents "/usr/share/doc/gambit-c/gambit.txt")
;;     (goto-char (point-min))
;;     (let ((hash (make-hash-table :test #'equal)))
;;       (while (re-search-forward "-- procedure.*\|-- special form:.*" (point-max) t)
;; 	(let ((procedure-name-with-args (cadr (split-string (match-string 0) "-- procedure: "))))
;; 	  (puthash (car (split-string procedure-name-with-args))
;; 		   (cdr (split-string procedure-name-with-args))
;; 		   hash)))
;;       (setq procedure-hash hash))))

(provide 'company-gambit)
