;;;; clispreadings.lisp

(in-package #:clispreadings)

;; TBD: figure out how to use ningle's context
;;(setf (context :database) (db:connect ...)

;;; "clispreadings" goes here. Hacks and glory await!
(defvar *app* (make-instance 'ningle:<app>))
(defvar *connection* (dbi:connect :postgres
                       :database-name "sd_ventures_development"
                       :username "sd_ventures"
                       :password ""))

(setf (ningle:route *app* "/api/1/devices")
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "SELECT (device_type_id, mac_addr) FROM devices"))
           (result (dbi:execute query))
           (rows (loop for row = (dbi:fetch result)
                    while row
                    collect (second row))))
      (format nil "~{~A~^ ~}" rows))))

(setf (ningle:route *app* "/api/1/devices" :method :POST)
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "INSERT INTO devices (device_type_id, mac_addr, manufactured_at) VALUES (?, ?, ?)")))
      (dbi:execute query (getf params :|device_type_id|) (getf params :|mac_addr|) (getf params :|manufactured_at|))
      (format nil "status=ok"))))

(setf (ningle:route *app* "/api/1/devices/:device-id")
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "SELECT (device_type_id, mac_addr) FROM devices WHERE mac_addr = ?"))
           (result (dbi:execute query (getf params :device-id)))
           (rows (loop for row = (dbi:fetch result)
                    while row
                    collect (second row))))
      (format nil "~{~A~^ ~}" rows))))

(setf (ningle:route *app* "/api/1/devices/:device-id/readings")
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "SELECT (value, created_at) FROM readings WHERE device_mac_addr = ?"))
           (result (dbi:execute query (getf params :device-id)))
           (rows (loop for row = (dbi:fetch result)
                    while row
                    collect (second row))))
      (format nil "~{~A~^ ~}" rows))))

(setf (ningle:route *app* "/api/1/devices/:device-id/readings" :method :POST)
  #'(lambda (params)
    (let* ((query (dbi:prepare *connection* "INSERT INTO readings (device_mac_addr, value, created_at) VALUES (?, ?, ?)")))
      (dbi:execute query (getf params :device-id) (getf params :|value|) (getf params :|created_at|))
      (format nil "status=ok"))))

(clack:clackup *app*)
