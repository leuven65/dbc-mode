;;; dbc-mode.el --- major mode for editing CAN dbc files

;; Copyright 2019 Jian Wang <leuven65@gmail.com>

;; Author: Jian Wang <leuven65@gmail.com>
;; Maintainer: Jian Wang <leuven65@gmail.com>
;; Created: <2019-10-09>
;; Version: 1.0.0
;; Package-Version: 
;; Keywords: languages, CAN, dbc

;; available from http://github.com/leuven65/dbc-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'dbc-mode)
;; or
;;   (use-package dbc-mode)

;; this package needs the package pcre2el
;; you can install it from elpa

;;; Code:


;;;;##########################################################################
;;;;  User Options, Variables
;;;;##########################################################################

(require 'pcre2el)

(defconst dbc-mode-keywords '("VERSION"
                              "NS_"
                              "NS_DESC_"
                              "BS_"
                              "BU_"
                              "BO_"
                              "SG_"
                              "BO_TX_BU_"
                              "EV_"
                              "EV_DATA_"
                              "ENVVAR_DATA_"
                              "CM_"
                              "BA_DEF_"
                              "BA_DEF_REL_"
                              "BA_DEF_SGTYPE_"
                              "BA_DEF_DEF_"
                              "BA_DEF_DEF_REL_"
                              "BA_"
                              "BA_REL_"
                              "BA_SGTYPE_"
                              "BU_BO_REL_"
                              "BU_SG_REL_"
                              "BU_EV_REL_"
                              "VAL_"
                              "VAL_TABLE_"
                              "CAT_DEF_"
                              "CAT_"
                              "FILTER"
                              "SIG_VALTYPE_"
                              "SIG_GROUP_"
                              "SG_MUL_VAL_"
                              "SGTYPE_"
                              "SIG_TYPE_REF_"
                              "SGTYPE_VAL_"
                              "SIGTYPE_VALTYPE_")
  "the keyword of dbc")

(defconst dbc-mode-type '("INT"
                          "HEX"
                          "ENUM"
                          "FLOAT"
                          "STRING"                              
                          )
  "the data type of dbc")

(defconst dbc-mode-constant '("Vector__XXX")
  "the constant of dbc")

(defvar dbc-mode-font-lock
  `((,(regexp-opt dbc-mode-keywords 'words) . 'font-lock-keyword-face)
    ;; message name
    (,(rxt-pcre-to-elisp "^\\s+BO_\\s+\\d+\\s+(\\w+)")
     (1 font-lock-function-name-face))
    ;; signal name
    (,(rxt-pcre-to-elisp "^\\s+SG_\\s+(\\w+)\\s+(?:M|m\\d+M?)?\\s*:")
     (1 font-lock-variable-name-face))
    ;; type
    (,(regexp-opt dbc-mode-type 'words) . 'font-lock-type-face)
    ;; constant
    (,(regexp-opt dbc-mode-constant 'words) . 'font-lock-constant-face)
    ;; speical char
    ("[:@|;]" . 'font-lock-builtin-face)
    ;; numbers
    (,(rxt-pcre-to-elisp "[+-]?\\b[.\\d]+([eE][+-]?\\d+)?") . 'font-lock-constant-face)
    )
  "Highlighting dbc mode"
  )

(defvar dbc-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\/ ". 12" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\; ">" table)
    (modify-syntax-entry ?_ "w" table)
    table)
  "Syntax table for `dbc-mode'.")

;;;###autoload
(define-derived-mode dbc-mode prog-mode "dbc"
  "Major mode for highlighting CAN dbc files."

  ;; Setup font-lock mode.
  (setq-local font-lock-defaults
              '(dbc-mode-font-lock))

  ;; Setup indentation function.
  ;; (set (make-local-variable 'indent-line-function)
  ;;      'dbc-mode-indent)
  ;; Setup comment syntax.
  (setq-local comment-start "//")
  (setq-local comment-start-skip "//+\\s-*")

  (setq-local comment-auto-fill-only-comments t)

  (setq-local imenu-generic-expression
              `(("Messages" ,(rxt-pcre-to-elisp "^\\s*BO_\\s+\\d+\\s+(\\w+)") 1)
                ("Signals" ,(rxt-pcre-to-elisp "^\\s*SG_\\s+(\\w+)") 1)))
  )

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dbc\\'" . dbc-mode))

(provide 'dbc-mode)

;;; dbc-mode.el ends here
