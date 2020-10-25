;;; etrace.el --- Emacs Lisp Tracer  -*- lexical-binding: t -*-
;; Released under the MIT license, Copyright Jane Street Group, LLC
;; This module modifies the instrumentation profiler included with
;; Emacs called "elp" to also record trace events for the beginning
;; and end of function calls, and provides a function to write out
;; those events in Chromium JSON trace format.
;;
;; First use elp commands to instrument the functions you want, then
;; do the thing you want to trace, then M-x etrace-write RET to write
;; out a trace to the configurable etrace-output-file. You can now
;; open chrome://tracing and load the resulting trace file to view it.

(require 'elp)

(defcustom etrace-output-file "~/etrace.json"
  "When calling etrace-write, write the trace to this file."
  :type 'file)

(defvar etrace--trace nil "Trace events")

(defun etrace--make-wrapper-advice (orig funsym)
  "Advice to make the piece of advice that instruments FUNSYM."
  (let ((elp-wrapper (funcall orig funsym)))
    (lambda (func &rest args)
      "This function has been instrumented for profiling by the ELP.
ELP is the Emacs Lisp Profiler.  To restore the function to its
original definition, use \\[elp-restore-function] or \\[elp-restore-all]."
      (let ((result))
        (push (list ?B funsym (current-time)) etrace--trace)
        (unwind-protect
            (setq result (apply elp-wrapper func args))
          (push (list ?E funsym (current-time)) etrace--trace))
        result))))

(advice-add #'elp--make-wrapper :around #'etrace--make-wrapper-advice)

(defun etrace-clear ()
  "Clear the etrace buffer"
  (interactive)
  (setq etrace--trace nil))

(defun etrace-write ()
  "Write out trace to etrace-output-file then clear the current trace variable"
  (interactive)
  (save-window-excursion
    (save-excursion
      (find-file-literally etrace-output-file)
      (erase-buffer)
      (insert "[")
      (let* ((first-el t)
             (trace (reverse etrace--trace))
             (start-time (if etrace--trace (float-time (nth 2 (car trace))) nil)))
        (dolist (ev trace)
          (if first-el
              (setq first-el nil)
            (insert ","))
          ;; Intentionally avoid using a proper JSON formatting library, traces can be
          ;; multiple megabytes and writing them this way is probably faster and produces
          ;; compact JSON but without everything being on one line.
          (insert
           (format
            "{\"name\":\"%s\",\"cat\":\"\",\"ph\":\"%c\",\"ts\":%d,\"pid\":0,\"tid\":0,\"args\":{}}\n"
            (nth 1 ev) (nth 0 ev) (truncate (* 1000000 (- (float-time (nth 2 ev)) start-time))))))
        (insert "]")
        (save-buffer))))
  (message "Wrote trace to etrace-output-file (%s)!" etrace-output-file)
  (etrace-clear))

(provide 'etrace)
