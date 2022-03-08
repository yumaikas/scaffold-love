(import-macros { : imp : req : += : -= : *= : unless } :m)
(imp v) (imp f) (imp assets) (imp fennel)

(local random love.math.random)
(local noise love.math.noise)
(local gfx love.graphics)

(fn draw [me] 
  (gfx.origin)
  (gfx.setColor [0.4 0.4 1])
  (gfx.setFont assets.font)
  (gfx.print "YOUR GAME TITLE HERE" 20 20)
  (each [_ c (ipairs me.children)] (c:draw)))

(fn update [me dt]
  (if love.mouse.isJustPressed
    (set me.next { :update (fn [me dt] (love.event.quit)) }))

  (each [_ c (ipairs me.children)] (c:update dt)))

(fn make []
  {
   :children []
   :pos [40 40]
   :next false
   : update
   : draw
   })

{: make}

