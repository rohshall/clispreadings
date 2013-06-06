;;;; clispreadings.lisp

(in-package #:clispreadings)

;; TBD: figure out how to use ningle's context
;;(setf (context :database) (db:connect ...)

;;; global vars
(defvar *app* (make-instance 'ningle:<app>))
(defvar *connection* (dbi:connect :postgres
                       :database-name "sd_ventures_development"
                       :username "sd_ventures"
                       :password ""))

;;; nigle routes
(setf (ningle:route *app* "/api/1/devices")
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "SELECT * FROM devices"))
           (result (dbi:execute query))
           (rows (loop for row = (dbi:fetch result)
                    while row
                    collect `(("device_type_id" . ,(getf row :|device_type_id|)) ("mac_addr" . ,(getf row :|mac_addr|))))))
      (setf (clack.response:headers ningle:*response* :content-type) "application/json")
      (json:encode-json-to-string rows))))

(setf (ningle:route *app* "/api/1/devices" :method :POST)
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "INSERT INTO devices (device_type_id, mac_addr, manufactured_at) VALUES (?, ?, ?)")))
      (dbi:execute query (getf params :|device_type_id|) (getf params :|mac_addr|) (getf params :|manufactured_at|))
      (setf (clack.response:headers ningle:*response* :content-type) "application/json")
      (json:encode-json-to-string '(("status" . "ok"))))))

(setf (ningle:route *app* "/api/1/devices/:device-id")
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "SELECT * FROM devices WHERE mac_addr = ?"))
           (result (dbi:execute query (getf params :device-id)))
           (row (dbi:fetch result))
           (json-row `(("device_type_id" . ,(getf row :|device_type_id|)) ("mac_addr" . ,(getf row :|mac_addr|)))))
      (setf (clack.response:headers ningle:*response* :content-type) "application/json")
      (json:encode-json-to-string json-row))))

(setf (ningle:route *app* "/api/1/devices/:device-id/readings")
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "SELECT * FROM readings WHERE device_mac_addr = ?"))
           (result (dbi:execute query (getf params :device-id)))
           (rows (loop for row = (dbi:fetch result)
                    while row
                    collect `(("value" . ,(getf row :|value|)) ("created_at" . ,(getf row :|created_at|))))))
      (setf (clack.response:headers ningle:*response* :content-type) "application/json")
      (json:encode-json-to-string rows))))

(setf (ningle:route *app* "/api/1/devices/:device-id/readings" :method :POST)
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "INSERT INTO readings (device_mac_addr, value, created_at) VALUES (?, ?, ?)")))
      (dbi:execute query (getf params :device-id) (getf params :|value|) (getf params :|created_at|))
      (setf (clack.response:headers ningle:*response* :content-type) "application/json")
      (json:encode-json-to-string '(("status" . "ok"))))))

(clack:clackup *app*)
