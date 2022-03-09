(declare-project 
   :name "LoveGen"
   :description "Scaffold up Love2D+Fennel projects")

(declare-executable
  :name "scaff"
  :entry "main.janet")


(phony "inst" ["build"]
       (print "Installing")
       (os/cd "build")
       (os/shell "inst scaff.exe")
       (os/cd "..")
       (print "Installed"))


