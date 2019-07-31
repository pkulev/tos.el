;;; tos.el --- Plugin for tabs/spaces mode detection.  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Pavel Kulyov

;; Author: Pavel Kulyov <pkulev@gmail.com>
;; Maintainer: Pavel Kulyov <pkulev@gmail.com>
;; Version: 0.1.0
;; Keywords: convenience indentation
;; URL: https://www.github.com/pkulev/tos.el

;; This file is NOT part of GNU/Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Use `tos-buffer-tabs?' and `tos-buffer-spaces?' to determine if current
;; buffer indentation mode is tabs or spaces.
;; `tos-buffer-*-p' aliases are also provided.
;; These functions are useful within language-specific hooks, for example:
;; (add-hook 'python-mode-hook (lambda ()
;;                               (if (tos-buffer-tabs?)
;;                                   (setq indent-tabs-mode t)
;;                                 (setq indent-tabs-mode nil)))

;;; Code:

(defun tos--how-many-region (begin end regexp)
  "Return from BEGIN to END occurences matched by REGEXP in buffer."
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      count)))

(defun tos-buffer-tabs? ()
  "Return if current buffer is indented using tabs."
  (> (tos--how-many-region (point-min) (point-max) "^\t") 0))

(defun tos-buffer-spaces? ()
  "Return if current buffer is indented using spaces."
  (= (tos--how-many-region (point-min) (point-max) "^\t") 0))

(defalias 'tos-buffer-tabs-p #'tos-buffer-tabs?)
(defalias 'tos-buffer-spaces-p #'tos-buffer-spaces?)

(provide 'tos)

;;; tos.el ends here
