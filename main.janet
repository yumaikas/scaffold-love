(import spork/path)

(defn p [& args] (path/join ;args))
(defn .. [& args] (string ;args))

(defn- ensure-folder [path] 
  (let [info (os/stat path)]
    (match info
      {:mode :directory} (do)
      {:mode :file} (errorf "%s is a file instead of a directory" path)
      nil (os/mkdir path)
      _ (errorf "%s is a %s, should either not exist, or be a directory" path (info :mode)))
  ))

(defn copy-base [from to] 
  (unless (nil? (os/stat (p ;to))) 
    (error (.. "Path " (path/join to)  " already exists!")))

  (spit (p ;to) (slurp (p (os/getenv "LOVE2D_BASECODE") ;from))))

(defn init-proj [path]
  (or (os/getenv "LOVE2D_BASECODE") 
      (error "Please set LOVE2D_BASECODE to the folder with your love templates"))

  (ensure-folder "lib")
  (ensure-folder "game")
  (ensure-folder (p "game" "scenes"))
  (ensure-folder (p "game" "systems"))
  (ensure-folder "publish")
  (ensure-folder "projects")
  (ensure-folder "assets")

  (each [from to] [ [["init" "main.lua"] ["main.lua"]]
            [["init" "fennel.lua"] ["fennel.lua"]]
            [["init" "bootstrap.lua"] ["bootstrap.lua"]]
            [["init" "conf.lua"] ["conf.lua"]]
            [["init" "settings.fnl"] ["settings.fnl"]]
            [["init" "game.fnl"] ["game.fnl"]]
            [["reqdict.fnl"] ["scenes.fnl"]]
            [["init" "LICENSE"] ["LICENSE"]]
            [["init" "watch.ps1"] ["watch.ps1"]]
            [["init" "webPrep.ps1"] ["webPrep.ps1"]]
            [["lib" "c.fnl"] ["lib" "c.fnl"]]
            [["lib" "v.fnl"] ["lib" "v.fnl"]]
            [["lib" "f.fnl"] ["lib" "f.fnl"]]
            [["lib" "m.fnl"] ["lib" "m.fnl"]]
            [["assets" "Inconsolata.ttf"] ["assets" "Inconsolata.ttf"]]
            [["assets" "init.fnl"] ["assets" "init.fnl"]]
            [["scenes" "title.fnl"]["game" "scenes" "title.fnl"]]
            ]
    (copy-base from to)
    )
  )

(defn usage [] 
  (eprint ```
          scaff: Love2d+Fennel scaffolding tool

          Usage:

          scaff init # Sets up a project for love2d and fennel use
          scaff add scene <name> # Adds a scene named <name>.fnl to game/scenes
          scaff add system <name> # Adds a system named <name>.fnl to game/systems
          ```
    )
  )

(defn find-game [from]
  (cond
    (and
      (os/stat (path/join ;from "main.lua"))
      (os/stat (path/join ;from "fennel.lua"))
      (os/stat (path/join ;from "game.fnl")))
    (path/join ;from)
    (zero? (length from)) nil
    (find-game (slice from 0 -2))
    ))


(defn main [_ & args] 
  (defn game-base []
    (or 
      (find-game (path/parts (path/abspath ".")))
      (error "Not in a Love2d+Fennel game directory!")))

  (match args
    ["help"] (usage)
    ["init" ] (init-proj ".")
    ["add" "scene" name] (copy-base ["scenes" "basic.fnl"] [(game-base) "scenes" (.. name ".fnl") ])
    ["add" "system" name] (copy-base ["system.fnl"] [(game-base) "systems" (.. name ".fnl") ])
    ["add" "reqdict" name] (copy-base ["reqdict.fnl"] [(game-base) (.. name ".fnl") ])
    _ (do 
        (usage)
        (eprint (.. "Didn't recognize part of " args " as a command!")))
  ))
