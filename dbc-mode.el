;; the mode for CAN dbc file

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
    ;; message id and name
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
    ;; number decimal
    ("\\<-?[0-9.]+\\>" . 'font-lock-constant-face)
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

(define-derived-mode dbc-mode fundamental-mode "dbc"
  "Major mode for highlighting CAN dbc files."

  :syntax-table dbc-mode-syntax-table

  ;; Setup font-lock mode.
  (set (make-local-variable 'font-lock-defaults)
       '(dbc-mode-font-lock))
  ;; Setup indentation function.
  ;; (set (make-local-variable 'indent-line-function)
  ;;      'dbc-mode-indent)
  ;; Setup comment syntax.
  (set (make-local-variable 'comment-start) "//")
  (set (make-local-variable 'comment-end) "")

  (set (make-local-variable 'comment-auto-fill-only-comments) t)
  
  ;; Setup imenu
  (set (make-local-variable 'imenu-generic-expression)
       `(("Messages" ,(rxt-pcre-to-elisp "^\\s*BO_\\s+(\\w+)") 1)
         ("Signals" ,(rxt-pcre-to-elisp "^\\s*SG_\\s+(\\w+)") 1)))
  )

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dbc\\'" . dbc-mode))

(provide 'dbc-mode)
