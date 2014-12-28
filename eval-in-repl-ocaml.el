;;; eval-in-repl-ocaml.el --- ESS-like eval for OCaml  -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Kazuki YOSHIDA

;; Author: Kazuki YOSHIDA <kazukiyoshida@mail.harvard.edu>
;; Keywords: tools, convenience
;; URL: https://github.com/kaz-yos/eval-in-repl
;; Version: 0.5.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; OCaml-specific file for eval-in-repl
;; See below for configuration
;; https://github.com/kaz-yos/eval-in-repl/


;;; Code:

;;;
;;; Require dependencies
(require 'eval-in-repl)
(require 'tuareg)
(require 'ess)


;;;
;;; OCaml RELATED
;; depends on tuareg.el
;;
;;; eir-send-to-ocaml
(defalias 'eir-send-to-ocaml
  (apply-partially 'eir-send-to-repl
                   ;; fun-change-to-repl
                   #'(lambda () (switch-to-buffer-other-window "*ocaml-toplevel*"))
                   ;; fun-execute
                   #'tuareg-interactive-send-input)
  "Sends expression to *ocaml* and have it evaluated.")


;;; eir-eval-in-ocaml
;;;###autoload
(defun eir-eval-in-ocaml ()
  "Evaluates OCaml expressions in OCaml files."
  (interactive)
  ;; Define local variables
  (let* (w-script)

    ;; If buffer named *ocaml* is not found, invoke ocaml-run
    (eir-repl-start "\\*ocaml-.*" #'run-ocaml)

    ;; Check if selection is present
    (if (and transient-mark-mode mark-active)
	;; If selected, send region
	(eir-send-to-ocaml (buffer-substring-no-properties (point) (mark)))

      ;; If not selected, do all the following
      ;; Move to the beginning of line
      (beginning-of-line)
      ;; Set mark at current position
      (set-mark (point))
      ;; Go to the end of line
      (end-of-line)
      ;; Send region if not empty
      (if (not (equal (point) (mark)))
	  (eir-send-to-ocaml (buffer-substring-no-properties (point) (mark)))
	;; If empty, deselect region
	(setq mark-active nil))
      ;; Move to the next statement
      (ess-next-code-line)

      ;; Activate ocaml window, and switch back
      ;; Remeber the script window
      (setq w-script (selected-window))
      ;; Switch to the ocaml
      (switch-to-buffer-other-window "*ocaml-toplevel*")
      ;; Switch back to the script window
      (select-window w-script))))


;;; eir-send-to-ocaml-semicolon
(defun eir-send-to-ocaml-semicolon ()
  "Sends two semicolons to *ocaml-toplevel* and have them evaluated."
  (interactive)
  (eir-send-to-ocaml ";;"))


(provide 'eval-in-repl-ocaml)
;;; eval-in-repl-ocaml.el ends here














