local config = SMODS.current_mod.config

SMODS.Sound({
    key = 'music_konami',
    path = 'music_konami.ogg',
	pitch = 1,
	speed = 1,
    select_music_track = function(self)
        -- If it's konami time play music
        if G.konamiActive then
            return 1e10
        end
    end
})

-- =========================
-- Menu Auto-Trigger Logic
-- =========================
local upd = Game.update
function Game:update(dt)
    upd(self, dt)

    G.MenuWait = G.MenuWait or 0
	
	if love.mouse.isDown(1) then
		G.MenuWait = 0
	end

    if G.STAGE == G.STAGES.MAIN_MENU and not G.konamiActive then
        G.MenuWait = G.MenuWait + dt
        if G.MenuWait > 300 then
            G.FUNCS.activatekonami()
            G.MenuWait = 0
        end
    else
        G.MenuWait = 0
    end
end

-- =========================
-- Konami Game Container
-- =========================
G.KONAMI_GAME = {
    active = false,
    waitingToStart = true, -- Prevents enemies until input
    gameOver = false,
    buffer = {},
    
    -- Virtual canvas boundaries (Standard Balatro canvas target size)
    virtualWidth = 1280,
    virtualHeight = 720,
    
    -- Speeds mathematically downscaled from 1920x1080 baseline to match original feel
    cube = {width=64, height=64, x=0, y=0, speed=200}, -- 300 * (1280/1920)
    score = 0, lives = 3, maxLives = 3,
    
    isRespawning = false, respawnTimer = 0, invincibilityTimer = 0, flickerTimer = 0,
    powerups = {}, powerupSize = 40,
    turretTimer = 0, burstTimer = 0, turretShootCooldown = 0.3, turretLastShot = 0,
    enemies = {}, enemySize = 64, enemySpeed = 80, enemySpawnTimer = 0, enemySpawnRate = 1.0, -- 120 * (1280/1920)
    bullets = {}, bulletSpeed = 333, bulletSize = 12, shootCooldown = 0.5, lastShotTimer = 0.5, -- 500 * (1280/1920)
    
    boss = nil, bossWidth = 128, bossHeight = 128, bossSpeed = 133, -- 200 * (1280/1920)
    bossBulletSpeed = 200, bossCooldown = 0, bossCooldownRate = 1.0, -- 300 * (1280/1920)
    bossHitsRequired = 20, bossKills = 0, bossBullets = {},
    
    explosions = {}, floatingPoints = {}, explosionDuration = 0.3, floatingDuration = 0.8,
    images = {}
}

-- =========================
-- Activation & Reset Function
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.activatekonami = function()
    local k = G.KONAMI_GAME
    G.konamiActive = true
    k.waitingToStart = true -- Enable wait state on activation
    k.gameOver = false
    k.isRespawning = false
    k.invincibilityTimer = 0
    k.score = 0
    k.lives = k.maxLives
    k.enemySpeed = 80
    k.enemySpawnRate = 1.0
    k.bossKills = 0
    k.bossBulletSpeed = 200
    
    k.bullets, k.enemies, k.bossBullets, k.powerups, k.explosions, k.floatingPoints = {}, {}, {}, {}, {}, {}
    k.boss = nil
    
    -- Position based on fixed virtual size
    k.cube.x = (k.virtualWidth - k.cube.width) / 2
    k.cube.y = k.virtualHeight - k.cube.height - 40

    local function loadImg(name) 
        local f = NFS.newFileData(SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name) 
        return love.graphics.newImage(love.image.newImageData(f)) 
    end
    
    if not k.images.bg then
        k.images.bg = loadImg("space.png")
        k.images.cube = loadImg("pizza.png")
        k.images.enemy = loadImg("burger.png")
        k.images.bossBullet = loadImg("pineapple.png")
        k.images.bullet = loadImg("bullet.png")
        k.images.explosion = loadImg("explosion.png")
        k.images.p1 = loadImg("powerup.png")
        k.images.p2 = loadImg("powerup2.png")
        k.images.turret = loadImg("turret.png")
        k.images.launcher = loadImg("launcher.png")
    end
end

-- =========================
-- Local Helpers
-- =========================
local function spawnPowerup(x, y)
    local k = G.KONAMI_GAME
    if math.random(1, 20) == 1 then
        local pType = math.random(1, 2) == 1 and "turret" or "burst"
        table.insert(k.powerups, {x = x, y = y, type = pType})
    end
end

local function spawnEnemy()
    local k = G.KONAMI_GAME
    table.insert(k.enemies,{
        x = math.random(0, k.virtualWidth - k.enemySize),
        y = -k.enemySize,
        id = math.random(1, 1000000)
    })
end

local function shoot()
    local k = G.KONAMI_GAME
    if k.gameOver or k.isRespawning or k.lastShotTimer < k.shootCooldown then return end 

    if k.burstTimer > 0 then
        for i = -1, 1 do
            table.insert(k.bullets,{
                x = k.cube.x + k.cube.width/2 - k.bulletSize/2 + (i * 15),
                y = k.cube.y, homing = false, vx = i * 40, vy = -k.bulletSpeed
            })
        end
    else
        table.insert(k.bullets,{
            x = k.cube.x + k.cube.width/2 - k.bulletSize/2,
            y = k.cube.y, homing = false, vx = 0, vy = -k.bulletSpeed
        })
    end
    k.lastShotTimer = 0 
end

local function triggerDeath()
    local k = G.KONAMI_GAME
    k.lives = k.lives - 1
    k.isRespawning = true
    k.respawnTimer = 0.5 
    table.insert(k.explosions, {x = k.cube.x, y = k.cube.y, timer = k.explosionDuration})
    table.insert(k.floatingPoints, {x = k.cube.x + k.cube.width/2, y = k.cube.y, text = "-1 Life", timer = k.floatingDuration})
    k.bullets, k.turretTimer, k.burstTimer = {}, 0, 0
    if k.lives <= 0 then k.gameOver = true; k.isRespawning = false end
end

-- =========================
-- Collision Helpers
-- =========================
local function pointInTriangle(px, py, x1, y1, x2, y2, x3, y3)
    local function sign(x1,y1,x2,y2,x3,y3) return (x1-x3)*(y2-y3) - (x2-x3)*(y1-y3) end
    local b1 = sign(px,py,x1,y1,x2,y2,x3,y3) < 0.0
    local b2 = sign(px,py,x2,y2,x3,y3,x1,y1) < 0.0
    local b3 = sign(px,py,x3,y3,x1,y1,x2,y2) < 0.0
    return ((b1 == b2) and (b2 == b3))
end

local function rectIntersectsTriangle(rx, ry, rw, rh, tri)
    local corners = {{rx, ry}, {rx+rw, ry}, {rx, ry+rh}, {rx+rw, ry+rh}}
    for _,c in ipairs(corners) do
        if pointInTriangle(c[1], c[2], tri.x1, tri.y1, tri.x2, tri.y2, tri.x3, tri.y3) then return true end
    end
    return false
end

local function getPizzaTri()
    local k = G.KONAMI_GAME
    local x, y, w, h = k.cube.x, k.cube.y, k.cube.width, k.cube.height
    return {x1 = x + w/2, y1 = y, x2 = x, y2 = y + h, x3 = x + w, y3 = y + h}
end

-- =========================
-- Main Update
-- =========================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)
    local k = G.KONAMI_GAME
    
    if not G.konamiActive or k.gameOver or k.waitingToStart then return end

    local w, h = k.virtualWidth, k.virtualHeight

    if k.isRespawning then
        k.respawnTimer = k.respawnTimer - dt
        if k.respawnTimer <= 0 then
            k.isRespawning = false
            k.cube.x, k.cube.y = (w - k.cube.width) / 2, h - k.cube.height - 40
            k.invincibilityTimer = 2.0 
        end
        return 
    end

    k.invincibilityTimer = math.max(0, k.invincibilityTimer - dt)
    k.flickerTimer = k.flickerTimer + dt
    k.lastShotTimer = k.lastShotTimer + dt 
    if k.burstTimer > 0 then k.burstTimer = k.burstTimer - dt end

    if love.keyboard.isDown("left") then k.cube.x = k.cube.x - k.cube.speed*dt end
    if love.keyboard.isDown("a") then k.cube.x = k.cube.x - k.cube.speed*dt end
    if love.keyboard.isDown("right") then k.cube.x = k.cube.x + k.cube.speed*dt end
    if love.keyboard.isDown("d") then k.cube.x = k.cube.x + k.cube.speed*dt end
    k.cube.x = math.max(0, math.min(w - k.cube.width, k.cube.x))

    -- Target Acquisition
    local targetObj = nil
    if #k.enemies > 0 then
        local minDist = 999999
        for _, e in ipairs(k.enemies) do
            local dist = math.sqrt((e.x - (k.cube.x + k.cube.width/2))^2 + (e.y - (k.cube.y + k.cube.height/2))^2)
            if dist < minDist then minDist = dist; targetObj = e end
        end
    elseif k.boss then targetObj = k.boss end

    if targetObj then
        local tx, ty = targetObj.x + (targetObj.width or k.enemySize)/2, targetObj.y + (targetObj.height or k.enemySize)/2
        k.weaponAngle = math.atan2(ty - (k.cube.y + k.cube.height/2), tx - (k.cube.x + k.cube.width/2))
    else k.weaponAngle = -math.pi/2 end

    -- Powerups
    for i=#k.powerups, 1, -1 do
        local p = k.powerups[i]
        p.y = p.y + k.enemySpeed * 0.8 * dt
        if rectIntersectsTriangle(p.x, p.y, k.powerupSize, k.powerupSize, getPizzaTri()) then
            if p.type == "turret" then k.turretTimer = 10 else k.burstTimer = 10 end
            table.insert(k.floatingPoints, {x = p.x, y = p.y, text = "POWERUP!", timer = k.floatingDuration})
            table.remove(k.powerups, i)
        elseif p.y > h then table.remove(k.powerups, i) end
    end

    -- Turret
    if k.turretTimer > 0 then
        k.turretTimer = k.turretTimer - dt
        k.turretLastShot = k.turretLastShot + dt
        if k.turretLastShot >= k.turretShootCooldown and targetObj then
            table.insert(k.bullets, {
                x = k.cube.x + k.cube.width/2 - k.bulletSize/2, y = k.cube.y + k.cube.height/2,
                homing = true, targetId = targetObj.id or "BOSS", vx = 0, vy = -k.bulletSpeed
            })
            k.turretLastShot = 0
        end
    end

    -- Bullet Movement
    for i=#k.bullets,1,-1 do
        local b = k.bullets[i]
        if b.homing and b.targetId then
            local targetFound = (b.targetId == "BOSS" and k.boss) or nil
            if not targetFound then for _, e in ipairs(k.enemies) do if e.id == b.targetId then targetFound = e break end end end
            if targetFound then
                local tx, ty = targetFound.x + (targetFound.width or k.enemySize)/2, targetFound.y + (targetFound.height or k.enemySize)/2
                local angle = math.atan2(ty - b.y, tx - b.x)
                b.vx, b.vy = math.cos(angle) * k.bulletSpeed, math.sin(angle) * k.bulletSpeed
            else b.targetId = nil end
        end
        b.x, b.y = b.x + (b.vx or 0) * dt, b.y + (b.vy or -k.bulletSpeed) * dt
        if b.y + k.bulletSize < 0 or b.y > h or b.x < 0 or b.x > w then table.remove(k.bullets,i) end
    end

    -- Spawning
    if not k.boss then
        k.enemySpawnTimer = k.enemySpawnTimer + dt
        if k.enemySpawnTimer >= k.enemySpawnRate then k.enemySpawnTimer = 0; spawnEnemy() end
    end

    -- Collision & Enemy Logic
    local pTri = getPizzaTri()
    for i=#k.enemies,1,-1 do
        local e = k.enemies[i]
        e.y = e.y + k.enemySpeed*dt
        if k.invincibilityTimer <= 0 and rectIntersectsTriangle(e.x, e.y, k.enemySize, k.enemySize, pTri) then
            triggerDeath(); table.remove(k.enemies, i); break
        end
        if e.y > h then table.remove(k.enemies,i) end
    end

    -- Enemy Destruction
    for i=#k.enemies,1,-1 do
        local e = k.enemies[i]
        for j=#k.bullets,1,-1 do
            local b = k.bullets[j]
            -- FIXED: Changed '&&' to Lua 'and' keywords below
            if b.x < e.x + k.enemySize and b.x + k.bulletSize > e.x and b.y < e.y + k.enemySize and b.y + k.bulletSize > e.y then
                spawnPowerup(e.x, e.y)
                table.remove(k.enemies,i); table.remove(k.bullets,j)
                k.score, k.bossKills = k.score + 100, k.bossKills + 1
                table.insert(k.explosions, {x = e.x, y = e.y, timer = k.explosionDuration})
                table.insert(k.floatingPoints, {x = e.x + k.enemySize/2, y = e.y, text = "+100", timer = k.floatingDuration})
                if k.bossKills % 30 == 0 then 
                    k.boss = {x=(w-k.bossWidth)/2, y=50, hitsTaken=0, dir=1, id="BOSS"}
                end
                break
            end
        end
    end

    -- Boss Logic
    if k.boss then
        k.boss.x = k.boss.x + k.boss.dir*k.bossSpeed*dt
        if k.boss.x <= 0 then k.boss.x=0; k.boss.dir=1 elseif k.boss.x + k.bossWidth >= w then k.boss.x=w-k.bossWidth; k.boss.dir=-1 end
        k.bossCooldown = k.bossCooldown + dt
        if k.bossCooldown >= k.bossCooldownRate then
            k.bossCooldown = 0
            local spreadAngles = {math.pi/2 - 0.4, math.pi/2, math.pi/2 + 0.4}
            for _,angle in ipairs(spreadAngles) do
                table.insert(k.bossBullets,{x=k.boss.x + k.bossWidth/2, y=k.boss.y + k.bossHeight, dx=math.cos(angle)*k.bossBulletSpeed, dy=math.sin(angle)*k.bossBulletSpeed})
            end
        end
        for i=#k.bullets,1,-1 do
            local b = k.bullets[i]
            -- FIXED: Changed '&&' to Lua 'and' keywords below
            if b.x < k.boss.x + k.bossWidth and b.x + k.bulletSize > k.boss.x and b.y < k.boss.y + k.bossHeight and b.y + k.bulletSize > k.boss.y then
                k.boss.hitsTaken = k.boss.hitsTaken + 1; table.remove(k.bullets,i)
                if k.boss.hitsTaken >= k.bossHitsRequired then
                    k.score = k.score + 5000
                    table.insert(k.explosions, {x = k.boss.x, y = k.boss.y, timer = k.explosionDuration})
                    k.enemySpeed, k.enemySpawnRate = k.enemySpeed + 5, k.enemySpawnRate - 0.05
                    k.boss, k.bossBullets = nil, {}
                    break
                end
            end
        end
    end

    -- Final Visual Timers
    for i=#k.bossBullets,1,-1 do
        local b = k.bossBullets[i]
        b.x, b.y = b.x + (b.dx or 0)*dt, b.y + (b.dy or k.bossBulletSpeed)*dt
        if k.invincibilityTimer <= 0 and rectIntersectsTriangle(b.x, b.y, k.bulletSize, k.bulletSize, pTri) then 
            triggerDeath(); table.remove(k.bossBullets, i)
        elseif b.y > h or b.x < 0 or b.x > w then table.remove(k.bossBullets,i) end
    end
    for i=#k.explosions,1,-1 do k.explosions[i].timer = k.explosions[i].timer - dt; if k.explosions[i].timer <= 0 then table.remove(k.explosions,i) end end
    for i=#k.floatingPoints,1,-1 do
        local fp = k.floatingPoints[i]
        fp.y, fp.timer = fp.y - 50 * dt, fp.timer - dt
        if fp.timer <= 0 then table.remove(k.floatingPoints,i) end
    end
	
	-- Achievement
	if k.score then
		if k.score >= 100000 then
			check_for_unlock({ type = "ach_arcade" })
		end
	end
end

-- =========================
-- Main Draw
-- =========================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()
    local k = G.KONAMI_GAME
    if not G.konamiActive then return end
    
    -- Cache current graphics state
    love.graphics.push("all")
    
    -- Calculate scale matrix dynamically to match the window size cleanly
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local scaleX = windowWidth / k.virtualWidth
    local scaleY = windowHeight / k.virtualHeight
    
    -- Apply the scaling to normalize coordinate spaces
    love.graphics.scale(scaleX, scaleY)
    
    local gw, gh = k.virtualWidth, k.virtualHeight
    
    love.graphics.setColor(1,1,1,1)
    if k.images.bg then love.graphics.draw(k.images.bg, 0, 0, 0, gw/k.images.bg:getWidth(), gh/k.images.bg:getHeight()) end

    love.graphics.printf(tostring(k.score),0,10,gw,"center")
    love.graphics.printf("Lives: "..k.lives, 0, 10, gw-10, "right")

    -- Draw Ship
    if not k.isRespawning and (k.invincibilityTimer <= 0 or math.floor(k.flickerTimer * 10) % 2 == 0) then
        love.graphics.draw(k.images.cube, k.cube.x, k.cube.y, 0, k.cube.width/k.images.cube:getWidth(), k.cube.height/k.images.cube:getHeight())
        local weaponImg = (k.turretTimer > 0 and k.images.turret) or (k.burstTimer > 0 and k.images.launcher)
        if weaponImg then
            love.graphics.draw(weaponImg, k.cube.x + k.cube.width/2, k.cube.y + k.cube.height/2, k.weaponAngle + math.pi/2, (k.cube.width*0.4)/weaponImg:getWidth(), (k.cube.height*0.4)/weaponImg:getHeight(), weaponImg:getWidth()/2, weaponImg:getHeight()/2)
        end
    end

    -- Draw Entities
    for _, p in ipairs(k.powerups) do
        local img = (p.type == "turret") and k.images.p1 or k.images.p2
        love.graphics.draw(img, p.x, p.y, 0, k.powerupSize/img:getWidth(), k.powerupSize/img:getHeight())
    end
    for _,b in ipairs(k.bullets) do
        if b.homing then love.graphics.setColor(0, 1, 1) end
        love.graphics.draw(k.images.bullet, b.x, b.y, 0, k.bulletSize/k.images.bullet:getWidth(), k.bulletSize/k.images.bullet:getHeight())
        love.graphics.setColor(1,1,1)
    end
    for _,e in ipairs(k.enemies) do
        love.graphics.draw(k.images.enemy, e.x, e.y, 0, k.enemySize/k.images.enemy:getWidth(), k.enemySize/k.images.enemy:getHeight())
    end
    if k.boss then
        love.graphics.draw(k.images.enemy, k.boss.x, k.boss.y, 0, k.bossWidth/k.images.enemy:getWidth(), k.bossHeight/k.images.enemy:getHeight())
    end
    for _,b in ipairs(k.bossBullets) do love.graphics.draw(k.images.bossBullet, b.x, b.y, 0, k.bulletSize/k.images.bossBullet:getWidth(), k.bulletSize/k.images.bossBullet:getHeight()) end
    for _,ex in ipairs(k.explosions) do love.graphics.draw(k.images.explosion, ex.x, ex.y, 0, k.enemySize/k.images.explosion:getWidth(), k.enemySize/k.images.explosion:getHeight()) end

    -- Floating Text
    for _,fp in ipairs(k.floatingPoints) do
        love.graphics.setColor(1,1,0); love.graphics.printf(fp.text, fp.x-150, fp.y, 300, "center"); love.graphics.setColor(1,1,1)
    end

    -- Overlays
    if k.waitingToStart then
        love.graphics.printf("PRESS Z OR ENTER TO PLAY OR ESC TO QUIT", 0, gh/2 - 20, gw, "center")
    end
    if k.gameOver then 
        love.graphics.printf("GAME OVER",0,gh/2-20,gw,"center") 
    end
    
    -- Revert scaling context back safely for Balatro native UI
    love.graphics.pop()
end

-- =========================
-- Input handling
-- =========================
local old_kp = love.keypressed or function() end
function love.keypressed(key)
    old_kp(key)
    local k = G.KONAMI_GAME
    
    -- Active Game Input
    if key == "escape" then 
        G.konamiActive = false 
        return
    end

    if k.waitingToStart then
        if key == "z" or key == "return" then
            k.waitingToStart = false
            k.invincibilityTimer = 1.0
        end
        return
    end
    
    if k.gameOver and (key == "z" or key == "return" or key == "space") then 
        G.FUNCS.activatekonami()
    elseif not k.gameOver and (key == "z" or key == "return" or key == "space") then 
        shoot() 
    end
end


-- Mouse disabling
local old_mousepressed = love.mousepressed or function() end
function love.mousepressed(x,y,button,istouch,presses) if not G.konamiActive then old_mousepressed(x,y,button,istouch,presses) end end
local old_mousereleased = love.mousereleased or function() end
function love.mousereleased(x,y,button,istouch,presses) if not G.konamiActive then old_mousereleased(x,y,button,istouch,presses) end end

SMODS.Sound({
    key = 'music_luigi',
    path = 'music_luigi.ogg',
	pitch = 1,
	speed = 1,
    select_music_track = function(self)
        -- If it's luigi time play music
        if G.FIND_GAME.active then
            return 1e10
        end
    end
})

SMODS.Sound({
	key = "ned",
	path = "ned.ogg",
})

local function loadImg(name) 
    local path = SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name
    local fileData = NFS.newFileData(path) 
    return love.graphics.newImage(love.image.newImageData(fileData)) 
end

-- =========================
-- Find Target Game Container
-- =========================
G.FIND_GAME = {
    active = false,
    won = false,
    answered = false,
    eval_pending = false,
    timer = 30,
    max_time = 30,
    target = nil,
    decoys = {},
    decoyCount = 0,
    baseSpeed = 300,    
    entitiesSize = 64,  
    images = {},
    -- VIRTUAL DIMENSIONS
    virtualW = 1280,
    virtualH = 720
}

-- =========================
-- Initialization & Trigger Logic
-- =========================
G.FUNCS = G.FUNCS or {}

G.FUNCS.trigger_find_minigame = function()
    local f = G.FIND_GAME
    f.active = false
    f.won = false
    f.answered = false
    f.eval_pending = false
    f.timer = f.max_time
    G.FUNCS.start_find_game()
end

G.FUNCS.start_find_game = function()
    local f = G.FIND_GAME
    local vw, vh = f.virtualW, f.virtualH
    
    f.active = true
    f.won = false
    f.answered = false
    f.eval_pending = false
    f.timer = f.max_time
    f.decoys = {}
    f.decoyCount = math.random(100, 400)

    local function loadImg(name) 
        local path = SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name
        local fileData = NFS.newFileData(path) 
        return love.graphics.newImage(love.image.newImageData(fileData)) 
    end

    if not f.images.target then
        f.images.target = loadImg("luigi.png")
        f.images.d1 = loadImg("mario.png")
        f.images.d2 = loadImg("wario.png")
        f.images.d3 = loadImg("yoshi.png")
    end

    -- 1. Setup Target
    f.target = {
        x = math.random(100, vw - 100),
        y = math.random(100, vh - 100),
        vx = math.random(-f.baseSpeed, f.baseSpeed),
        vy = math.random(-f.baseSpeed, f.baseSpeed),
        size = f.entitiesSize - 20,
        img = f.images.target
    }

    -- 2. Setup Decoys
    local decoyPool = {f.images.d1, f.images.d2, f.images.d3}
    for i = 1, f.decoyCount do
        table.insert(f.decoys, {
            x = math.random(0, vw - f.entitiesSize),
            y = math.random(0, vh - f.entitiesSize),
            vx = math.random(-f.baseSpeed, f.baseSpeed),
            vy = math.random(-f.baseSpeed, f.baseSpeed),
            size = f.entitiesSize,
            img = decoyPool[math.random(#decoyPool)]
        })
    end
end

-- =========================
-- Gate Check Logic
-- =========================
function G.FUNCS.find_game_gate()
    local f = G.FIND_GAME

    -- Safety Check: If the player doesn't have Ned, never block scoring
    if #SMODS.find_card("j_fn_Ned") == 0 then
        return false
    end

    -- AUTO-START: Start minigame if not currently active or answered
    if not f.active and not f.answered then
        G.FUNCS.trigger_find_minigame()
        return true
    end

    -- Resume scoring once minigame is resolved
    if not f.active and f.answered then
        return false
    end

    -- Win Condition Catch
    if f.won and not f.answered then
        f.answered = true
        f.eval_pending = true
    end

    -- Return true to hold G.FUNCS.evaluate_play()
    return not f.answered
end

-- =========================
-- Update Loop
-- =========================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)
    local f = G.FIND_GAME
    if not f.active or f.won then return end

    local vw, vh = f.virtualW, f.virtualH

    local is_paused = (G.SETTINGS and G.SETTINGS.paused) or (G.STATE == G.STATES.PAUSE)

    if not is_paused then
        -- 1. Decrement Timer globally in love.update
        f.timer = f.timer - dt
        if f.timer <= 0 then
            f.timer = 0
            f.active = false
            f.won = false
            f.answered = true
            f.eval_pending = true
        end

        -- 2. Move entities
        local function moveAndBounce(obj)
            obj.x = obj.x + obj.vx * dt
            obj.y = obj.y + obj.vy * dt

            if obj.x <= 0 then 
                obj.x = 0
                obj.vx = math.abs(obj.vx) 
            end
            if obj.x >= vw - obj.size then 
                obj.x = vw - obj.size
                obj.vx = -math.abs(obj.vx) 
            end
            if obj.y <= 0 then 
                obj.y = 0
                obj.vy = math.abs(obj.vy) 
            end
            if obj.y >= vh - obj.size then 
                obj.y = vh - obj.size
                obj.vy = -math.abs(obj.vy) 
            end
        end

        if f.target then moveAndBounce(f.target) end
        for _, d in ipairs(f.decoys) do moveAndBounce(d) end
    end
end

-- =========================
-- Drawing Loop
-- =========================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()
    local f = G.FIND_GAME
    if not f.active then return end

    local realW, realH = love.graphics.getDimensions()
    local scaleX = realW / f.virtualW
    local scaleY = realH / f.virtualH

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    love.graphics.setColor(1, 1, 1, 1)

    -- Target
    local is_paused = (G.SETTINGS and G.SETTINGS.paused) or (G.STATE == G.STATES.PAUSE)
    local t = f.target
    if t and not is_paused then
        love.graphics.draw(t.img, t.x, t.y, 0, t.size/t.img:getWidth(), t.size/t.img:getHeight())
    end

    -- Decoys
    for i = 1, #f.decoys do
        local d = f.decoys[i]
        love.graphics.draw(d.img, d.x, d.y, 0, d.size/d.img:getWidth(), d.size/d.img:getHeight())
    end

    -- UI & Timer
    if f.active and not f.won then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 20, 20, 200, 50, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(string.format("Time: %.1fs", math.max(0, f.timer)), 20, 32, 200, "center")
    end

    if f.won then
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", 0, 0, f.virtualW, f.virtualH)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("FOUND LUIGI!", 0, f.virtualH/2 - 40, f.virtualW, "center", 0, 3, 3)
    end

    love.graphics.pop()
end

-- =========================
-- Mouse Interaction
-- =========================
local old_mouse = love.mousepressed or function() end
function love.mousepressed(rx, ry, button)
    local f = G.FIND_GAME
    
    local realW, realH = love.graphics.getDimensions()
    local x = rx * (f.virtualW / realW)
    local y = ry * (f.virtualH / realH)

    local is_paused = (G.SETTINGS and G.SETTINGS.paused) or (G.STATE == G.STATES.PAUSE)
    if not f.active or f.won or is_paused then 
        old_mouse(rx, ry, button)
        return 
    end

    if button == 1 then
        local t = f.target
        if x >= t.x and x <= t.x + t.size and y >= t.y and y <= t.y + t.size then
            if config and config.sfx ~= false then
                play_sound("fn_ned") 
            end
            f.won = true
            f.active = false
            f.answered = true
            f.eval_pending = true
            
            if not G.GAME.Practice then
                G.GAME.find_wins = (G.GAME.find_wins or 0) + 1
            else
                G.GAME.Practice = false
            end
        end
    end
end

SMODS.Sound({
	key = "wonkee",
	path = "wonkee.ogg",
})

SMODS.Sound({
	key = "hit",
	path = "hit.ogg",
})

SMODS.Sound({
    key = 'music_wonkee',
    path = 'music_wonkee.ogg',
	pitch = 1,
	speed = 1,
    select_music_track = function(self)
        -- If it's Wonkee time play music
        if G.CARNIVAL_GAME.active then
            return 1e10
        end
    end
})


-- =========================
-- Carnival Game Container
-- =========================
G.CARNIVAL_GAME = {
    active = false,
    waiting_to_start = false,
    timer = 0,
    score = 0,
    shots_taken = 0,    -- Tracked for accuracy
    hits = 0,           -- Tracked for accuracy
    display_timer = 0,
    targets = {},
    blockers = {},
    rows = 2,           
    cols = 5,           
    blockerCount = 4,   
    entitiesSize = 80,
    images = {},
    font = nil,
    -- VIRTUAL DIMENSIONS
    virtualW = 1280,
    virtualH = 720
}

-- =========================
-- Initialization Logic
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_carnival_game = function()
    local c = G.CARNIVAL_GAME
    -- Use Virtual Bounds for setup
    local vw, vh = c.virtualW, c.virtualH
    
    c.waiting_to_start = true 
    c.active = false
    c.timer = 30
    c.score = 0
    c.shots_taken = 0   -- Reset stats
    c.hits = 0          -- Reset stats
    c.display_timer = 0
    c.targets = {}
    c.blockers = {}

    local function loadImg(name) 
        local path = SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name
        local fileData = NFS.newFileData(path) 
        return love.graphics.newImage(love.image.newImageData(fileData)) 
    end

    if not c.images.target then
        c.images.target = loadImg("target.png")
        c.images.wonkee = loadImg("wonkee.png")
        c.font = love.graphics.newFont(40)
    end

    -- Setup Pop-up Targets (Using Virtual Width/Height)
    for r = 1, c.rows do
        for i = 1, c.cols do
            table.insert(c.targets, {
                x = (vw / (c.cols + 1)) * i - (c.entitiesSize / 2),
                y = vh * (0.30 + (r * 0.18)), 
                row = r,
                offsetY = 0,
                state = "down",
                timer = math.random(2, 7),
                size = c.entitiesSize - (r == 1 and 20 or 0),
                img = c.images.target
            })
        end
    end

    -- Setup Sliding Blockers (Using Virtual Width/Height)
    for i = 1, c.blockerCount do
        local row_assign = (i % 2) + 1 
        local target_size = c.entitiesSize - (row_assign == 1 and 20 or 0)
        table.insert(c.blockers, {
            x = math.random(0, vw - c.entitiesSize),
            y = vh * (0.30 + (row_assign * 0.18)) - target_size, 
            row = row_assign,
            vx = math.random(250, 500) * (math.random() > 0.5 and 1 or -1),
            size = c.entitiesSize + 20,
            img = c.images.wonkee
        })
    end
end

-- =========================
-- Update Loop
-- =========================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)
    local c = G.CARNIVAL_GAME
    
    -- Display results briefly before clearing
    if not c.active and not c.waiting_to_start and c.timer <= 0 and (c.score ~= 0 or c.shots_taken > 0) then
        c.display_timer = c.display_timer + dt
        if c.display_timer >= 4 then  -- Increased to 4 seconds to read stats
            c.score = 0
            c.shots_taken = 0
            c.hits = 0
            c.display_timer = 0
        end
        return
    end

    if not c.active then return end

    -- Use Virtual Bounds for movement logic
    local vw = c.virtualW
    c.timer = c.timer - dt
    
    if c.timer <= 0 then
        c.timer = 0
        c.active = false
        c.targets = {}   
        c.blockers = {}  
		if not G.GAME.Practice then
			G.GAME.WonkeeScore = c.score
		else
			G.GAME.WonkeeScore = 0
		end
        return 
    end

    -- Update Targets (Timing and Animation)
    for _, t in ipairs(c.targets) do
        t.timer = t.timer - dt
        if t.timer <= 0 then
            if t.state == "down" then t.state = "popping" 
            elseif t.state == "up" then t.state = "hiding" end
        end
        if t.state == "popping" then
            t.offsetY = t.offsetY + 450 * dt
            if t.offsetY >= t.size then t.state = "up"; t.timer = math.random(1, 2) end
        elseif t.state == "hiding" then
            t.offsetY = t.offsetY - 450 * dt
            if t.offsetY <= 0 then t.offsetY = 0; t.state = "down"; t.timer = math.random(3, 8) end
        end
    end

    -- Update Blockers (Virtual Boundary Snapping)
    for _, b in ipairs(c.blockers) do
        b.x = b.x + b.vx * dt
        if b.x <= 0 then 
            b.x = 0
            b.vx = math.abs(b.vx)
        elseif b.x >= vw - b.size then 
            b.x = vw - b.size
            b.vx = -math.abs(b.vx)
        end
    end
end

-- =========================
-- Drawing Loop
-- =========================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()
    local c = G.CARNIVAL_GAME
    local realW, realH = love.graphics.getDimensions()
    local scaleX = realW / c.virtualW
    local scaleY = realH / c.virtualH
    local old_font = love.graphics.getFont()

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)

    -- START SCREEN
    if c.waiting_to_start then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, c.virtualW, c.virtualH)
        love.graphics.setColor(1, 1, 1, 1)
        if c.font then love.graphics.setFont(c.font) end
        local instruct = "Zip Zonk Bang\n\nShoot the outlaws for points!\nAvoid shooting Wonkee! (-1 point)\n\nCLICK ANYWHERE TO START"
        love.graphics.printf(instruct, 0, c.virtualH/2 - 120, c.virtualW, "center")
    end

    -- GAMEPLAY
    if c.active then
        love.graphics.setColor(1, 1, 1, 1)
        for r = 1, c.rows do
            for _, t in ipairs(c.targets) do
                if t.row == r and t.state ~= "down" then
                    love.graphics.draw(t.img, t.x, t.y - t.offsetY, 0, t.size/t.img:getWidth(), t.size/t.img:getHeight())
                end
            end
            for _, b in ipairs(c.blockers) do
                if b.row == r then
                    love.graphics.draw(b.img, b.x, b.y, 0, b.size/b.img:getWidth(), b.size/b.img:getHeight())
                end
            end
        end
        -- UI (Optional: Add a live score/timer here if desired)
    end

    -- END SCREEN (Accuracy Added)
    if not c.active and not c.waiting_to_start and c.timer <= 0 and (c.score ~= 0 or c.shots_taken > 0) then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, c.virtualW, c.virtualH)
        love.graphics.setColor(1, 1, 1, 1)
        if c.font then love.graphics.setFont(c.font) end
        
        -- Calculate Accuracy Percentage
        local accuracy = 0
        if c.shots_taken > 0 then
            accuracy = math.floor((c.hits / c.shots_taken) * 100)
        end

        local result_text = "TIME'S UP!\n\nFINAL SCORE: " .. c.score .. "\nACCURACY: " .. accuracy .. "%"
        love.graphics.printf(result_text, 0, c.virtualH/2 - 80, c.virtualW, "center")
    end

    love.graphics.pop() 
    love.graphics.setFont(old_font)
end

-- =========================
-- Mouse Interaction
-- =========================
local old_mouse = love.mousepressed or function() end
function love.mousepressed(rx, ry, button)
    local c = G.CARNIVAL_GAME
    
    -- Convert Real Mouse X/Y to Virtual X/Y
    local realW, realH = love.graphics.getDimensions()
    local x = rx * (c.virtualW / realW)
    local y = ry * (c.virtualH / realH)
    
    if c.waiting_to_start then
        c.waiting_to_start = false
        c.active = true
        return
    end

    if not c.active then 
        old_mouse(rx, ry, button)
        return 
    end

    if button == 1 then
        -- Register a shot taken
        c.shots_taken = c.shots_taken + 1

        for r = c.rows, 1, -1 do
            -- Hit Detection for Blockers
            for _, b in ipairs(c.blockers) do
                if b.row == r and x >= b.x and x <= b.x + b.size and y >= b.y and y <= b.y + b.size then
                    c.score = c.score - 1
					if not G.GAME.Practice then
						G.GAME.WonkeeScore = c.score
					else 
						G.GAME.WonkeeScore = 0
					end
                    play_sound("fn_wonkee") 
                    return -- Exit loop so we don't hit things behind it
                end
            end
            -- Hit Detection for Targets
            for _, t in ipairs(c.targets) do
                local drawY = t.y - t.offsetY
                if t.row == r and x >= t.x and x <= t.x + t.size and y >= drawY and y <= drawY + t.size then
                    if t.state == "up" or t.state == "popping" then
                        c.score = c.score + 1
                        c.hits = c.hits + 1 -- Register a successful hit
                        play_sound("fn_hit") 
                        t.state = "hiding"
                        t.timer = 1.5
						if not G.GAME.Practice then
							G.GAME.WonkeeScore = c.score
						else
							G.GAME.WonkeeScore = 0
						end
                        return -- Exit loop
                    end
                end
            end
        end
    end
end

-- ==========================================
-- DVD Minigame Global State
-- ==========================================
G.DVD_GAME = {
    x = 100,
    y = 100,
    vx = 220, 
    vy = 220, 
    w = 120,  
    h = 80,   
    -- VIRTUAL DIMENSIONS: This prevents the resize exploit
    virtualW = 1280, 
    virtualH = 720,
    logo = nil,
    initialized = false,
    threshold = 10,     -- Magnet range
    hit_cooldown = 0    -- Prevents getting stuck in the corner
}

-- ==========================================
-- Update Logic
-- ==========================================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)

    -- Check if the Joker exists (j_fn_TV)
    if G.STAGE == G.STAGES.RUN and next(SMODS.find_card('j_fn_TV')) then
        local d = G.DVD_GAME
        
        -- 1. Load Image once
        if not d.initialized then
            local path = SMODS.Mods["Fortlatro"].path .. "/customimages/dvd.png"
            local fileData = NFS.newFileData(path)
            if fileData then
                d.logo = love.graphics.newImage(love.image.newImageData(fileData))
                d.initialized = true
            end
        end

        -- 2. Update Cooldown
        if d.hit_cooldown > 0 then
            d.hit_cooldown = d.hit_cooldown - dt
        end

        -- 3. Movement (Logic uses Virtual Bounds)
        d.x = d.x + d.vx * dt
        d.y = d.y + d.vy * dt

        -- 4. Corner Magnet Logic (Using Virtual Bounds)
        local near_left = d.x < d.threshold
        local near_right = d.x > (d.virtualW - d.w - d.threshold)
        local near_top = d.y < d.threshold
        local near_bottom = d.y > (d.virtualH - d.h - d.threshold)

        if d.hit_cooldown <= 0 and (near_left or near_right) and (near_top or near_bottom) then
            -- Snap to virtual corner
            d.x = near_left and 0 or (d.virtualW - d.w)
            d.y = near_top and 0 or (d.virtualH - d.h)
            
            -- Bounce away
            d.vx = -d.vx
            d.vy = -d.vy
            
            -- Scoring & Safety
            G.GAME.DVDScore = (G.GAME.DVDScore or 0) + 1
            d.hit_cooldown = 1 
        else
            -- 5. Standard Wall Bouncing (Virtual Bounds)
            if d.x <= 0 then
                d.x = 0
                d.vx = math.abs(d.vx)
            elseif d.x >= d.virtualW - d.w then
                d.x = d.virtualW - d.w
                d.vx = -math.abs(d.vx)
            end

            if d.y <= 0 then
                d.y = 0
                d.vy = math.abs(d.vy)
            elseif d.y >= d.virtualH - d.h then
                d.y = d.virtualH - d.h
                d.vy = -math.abs(d.vy)
            end
        end
    end
end

-- ==========================================
-- Drawing Logic
-- ==========================================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()

    if G.STAGE == G.STAGES.RUN and next(SMODS.find_card('j_fn_TV')) then
        local d = G.DVD_GAME
        if d.logo then
            -- Get actual window size to calculate scaling
            local realW, realH = love.graphics.getDimensions()
            local scaleX = realW / d.virtualW
            local scaleY = realH / d.virtualH

            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(1, 1, 1, 1)
            
            -- Draw scaled to the player's screen
            love.graphics.draw(
                d.logo, 
                d.x * scaleX, 
                d.y * scaleY, 
                0, 
                (d.w / d.logo:getWidth()) * scaleX, 
                (d.h / d.logo:getHeight()) * scaleY
            )
            
            love.graphics.setColor(r, g, b, a)
        end
    end
end


SMODS.Sound({
    key = 'music_voyager',
    path = 'music_voyager.ogg',
	pitch = 1,
	speed = 1,
    select_music_track = function(self)
        -- If it's Voyager time play music
        if G.DODGE_GAME.active then
            return 1e10
        end
    end
})

-- =========================
-- Dodge Game Container
-- =========================
G.DODGE_GAME = {
    active = false,
    timer = 0,           
    spawn_timer = 0,
    beams = {},
    beam_width = 40,      
    warning_time = 2.0,  
    active_time = 0.5,   
    images = {},
    virtualW = 1280,
    virtualH = 720,
    -- HP and UI
    hp = 3,
    font = nil,
    -- Shake variables
    shake_timer = 0,
    shake_mag = 0
}

-- =========================
-- Initialization Logic
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_dodge_game = function()
    local d = G.DODGE_GAME
    d.active = true
    d.timer = 0
    d.spawn_timer = 0
    d.beams = {}
    d.shake_timer = 0
    d.shake_mag = 0
    d.hp = 3 -- Reset HP on start

    local function loadImg(name) 
        local path = SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name
        local fileData = NFS.newFileData(path) 
        return love.graphics.newImage(love.image.newImageData(fileData)) 
    end

    if not d.images.warning then
        d.images.warning = loadImg("warning.png")
        d.font = love.graphics.newFont(32) -- Initialize font for HP display
    end
end

-- =========================
-- Update Loop
-- =========================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)
    local d = G.DODGE_GAME
    if not d.active then return end

    -- Determine gamespeed scaling modifier
    -- Baseline is 4, so we default to 4 if G.SETTINGS isn't ready yet
    local current_speed = (G.SETTINGS and G.SETTINGS.GAMESPEED) or 4 
    local speed_mod = 1
    
    -- If playing lower than 4x speed, calculate a multiplier to slow things down
    if current_speed ~= 4 then
        speed_mod = 4 / current_speed
    end

    d.timer = d.timer + dt
    d.spawn_timer = d.spawn_timer - dt

    -- Handle shake decay
    if d.shake_timer > 0 then
        d.shake_timer = d.shake_timer - dt
        d.shake_mag = d.shake_mag * 0.9 
    else
        d.shake_mag = 0
    end

    -- Spawning logic
    if d.spawn_timer <= 0 then
        local realW, realH = love.graphics.getDimensions()
        local mx = love.mouse.getX() * (d.virtualW / realW)
        local my = love.mouse.getY() * (d.virtualH / realH)
        
        local horizontal = math.random() > 0.5
        
        -- Scale individual beam warning timers up if game speed is lower
        local dynamic_warning = d.warning_time * speed_mod

        table.insert(d.beams, {
            horizontal = horizontal,
            pos = horizontal and my or mx, 
            timer = dynamic_warning,
            state = "warning",
            has_hit = false -- Track if this specific beam already dealt damage
        })

        -- Base spawn rate scales up (slower spawns) on lower game speeds
        d.spawn_timer = 1.1 * speed_mod 
    end

    local realW, realH = love.graphics.getDimensions()
    local mx = love.mouse.getX() * (d.virtualW / realW)
    local my = love.mouse.getY() * (d.virtualH / realH)

    for i = #d.beams, 1, -1 do
        local b = d.beams[i]
        b.timer = b.timer - dt

        if b.state == "warning" and b.timer <= 0 then
            b.state = "active"
            -- Laser stays active longer in game-time to match slower real-world speeds
            b.timer = d.active_time * speed_mod
            d.shake_timer = 0.2
            d.shake_mag = 12
        elseif b.state == "active" then
            -- Collision Check
            local cursor_pos = b.horizontal and my or mx
            if not b.has_hit and math.abs(cursor_pos - b.pos) < (d.beam_width / 2) then
                b.has_hit = true -- Prevent multi-hits from one beam
                d.hp = d.hp - 1
                
                if d.hp <= 0 then
                    d.active = false
                    d.shake_timer = 0
					if not G.GAME.Practice then
						G.GAME.ForcedFail = true
					end
                    return
                end
            end

            if b.timer <= 0 then
                table.remove(d.beams, i)
            end
        end
    end
end

-- =========================
-- Drawing Loop
-- =========================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()
    local d = G.DODGE_GAME
    if not d.active then return end

    local default_font = love.graphics.getFont()
    local realW, realH = love.graphics.getDimensions()
    local scaleX = realW / d.virtualW
    local scaleY = realH / d.virtualH

    love.graphics.push()
    
    -- Apply screen shake
    if d.shake_timer > 0 then
        love.graphics.translate(
            math.random(-d.shake_mag, d.shake_mag),
            math.random(-d.shake_mag, d.shake_mag)
        )
    end

    love.graphics.scale(scaleX, scaleY)

    for _, b in ipairs(d.beams) do
        local half_w = d.beam_width / 2

        if b.state == "warning" then
            local alpha = (math.sin(d.timer * 20) * 0.2) + 0.3
            love.graphics.setColor(1, 0, 0, alpha) 
            
            if b.horizontal then
                love.graphics.rectangle("fill", 0, b.pos - half_w, d.virtualW, d.beam_width)
            else
                love.graphics.rectangle("fill", b.pos - half_w, 0, d.beam_width, d.virtualH)
            end
            
            love.graphics.setColor(1, 1, 1, 1)
            if b.horizontal then
                love.graphics.draw(d.images.warning, 50, b.pos - 20, 0, 40/d.images.warning:getWidth(), 40/d.images.warning:getHeight())
            else
                love.graphics.draw(d.images.warning, b.pos - 20, 50, 0, 40/d.images.warning:getWidth(), 40/d.images.warning:getHeight())
            end

        elseif b.state == "active" then
            -- If player was hit by this beam, make it flicker or change color slightly
            if b.has_hit then
                love.graphics.setColor(1, 0.2, 0.2, 1) 
            else
                love.graphics.setColor(1, 0.5, 0, 1) 
            end

            if b.horizontal then
                love.graphics.rectangle("fill", 0, b.pos - half_w, d.virtualW, d.beam_width)
            else
                love.graphics.rectangle("fill", b.pos - half_w, 0, d.beam_width, d.virtualH)
            end
            
            love.graphics.setColor(1, 0.9, 0.5, 1) 
            local core_size = 6
            if b.horizontal then
                love.graphics.rectangle("fill", 0, b.pos - (core_size/2), d.virtualW, core_size)
            else
                love.graphics.rectangle("fill", b.pos - (core_size/2), 0, core_size, d.virtualH)
            end
        end
    end

    -- HUD / HP Display
    if d.font then
        love.graphics.setFont(d.font)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("HEALTH: " .. d.hp, 950, 50)
        love.graphics.setFont(default_font)
    end

    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
    if G.GAME.blind and G.GAME.blind.name == 'Dark Voyager' and not G.GAME.blind.disabled and G.STATE ~= 8 then
        G.FUNCS.start_dodge_game()
		G.DODGE_GAME.shake_timer = 0
    end
end

local end_round_original = end_round
function end_round()
    -- Call the original end_round
    end_round_original()
	G.DODGE_GAME.active = false
    G.DODGE_GAME.beams = {} 
	G.DODGE_GAME.shake_timer = 0
end


SMODS.Sound({
	key = "damage1",
	path = "damage1.ogg",
})

SMODS.Sound({
	key = "damage2",
	path = "damage2.ogg",
})

SMODS.Sound({
	key = "damage3",
	path = "damage3.ogg",
})

SMODS.Sound({
    key = 'music_atlas',
    path = 'music_atlas.ogg',
	pitch = 1,
	speed = 1,
    select_music_track = function(self)
        -- If it's Atlas time play music
        if G.DEFENSE_GAME.active then
            return 1e10
        end
    end
})

-- =========================
-- Defense Game Container
-- =========================
G.DEFENSE_GAME = {
    active = false,
    state = "STARTING", -- "STARTING" or "PLAYING"
    start_timer = 5,    -- Countdown duration in seconds
    virtualW = 1280,
    virtualH = 720,
    center = {x = 640, y = 360},
    shield_angle = 0, 
    shield_width = 1.4, 
    shield_radius = 120,
    bullets = {},
    spawn_timer = 0,
    
    difficulty = 1.0,        
    bullet_speed_base = 450, 
    
    -- Visual Scaling
    entitiesSize = 80,       
    atlasScaleFactor = 1.6,
    shieldVisualScale = 0.9, 
    hp = 3,
    images = {},
    font = nil,
    default_font = nil,
    cardinal_angles = {0, math.pi/2, math.pi, -math.pi/2}
}

-- =========================
-- Initialization
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_defense_game = function()
    local dg = G.DEFENSE_GAME
    dg.active = true
    dg.state = "STARTING"
    dg.start_timer = 3 -- 3 second countdown
    dg.hp = 3
    dg.bullets = {}
    dg.spawn_timer = 0
    dg.shield_angle = 0

    local function loadImg(name) 
        local path = SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name
        local fileData = NFS.newFileData(path) 
        return love.graphics.newImage(love.image.newImageData(fileData)) 
    end

    if not dg.images.atlas then
        dg.images.atlas = loadImg("atlas.png")
        dg.images.shield = loadImg("shield.png")
        dg.images.husk = loadImg("husk.png")
        dg.font = love.graphics.newFont(32)
    end
end

-- =========================
-- Update Loop
-- =========================
local old_upd = Game.update
function Game:update(dt)
    if old_upd then old_upd(self, dt) end
    local dg = G.DEFENSE_GAME
    if not dg.active then return end

    -- Determine gamespeed scaling modifier
    local current_speed = (G.SETTINGS and G.SETTINGS.GAMESPEED) or 4
    local speed_mod = 1
    
    -- If playing lower than 4x speed, calculate a multiplier to ease the difficulty
    if current_speed ~= 4 then
        speed_mod = 4 / current_speed
    end

    -- Handle Countdown State
    if dg.state == "STARTING" then
        dg.start_timer = dg.start_timer - dt
        if dg.start_timer <= 0 then
            dg.state = "PLAYING"
        end
        return -- Don't run game logic yet
    end

    -- Snapping Shield Logic
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then 
        dg.shield_angle = -math.pi/2 
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then 
        dg.shield_angle = math.pi/2
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then 
        dg.shield_angle = math.pi
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then 
        dg.shield_angle = 0
    end

    -- Spawn Bullets
    dg.spawn_timer = dg.spawn_timer - dt
    if dg.spawn_timer <= 0 then
        local angle = dg.cardinal_angles[math.random(1, #dg.cardinal_angles)]
        
        -- Base bullet speed is divided by speed_mod so they move slower across the screen
        local dynamic_speed = (dg.bullet_speed_base + (math.random() * 50)) / speed_mod

        table.insert(dg.bullets, {
            x = dg.center.x + math.cos(angle) * 850,
            y = dg.center.y + math.sin(angle) * 850,
            speed = dynamic_speed,
            angle = angle
        })
        
        -- Base spawn frequency scales up (longer delays between spawns) on lower game speeds
        dg.spawn_timer = dg.difficulty * speed_mod
    end

    -- Physics & Collision
    for i = #dg.bullets, 1, -1 do
        local b = dg.bullets[i]
        local dx = dg.center.x - b.x
        local dy = dg.center.y - b.y
        local dist = math.sqrt(dx*dx + dy*dy)
        
        b.x = b.x + (dx / dist) * b.speed * dt
        b.y = b.y + (dy / dist) * b.speed * dt

        -- Shield Hitbox
        if dist <= dg.shield_radius + 35 and dist >= dg.shield_radius - 35 then
            local b_angle = math.atan2(b.y - dg.center.y, b.x - dg.center.x)
            local diff = (b_angle - dg.shield_angle + math.pi) % (math.pi * 2) - math.pi
            if math.abs(diff) < dg.shield_width / 2 then
                table.remove(dg.bullets, i)
            end
        end

        -- Atlas Hitbox (Damage Taken)
        local atlas_hitbox_radius = 70 
        if dist < atlas_hitbox_radius then
            table.remove(dg.bullets, i)
            dg.hp = dg.hp - 1
            
            local sound_name = "fn_damage" .. math.random(1, 3)
            if config.sfx ~= false then
                play_sound(sound_name)
            end

            if dg.hp <= 0 then
                dg.active = false
				if not G.GAME.Practice then
					G.GAME.ForcedFail = true
				end
            end
        end
    end
end

-- =========================
-- Drawing Loop
-- =========================
local old_draw = love.draw
function love.draw()
    if old_draw then old_draw() end
    
    local dg = G.DEFENSE_GAME
    if not dg.active then return end

    dg.default_font = love.graphics.getFont()
    local realW, realH = love.graphics.getDimensions()
    love.graphics.push()
    love.graphics.scale(realW / dg.virtualW, realH / dg.virtualH)

    -- No longer dimming the screen (Alpha set to 0)
    love.graphics.setColor(0, 0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, dg.virtualW, dg.virtualH)
    love.graphics.setColor(1, 1, 1, 1)

    -- Instruction Screen
    if dg.state == "STARTING" then
        if dg.font then
            love.graphics.setFont(dg.font)
            love.graphics.printf("DEFEND THE ATLAS", 0, 200, dg.virtualW, "center")
            love.graphics.printf("Use WASD / Arrows to move the wall", 0, 300, dg.virtualW, "center")
            love.graphics.printf("Don't let husks touch the Atlas 3 times!", 0, 350, dg.virtualW, "center")
            
            love.graphics.setFont(dg.default_font)
        end
    else
        -- Draw Gameplay Elements
        -- Draw Atlas
        if dg.images.atlas then
            local img = dg.images.atlas
            local s = (dg.entitiesSize * dg.atlasScaleFactor) / img:getWidth()
            love.graphics.draw(img, dg.center.x, dg.center.y, 0, s, s, img:getWidth()/2, img:getHeight()/2)
        end

        -- Draw Shield
        if dg.images.shield then
            local img = dg.images.shield
            local s = (dg.entitiesSize * dg.shieldVisualScale) / img:getWidth() 
            love.graphics.draw(img, 
                dg.center.x + math.cos(dg.shield_angle) * dg.shield_radius, 
                dg.center.y + math.sin(dg.shield_angle) * dg.shield_radius, 
                dg.shield_angle + math.pi/2, 
                s, s, img:getWidth()/2, img:getHeight()/2)
        end

        -- Draw Husks
        if dg.images.husk then
            local img = dg.images.husk
            local s = (dg.entitiesSize * 0.5) / img:getWidth() 
            for _, b in ipairs(dg.bullets) do
                love.graphics.draw(img, b.x, b.y, b.angle + math.pi, s, s, img:getWidth()/2, img:getHeight()/2)
            end
        end

        -- HUD (Health text moved further right)
        if dg.font then 
            love.graphics.setFont(dg.font) 
            love.graphics.print("ATLAS HEALTH: " .. dg.hp, 950, 50)
            love.graphics.setFont(dg.default_font)
        end
    end

    love.graphics.pop()
end

local end_round_original = end_round
function end_round()
    -- Call the original end_round
    end_round_original()
	G.DEFENSE_GAME.active = false
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
    if G.GAME.blind and G.GAME.blind.name == 'Fight The Storm' and not G.GAME.blind.disabled and G.STATE ~= 8 then
        G.FUNCS.start_defense_game()
    end
end


-- =========================
-- Delulu Game Container
-- =========================

-- 1. Initialize Global Mod Table & Helpers
MicMod = MicMod or {}

function MicMod.stop_audio()
    MicMod.active = false
    G.GAME.MicLevel = nil
    if Fortlatro and Fortlatro.stop_microphone then
        Fortlatro.stop_microphone()
    end
end

-- 2. Start Run Hook
MicMod.start_run_ref = Game.start_run
function Game:start_run(args)
    MicMod.start_run_ref(self, args)

    if G.GAME.blind and G.GAME.blind.name == 'Delulu' and not G.GAME.blind.disabled and G.STATE ~= 8 then
        G.GAME.Practice = false
        G.GAME.MicLevel = 50
        G.GAME.InitialCooldown = 2.0
        G.GAME.YapCount = 0

        local device = Fortlatro.start_microphone()
        if device then
            MicMod.active = true
        else
            MicMod.stop_audio()
        end
    else
        MicMod.stop_audio()
    end
end

-- 3. The Core Update Hook
MicMod.upd_ref = Game.update
function Game:update(dt)
    MicMod.upd_ref(self, dt)
    
    if not G or not G.GAME then return end

    -- DELULU BOSS MECHANIC
    if MicMod.active and not (G.GAME.blind and G.GAME.blind.disabled) then
        -- Default to 50 if MicLevel isn't set yet
        G.GAME.MicLevel = G.GAME.MicLevel or 50
        MicMod.boss_max_rms = 0
        
        -- Read data from the single active microphone device
        local device = Fortlatro.active_mic_device
        if device and device:isRecording() then
            MicMod.data = device:getData()
            if MicMod.data and MicMod.data:getSampleCount() > 0 then
                MicMod.sumSq = 0
                MicMod.count = MicMod.data:getSampleCount()
                for i = 0, MicMod.count - 1, 4 do
                    MicMod.s = MicMod.data:getSample(i)
                    MicMod.sumSq = MicMod.sumSq + (MicMod.s * MicMod.s)
                end
                MicMod.rms = math.sqrt(MicMod.sumSq / (MicMod.count / 4))
                if MicMod.rms > MicMod.boss_max_rms then MicMod.boss_max_rms = MicMod.rms end
            end
        else
            -- If device disconnected mid-game, stop active audio state safely
            MicMod.stop_audio()
            return
        end

        if G.GAME.InitialCooldown and G.GAME.InitialCooldown > 0 then
            G.GAME.InitialCooldown = G.GAME.InitialCooldown - dt
        else
            G.GAME.MicLevel = G.GAME.MicLevel - (25 * dt)
            if MicMod.boss_max_rms > 0 then
                G.GAME.MicLevel = G.GAME.MicLevel + (MicMod.boss_max_rms * 3500 * dt)
            end

            if G.GAME.MicLevel <= 0 and G.STATE ~= G.STATES.GAME_OVER then
                MicMod.stop_audio()
                if not G.GAME.Practice then
                    G.GAME.ForcedFail = true
                end
            end
        end

        -- Safe manual clamping without calling Talisman's math.min/math.max directly
        if G.GAME.MicLevel then
            if G.GAME.MicLevel > 100 then G.GAME.MicLevel = 100 end
            if G.GAME.MicLevel < 0 then G.GAME.MicLevel = 0 end
            
            if G.GAME.MicLevel >= 20 then 
                G.GAME.YapCount = (G.GAME.YapCount or 0) + dt 
            end
        end
    end
end

-- 4. Draw Logic
MicMod.drw_ref = Game.draw
function Game:draw()
    MicMod.drw_ref(self)

    if MicMod.active and G and G.GAME and G.GAME.MicLevel then
        MicMod.sw = love.graphics.getWidth()
        MicMod.sh = love.graphics.getHeight()
        MicMod.w, MicMod.h = 25, 350
        MicMod.dx = MicMod.sw - 100 
        MicMod.dy = (MicMod.sh / 2) - (MicMod.h / 2)
        
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", MicMod.dx, MicMod.dy, MicMod.w, MicMod.h)
        
        -- Guard against division by nil
        MicMod.displayLevel = (G.GAME.MicLevel or 0) / 100
        MicMod.fillH = MicMod.h * MicMod.displayLevel
        love.graphics.setColor(1 - MicMod.displayLevel, MicMod.displayLevel, 0.3, 1)
        love.graphics.rectangle("fill", MicMod.dx, MicMod.dy + (MicMod.h - MicMod.fillH), MicMod.w, MicMod.fillH)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("CATASTROPHIC", MicMod.dx - 35, MicMod.dy - 25)
        love.graphics.print("LOW", MicMod.dx - 2, MicMod.dy + MicMod.h + 5)
        
        love.graphics.push()
        love.graphics.translate(MicMod.dx - 35, MicMod.dy + MicMod.h - 70)
        love.graphics.rotate(-math.pi / 2)
        love.graphics.print("YAPPING LEVEL TODAY", 0, 0)
        love.graphics.pop()

        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", MicMod.dx, MicMod.dy, MicMod.w, MicMod.h)
    end
end

-- =========================
-- Pipe Game Container
-- =========================
G.PIPE_GAME = {
    active = false,
    waiting_to_start = false, -- Instruction screen flag
    won = false,
    lost = false,
    is_finishing = false,  -- Flag for the rapid end-of-game flow sequence
    
    -- Grid Settings
    cols = 8,
    rows = 5,
    grid = {},
    
    -- Start and End definitions
    start_cell = {x = 1, y = 3}, 
    end_cell = {x = 8, y = 3},   
    
    -- Real-time liquid progression state
    water_path = {},       
    water_progress = 0,    
    flow_speed = 0.25,     -- Standard speed (4 seconds per tile block)
    start_delay = 6.0,     -- Wait 3 seconds before water begins moving (starts after clicking play)
    leak_location = nil,   
    
    -- Debug Solution Path Mapping
    solution_path_list = {}, 
    solution_path_map = {},  
    
    -- Virtual Canvas Dimensions
    virtualW = 1280,
    virtualH = 720,
    tileSize = 90,
    offsetX = 280, 
    offsetY = 150,
    
    -- Image cache
    bomb_img = nil,
    font = nil
}

local PIPE_TYPES = {
    I = {1, 3}, 
    L = {1, 2}
}

local function rotate_connections(connections, rotation)
    local new_conn = {}
    for _, dir in ipairs(connections) do
        local nd = (dir - 1 + rotation) % 4 + 1
        table.insert(new_conn, nd)
    end
    return new_conn
end

-- =========================
-- Real-time Path Tracker
-- =========================
local function update_water_flow_path()
    local p = G.PIPE_GAME
    p.water_path = {}
    
    local cx, cy = p.start_cell.x, p.start_cell.y
    local coming_from = 4 

    while true do
        local cell = p.grid[cx][cy]
        
        local has_entry = false
        for _, dir in ipairs(cell.connections) do
            if dir == coming_from then has_entry = true break end
        end
        
        if not has_entry then 
            p.leak_location = {x = cx, y = cy, dir = coming_from}
            return false 
        end

        local out_dir = nil
        for _, dir in ipairs(cell.connections) do
            if dir ~= coming_from then out_dir = dir break end
        end
        
        table.insert(p.water_path, {
            x = cx, 
            y = cy, 
            entry = coming_from, 
            exit = out_dir, 
            type = cell.type
        })

        if not out_dir then 
            p.leak_location = {x = cx, y = cy, dir = nil}
            return false 
        end

        local nx, ny = cx, cy
        local expected_entry = 0
        if out_dir == 1 then ny = cy - 1; expected_entry = 3 end 
        if out_dir == 2 then nx = cx + 1; expected_entry = 4 end 
        if out_dir == 3 then ny = cy + 1; expected_entry = 1 end 
        if out_dir == 4 then nx = cx - 1; expected_entry = 2 end 

        if cx == p.end_cell.x and cy == p.end_cell.y and out_dir == 2 then
            p.leak_location = nil
            return true 
        end

        if nx < 1 or nx > p.cols or ny < 1 or ny > p.rows then 
            p.leak_location = {x = cx, y = cy, dir = out_dir}
            return false 
        end

        cx, cy = nx, ny
        coming_from = expected_entry
    end
end

-- =========================
-- Initialization (Guaranteed Solvable)
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_pipe_game = function()
    local p = G.PIPE_GAME
    p.waiting_to_start = true -- Show instructions first
    p.active = false
    p.won = false
    p.lost = false
    p.is_finishing = false
    p.water_progress = 0
    p.flow_speed = 0.25 
    p.start_delay = 6.0 
    p.grid = {}
    p.solution_path_map = {}
    p.solution_path_list = {}

    if not p.font then
        p.font = love.graphics.newFont(32)
    end

    for x = 1, p.cols do
        p.grid[x] = {}
        for y = 1, p.rows do
            local r_type = math.random() > 0.5 and "I" or "L"
            local r_rot = math.random(0, 3)
            p.grid[x][y] = { 
                type = r_type, 
                rotation = r_rot, 
                connections = rotate_connections(PIPE_TYPES[r_type], r_rot) 
            }
        end
    end

    local current = {x = p.start_cell.x, y = p.start_cell.y}
    local visited = {}
    visited[current.x .. "_" .. current.y] = true
    local path = { {x = current.x, y = current.y} }

    while current.x ~= p.end_cell.x or current.y ~= p.end_cell.y do
        local neighbors = {}
        local moves = {{x=1, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=0}}
        for _, m in ipairs(moves) do
            local nx, ny = current.x + m.x, current.y + m.y
            if nx >= 1 and nx <= p.cols and ny >= 1 and ny <= p.rows and not visited[nx .. "_" .. ny] then
                table.insert(neighbors, {x = nx, y = ny})
            end
        end

        if #neighbors == 0 then
            return G.FUNCS.start_pipe_game()
        else
            local next_cell = neighbors[math.random(#neighbors)]
            visited[next_cell.x .. "_" .. next_cell.y] = true
            table.insert(path, next_cell)
            current = next_cell
        end
    end

    p.solution_path_list = path 

    for i = 1, #path do
        local curr = path[i]
        p.solution_path_map[curr.x .. "_" .. curr.y] = true 
        
        local prev = path[i-1] or {x = curr.x - 1, y = curr.y} 
        local nxt = path[i+1] or {x = curr.x + 1, y = curr.y}  
        
        local function get_dir(from, to)
            if to.x > from.x then return 2 end 
            if to.x < from.x then return 4 end 
            if to.y > from.y then return 3 end 
            if to.y < from.y then return 1 end 
        end

        local d1 = get_dir(curr, prev)
        local d2 = get_dir(curr, nxt)
        local correct_rot = 0
        local p_type = "I"

        if (d1 == 1 and d2 == 3) or (d1 == 3 and d2 == 1) or (d1 == 2 and d2 == 4) or (d1 == 4 and d2 == 2) then
            p_type = "I"
            correct_rot = (d1 == 2 or d2 == 2) and 1 or 0 
        else
            p_type = "L"
            if (d1 == 1 and d2 == 2) or (d1 == 2 and d2 == 1) then correct_rot = 0 end
            if (d1 == 2 and d2 == 3) or (d1 == 3 and d2 == 2) then correct_rot = 1 end
            if (d1 == 3 and d2 == 4) or (d1 == 4 and d2 == 3) then correct_rot = 2 end
            if (d1 == 4 and d2 == 1) or (d1 == 1 and d2 == 4) then correct_rot = 3 end
        end

        local scrambled_rot = (correct_rot + math.random(1, 3)) % 4

        p.grid[curr.x][curr.y].type = p_type
        p.grid[curr.x][curr.y].rotation = scrambled_rot
        p.grid[curr.x][curr.y].connections = rotate_connections(PIPE_TYPES[p_type], scrambled_rot)
    end
    
    update_water_flow_path()
end

-- =========================
-- Update Loop
-- =========================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)
    local p = G.PIPE_GAME
    if p.waiting_to_start or not p.active or p.won or p.lost then return end

    local is_paused = G.SETTINGS and G.SETTINGS.paused
    if not is_paused then
        -- Skip delay completely if we are already running the final fast animation sequence
        if p.start_delay > 0 and not p.is_finishing then
            p.start_delay = p.start_delay - dt
            update_water_flow_path()
            return
        end

        p.water_progress = p.water_progress + (p.flow_speed * dt)
        
        local path_is_fully_solved = update_water_flow_path()
        local max_attainable_index = #p.water_path

        if p.water_progress >= max_attainable_index then
            if path_is_fully_solved then
                -- SUCCESS STATE
                p.won = true
                p.active = false                     
            else
                -- FAILURE STATE
                p.lost = true
                p.active = false                     
                p.water_progress = max_attainable_index 
				if not G.GAME.Practice then
					G.GAME.ForcedFail = true 
				end
            end
        end
    end
end

-- =========================
-- Advanced Vector Rendering
-- =========================
local function get_direction_vector(dir, size)
    local h = size / 2
    if dir == 1 then return 0, -h end
    if dir == 2 then return h, 0 end
    if dir == 3 then return 0, h end
    if dir == 4 then return -h, 0 end
    return 0, 0
end

local function draw_flowing_pipe(entry_dir, exit_dir, size, percent)
    local x1, y1 = get_direction_vector(entry_dir, size)
    local x2, y2 = get_direction_vector(exit_dir, size)
    
    if percent >= 1 then
        love.graphics.line(x1, y1, 0, 0)
        love.graphics.line(0, 0, x2, y2)
    elseif percent > 0 then
        if percent <= 0.5 then
            local p1 = percent / 0.5
            love.graphics.line(x1, y1, x1 + (0 - x1) * p1, y1 + (0 - y1) * p1)
        else
            local p2 = (percent - 0.5) / 0.5
            love.graphics.line(x1, y1, 0, 0)
            love.graphics.line(0, 0, 0 + (x2 - 0) * p2, 0 + (y2 - 0) * p2)
        end
    end
end

-- =========================
-- Drawing Loop
-- =========================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()
    local p = G.PIPE_GAME
    if not p.active and not p.waiting_to_start then return end

    -- Lazy-load the bomb asset for the pipe game
    if not p.bomb_img then
        local path = SMODS.Mods["Fortlatro"].path .. "/customimages/bomb.png"
        local fileData = NFS.newFileData(path) 
        p.bomb_img = love.graphics.newImage(love.image.newImageData(fileData))
    end

    local realW, realH = love.graphics.getDimensions()
    local scaleX = realW / p.virtualW
    local scaleY = realH / p.virtualH
    local old_font = love.graphics.getFont()

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    
    -- INSTRUCTIONS SCREEN OVERLAY
    if p.waiting_to_start then
        love.graphics.setColor(0, 0, 0, 0.85)
        love.graphics.rectangle("fill", 0, 0, p.virtualW, p.virtualH)
        
        love.graphics.setColor(1, 1, 1, 1)
        if p.font then love.graphics.setFont(p.font) end
        
        local instruct = "DELIVER THE BOMB\n\n" ..
                         "Click on the track segments to rotate them.\n" ..
                         "Create a path from the Armory to the Launcher!\n\n" ..
                         "Bomb deploys soon after starting.\n\n" ..
                         "CLICK ANYWHERE TO BEGIN"
                         
        love.graphics.printf(instruct, 0, p.virtualH / 2 - 140, p.virtualW, "center")
        
        love.graphics.pop()
        love.graphics.setFont(old_font)
        return
    end

    -- Panel Board Background
    love.graphics.setColor(0.05, 0.06, 0.08, 0.96)
    love.graphics.rectangle("fill", p.offsetX - 40, p.offsetY - 40, (p.cols * p.tileSize) + 80, (p.rows * p.tileSize) + 110, 15, 15)

    -- IN (A) and OUT (B) pads styled like deployment junctions
    love.graphics.setColor(0.1, 0.65, 0.9, 1) -- Armory/Launcher Cyan
    love.graphics.rectangle("fill", p.offsetX - p.tileSize + 5, p.offsetY + (3 - 1) * p.tileSize + 5, p.tileSize - 10, p.tileSize - 10, 5, 5)
    
    -- Draw the launcher pad base (crimson)
    local launcher_x = p.offsetX + (p.cols * p.tileSize) + 5
    local launcher_y = p.offsetY + (3 - 1) * p.tileSize + 5
    local pad_size = p.tileSize - 10
    
    love.graphics.setColor(0.85, 0.3, 0.2, 1) -- Rift/Target Crimson Red
    love.graphics.rectangle("fill", launcher_x, launcher_y, pad_size, pad_size, 5, 5)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("ARMORY", p.offsetX - p.tileSize, p.offsetY + (3 - 1) * p.tileSize + p.tileSize/3, p.tileSize, "center")
    love.graphics.printf("LAUNCHER", p.offsetX + (p.cols * p.tileSize), p.offsetY + (3 - 1) * p.tileSize + p.tileSize/3, p.tileSize, "center")

    -- Clean backing tiles to provide high contrast separation 
    for x = 1, p.cols do
        for y = 1, p.rows do
            love.graphics.setColor(0.09, 0.11, 0.15, 1)
            love.graphics.rectangle("fill", p.offsetX + (x - 1) * p.tileSize + 2, p.offsetY + (y - 1) * p.tileSize + 2, p.tileSize - 4, p.tileSize - 4, 4, 4)
            
            -- Light gray thin grid lines to break up blocks cleanly
            love.graphics.setLineWidth(1)
            love.graphics.setColor(0.2, 0.25, 0.35, 0.4)
            love.graphics.rectangle("line", p.offsetX + (x - 1) * p.tileSize + 2, p.offsetY + (y - 1) * p.tileSize + 2, p.tileSize - 4, p.tileSize - 4, 4, 4)
        end
    end

    for x = 1, p.cols do
        for y = 1, p.rows do
            local cell = p.grid[x][y]
            local tx = p.offsetX + (x - 1) * p.tileSize + p.tileSize / 2
            local ty = p.offsetY + (y - 1) * p.tileSize + p.tileSize / 2

            -- DRAW THE DEFINED TRACK ASSET
            love.graphics.push()
            love.graphics.translate(tx, ty)
            love.graphics.rotate(cell.rotation * math.pi / 2)
            
            -- Size constants for cleaner geometry sizing
            local rw = 28  -- Width of steel plates
            local ext = p.tileSize / 2

            -- 1. Outer Dark Metallic Structural Plates (Deep Indigo Steel)
            love.graphics.setColor(0.14, 0.18, 0.28, 1) -- Clear `#232E47` Indigo Blue
            if cell.type == "I" then
                love.graphics.rectangle("fill", -rw, -ext, rw * 2, p.tileSize)
            else
                love.graphics.rectangle("fill", -rw, -ext, rw * 2, ext + rw)
                love.graphics.rectangle("fill", -rw, -rw, ext + rw, rw * 2)
            end

            -- 2. Fine High-Contrast Light Blue Accent Borders
            love.graphics.setLineWidth(2)
            love.graphics.setColor(0.4, 0.75, 1.0, 0.85) -- Light Blue Trim Line
            if cell.type == "I" then
                love.graphics.line(-rw, -ext, -rw, ext)
                love.graphics.line(rw, -ext, rw, ext)
            else
                love.graphics.line(-rw, -ext, -rw, rw)
                love.graphics.line(-rw, rw, ext, rw)
                love.graphics.line(rw, -ext, rw, -rw)
                love.graphics.line(rw, -rw, ext, -rw)
            end

            -- 3. Transparent Light-Blue Outer Shields/Wings
            love.graphics.setColor(0.15, 0.55, 0.8, 0.4) 
            if cell.type == "I" then
                love.graphics.rectangle("fill", -rw - 8, -ext, 8, p.tileSize)
                love.graphics.rectangle("fill", rw, -ext, 8, p.tileSize)
            else
                love.graphics.rectangle("fill", -rw - 8, -ext, 8, ext + rw + 8)
                love.graphics.rectangle("fill", -rw, rw, ext + rw, 8)
            end

            -- 4. Central Copper Power Rails
            love.graphics.setLineWidth(10)
            love.graphics.setColor(0.72, 0.45, 0.32, 1) -- Distinct copper finish core
            if cell.type == "I" then 
                love.graphics.line(0, -ext, 0, ext)
            else 
                love.graphics.line(0, -ext, 0, 0)
                love.graphics.line(0, 0, ext, 0) 
            end
            
            love.graphics.pop()
        end
    end

    -- Bright Luminous Bluglo Energy Current
    love.graphics.setLineWidth(14)
    for i, w_node in ipairs(p.water_path) do
        local tx = p.offsetX + (w_node.x - 1) * p.tileSize + p.tileSize / 2
        local ty = p.offsetY + (w_node.y - 1) * p.tileSize + p.tileSize / 2
        
        local fill_pct = math.min(1.0, math.max(0.0, p.water_progress - (i - 1)))

        love.graphics.push()
        love.graphics.translate(tx, ty)
        love.graphics.setColor(0.15, 0.88, 1.0, 0.95) -- Radiant Bluglo Cyan
        draw_flowing_pipe(w_node.entry, w_node.exit, p.tileSize, fill_pct)
        love.graphics.pop()
    end

    -- Real-time tracking of the fluid's "tip" coordinate to position the bomb
    local bomb_x, bomb_y
    local tip_idx = math.floor(p.water_progress) + 1
    local w_node = p.water_path[tip_idx]

    if w_node then
        -- Find absolute tile center coordinates
        local tx = p.offsetX + (w_node.x - 1) * p.tileSize + p.tileSize / 2
        local ty = p.offsetY + (w_node.y - 1) * p.tileSize + p.tileSize / 2
        
        -- Interpolate front tip offset inside the active pipe
        local fill_pct = math.min(1.0, math.max(0.0, p.water_progress - (tip_idx - 1)))
        local x1, y1 = get_direction_vector(w_node.entry, p.tileSize)
        local x2, y2 = 0, 0
        if w_node.exit then
            x2, y2 = get_direction_vector(w_node.exit, p.tileSize)
        end
        
        local rx, ry = 0, 0
        if fill_pct <= 0.5 then
            local p1 = fill_pct / 0.5
            rx = x1 + (0 - x1) * p1
            ry = y1 + (0 - y1) * p1
        else
            local p2 = (fill_pct - 0.5) / 0.5
            rx = 0 + (x2 - 0) * p2
            ry = 0 + (y2 - 0) * p2
        end
        
        bomb_x = tx + rx
        bomb_y = ty + ry
    else
        -- If we are at the very beginning (no progress) or at the absolute end (completed)
        if p.water_progress <= 0 then
            -- Position at the Armory start pad
            bomb_x = p.offsetX - p.tileSize / 2
            bomb_y = p.offsetY + (3 - 1) * p.tileSize + p.tileSize / 2
        else
            -- Check if we finished the path and successfully reached the end
            local finished_successfully = false
            if #p.water_path > 0 then
                local last_node = p.water_path[#p.water_path]
                if last_node.x == p.end_cell.x and last_node.y == p.end_cell.y and last_node.exit == 2 then
                    finished_successfully = true
                end
            end
            
            if finished_successfully then
                -- Position centered on the Launcher pad
                bomb_x = launcher_x + pad_size / 2
                bomb_y = launcher_y + pad_size / 2
            else
                -- Just drop the bomb at the last recorded water segment center
                local last_node = p.water_path[#p.water_path]
                if last_node then
                    bomb_x = p.offsetX + (last_node.x - 1) * p.tileSize + p.tileSize / 2
                    bomb_y = p.offsetY + (last_node.y - 1) * p.tileSize + p.tileSize / 2
                else
                    bomb_x = p.offsetX - p.tileSize / 2
                    bomb_y = p.offsetY + (3 - 1) * p.tileSize + p.tileSize / 2
                end
            end
        end
    end

    -- Draw the bomb actively moving along the energy current line
    if p.bomb_img and bomb_x and bomb_y then
        -- Scaled to look cleanly proportional to the path width
        local bomb_draw_size = 48
        local bomb_scale = bomb_draw_size / p.bomb_img:getWidth()
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(p.bomb_img, bomb_x - (p.bomb_img:getWidth() * bomb_scale) / 2, bomb_y - (p.bomb_img:getHeight() * bomb_scale) / 2, 0, bomb_scale, bomb_scale)
    end

    if p.start_delay > 0 and not p.is_finishing then
        love.graphics.setColor(1, 0.4, 0, 1)
        love.graphics.printf(string.format("BOMB DEPLOYING IN: %.1f", p.start_delay), p.offsetX, p.offsetY + (p.rows * p.tileSize) + 15, p.cols * p.tileSize, "center")
    end

    love.graphics.pop()
    love.graphics.setFont(old_font)
end

-- =========================
-- Mouse Interaction
-- =========================
local old_mouse = love.mousepressed or function() end
function love.mousepressed(rx, ry, button)
    local p = G.PIPE_GAME
    
    -- Handle Click-to-Start Instructions Screen
    if p.waiting_to_start then
        p.waiting_to_start = false
        p.active = true
        return
    end

    -- Block inputs if game is already resolved or running the fast-finish sequence
    if not p.active or p.won or p.lost or p.is_finishing or (G.SETTINGS and G.SETTINGS.paused) then 
        old_mouse(rx, ry, button)
        return 
    end

    local realW, realH = love.graphics.getDimensions()
    local mx = rx * (p.virtualW / realW)
    local my = ry * (p.virtualH / realH)

    if button == 1 then
        local gx = math.floor((mx - p.offsetX) / p.tileSize) + 1
        local gy = math.floor((my - p.offsetY) / p.tileSize) + 1

        if gx >= 1 and gx <= p.cols and gy >= 1 and gy <= p.rows then
            for i, w_node in ipairs(p.water_path) do
                if w_node.x == gx and w_node.y == gy then
                    local fill_pct = p.water_progress - (i - 1)
                    if fill_pct > 0 then
                        return 
                    end
                end
            end

            local cell = p.grid[gx][gy]
            cell.rotation = (cell.rotation + 1) % 4
            cell.connections = rotate_connections(PIPE_TYPES[cell.type], cell.rotation)

            -- Kick off rapid completion sequence instead of breaking out instantly
            local path_is_fully_solved = update_water_flow_path()
            if path_is_fully_solved then
                p.is_finishing = true
                p.flow_speed = 15.0  -- Speed up water aggressively (15 tiles per second)
                return
            end
        end
    end
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
    if G.GAME.blind and G.GAME.blind.name == 'Deliver The Bomb' and not G.GAME.blind.disabled and G.STATE ~= 8 then
        G.FUNCS.start_pipe_game()
    end
end

-- =========================
-- Tetris Minigame Container
-- =========================
G.TETRIS_GAME = {
    active = false,
    lost = false,

    -- Grid Settings (10 x 13)
    cols = 10,
    rows = 13,
    grid = {},

    -- Gameplay Mechanics
    current_piece = nil,
    next_piece = nil,
    hold_piece = nil,
    can_hold = true,
    piece_x = 0,
    piece_y = 0,
    drop_timer = 0,
    drop_speed = 0.6,
    lines_cleared = 0,
    
    -- T-Spin Tracking
    last_move_was_rotate = false,
    last_t_spin = false,

    -- DAS Settings
    key_repeat = {
        left = { down = false, timer = 0 },
        right = { down = false, timer = 0 },
        down = { down = false, timer = 0 }
    },
    das_delay = 0.18,
    das_rate = 0.04,

    -- Layout Settings (Elevated position to clear hand cards)
    virtualW = 1280,
    virtualH = 720,
    tileSize = 16,    
    offsetX = 580,    
    offsetY = 200,    -- Adjusted up

    font = nil
}

local TETROMINOES = {
    I = { shape = {{0,0,0,0},{1,1,1,1},{0,0,0,0},{0,0,0,0}}, color = {0.15, 0.88, 1.0, 1} },
    J = { shape = {{1,0,0},{1,1,1},{0,0,0}}, color = {0.2, 0.4, 0.9, 1} },
    L = { shape = {{0,0,1},{1,1,1},{0,0,0}}, color = {1.0, 0.6, 0.1, 1} },
    O = { shape = {{1,1},{1,1}}, color = {1.0, 0.85, 0.1, 1} },
    S = { shape = {{0,1,1},{1,1,0},{0,0,0}}, color = {0.2, 0.85, 0.3, 1} },
    T = { shape = {{0,1,0},{1,1,1},{0,0,0}}, color = {0.7, 0.2, 0.8, 1} },
    Z = { shape = {{1,1,0},{0,1,1},{0,0,0}}, color = {0.9, 0.2, 0.2, 1} }
}

-- SRS Wall Kick Offsets (x, y) where +y is DOWN
-- Index transitions: 0->1 (0), 1->2 (1), 2->3 (2), 3->0 (3)
local JLSTZ_KICKS = {
    [0] = { {0,0}, {-1,0}, {-1,-1}, {0, 2}, {-1, 2} }, -- 0 -> 1
    [1] = { {0,0}, { 1,0}, { 1, 1}, {0,-2}, { 1,-2} }, -- 1 -> 2
    [2] = { {0,0}, { 1,0}, { 1,-1}, {0, 2}, { 1, 2} }, -- 2 -> 3
    [3] = { {0,0}, {-1,0}, {-1, 1}, {0,-2}, {-1,-2} }  -- 3 -> 0
}

local I_KICKS = {
    [0] = { {0,0}, {-2,0}, { 1,0}, {-2, 1}, { 1,-2} }, -- 0 -> 1
    [1] = { {0,0}, {-1,0}, { 2,0}, {-1,-2}, { 2, 1} }, -- 1 -> 2
    [2] = { {0,0}, { 2,0}, {-1,0}, { 2,-1}, {-1, 2} }, -- 2 -> 3
    [3] = { {0,0}, { 1,0}, {-2,0}, { 1, 2}, {-2,-1} }  -- 3 -> 0
}

local PIECE_KEYS = {"I", "J", "L", "O", "S", "T", "Z"}

local function copy_shape(shape)
    local new_s = {}
    for r = 1, #shape do
        new_s[r] = {}
        for c = 1, #shape[r] do
            new_s[r][c] = shape[r][c]
        end
    end
    return new_s
end

local function rotate_matrix(m)
    local rotated = {}
    local n = #m
    for r = 1, n do
        rotated[r] = {}
        for c = 1, n do
            rotated[r][c] = m[n - c + 1][r]
        end
    end
    return rotated
end

local function check_collision(grid, shape, px, py)
    for r = 1, #shape do
        for c = 1, #shape[r] do
            if shape[r][c] ~= 0 then
                local gx = px + c - 1
                local gy = py + r - 1

                if gx < 1 or gx > G.TETRIS_GAME.cols or gy > G.TETRIS_GAME.rows then
                    return true
                end

                if gy >= 1 and grid[gx][gy] then
                    return true
                end
            end
        end
    end
    return false
end

local function check_t_spin()
    local t = G.TETRIS_GAME
    if not t.current_piece or t.current_piece.key ~= "T" or not t.last_move_was_rotate then
        return false
    end

    -- Check 4 diagonal corners around the center of the 3x3 T-piece
    local corners = {
        { x = t.piece_x,     y = t.piece_y },     -- Top-Left
        { x = t.piece_x + 2, y = t.piece_y },     -- Top-Right
        { x = t.piece_x,     y = t.piece_y + 2 }, -- Bottom-Left
        { x = t.piece_x + 2, y = t.piece_y + 2 }  -- Bottom-Right
    }

    local occupied_corners = 0
    for _, c in ipairs(corners) do
        if c.x < 1 or c.x > t.cols or c.y > t.rows or (c.y >= 1 and t.grid[c.x][c.y]) then
            occupied_corners = occupied_corners + 1
        end
    end

    return occupied_corners >= 3
end

local function get_random_piece()
    local key = PIECE_KEYS[math.random(#PIECE_KEYS)]
    local p_data = TETROMINOES[key]
    return { 
        key = key,
        shape = copy_shape(p_data.shape), 
        color = p_data.color,
        rotation = 0 -- 0: 0 deg, 1: 90 deg, 2: 180 deg, 3: 270 deg
    }
end

local function spawn_piece()
    local t = G.TETRIS_GAME
    if not t.next_piece then t.next_piece = get_random_piece() end

    t.current_piece = t.next_piece
    t.next_piece = get_random_piece()
    t.piece_x = math.floor((t.cols - #t.current_piece.shape) / 2) + 1
    t.piece_y = 1
    t.can_hold = true
    t.last_move_was_rotate = false
    t.last_t_spin = false

    -- FAILURE CONDITION: Top out = instant loss for the round
    if check_collision(t.grid, t.current_piece.shape, t.piece_x, t.piece_y) then
        t.lost = true
        t.active = false
        if not G.GAME.Practice then
            G.GAME.ForcedFail = true
        end
    end
end

local function rotate_piece()
    local t = G.TETRIS_GAME
    if not t.current_piece or t.current_piece.key == "O" then return end

    local rotated = rotate_matrix(t.current_piece.shape)
    local current_rot = t.current_piece.rotation
    local kick_set = (t.current_piece.key == "I") and I_KICKS or JLSTZ_KICKS
    local kicks = kick_set[current_rot]

    for _, kick in ipairs(kicks) do
        local test_x = t.piece_x + kick[1]
        local test_y = t.piece_y - kick[2] -- Invert Y: SRS kick tables treat +Y as UP, grid uses +Y as DOWN

        if not check_collision(t.grid, rotated, test_x, test_y) then
            t.current_piece.shape = rotated
            t.piece_x = test_x
            t.piece_y = test_y
            t.current_piece.rotation = (current_rot + 1) % 4
            t.last_move_was_rotate = true
            return
        end
    end
end

local function hold_current_piece()
    local t = G.TETRIS_GAME
    if not t.can_hold then return end

    local current_key = t.current_piece.key
    local original_data = TETROMINOES[current_key]
    
    local fresh_hold_piece = {
        key = current_key,
        shape = copy_shape(original_data.shape),
        color = original_data.color,
        rotation = 0
    }

    if not t.hold_piece then
        t.hold_piece = fresh_hold_piece
        spawn_piece()
    else
        local temp = t.hold_piece
        t.hold_piece = fresh_hold_piece
        t.current_piece = temp
        t.piece_x = math.floor((t.cols - #t.current_piece.shape) / 2) + 1
        t.piece_y = 1
        t.last_move_was_rotate = false
    end

    t.can_hold = false
end

local function lock_piece()
    local t = G.TETRIS_GAME
    local shape = t.current_piece.shape
    local color = t.current_piece.color

    t.last_t_spin = check_t_spin()

    for r = 1, #shape do
        for c = 1, #shape[r] do
            if shape[r][c] ~= 0 then
                local gx = t.piece_x + c - 1
                local gy = t.piece_y + r - 1
                if gy >= 1 then t.grid[gx][gy] = color end
            end
        end
    end

    local cleared = 0
    for y = t.rows, 1, -1 do
        local full = true
        for x = 1, t.cols do
            if not t.grid[x][y] then full = false break end
        end

        if full then
            cleared = cleared + 1
            for pull_y = y, 2, -1 do
                for x = 1, t.cols do t.grid[x][pull_y] = t.grid[x][pull_y - 1] end
            end
            for x = 1, t.cols do t.grid[x][1] = nil end
            y = y + 1
        end
    end

    if cleared > 0 then
        t.lines_cleared = t.lines_cleared + cleared
    end

    spawn_piece()
end

local function get_ghost_y()
    local t = G.TETRIS_GAME
    local gy = t.piece_y
    while not check_collision(t.grid, t.current_piece.shape, t.piece_x, gy + 1) do
        gy = gy + 1
    end
    return gy
end

-- =========================
-- Initialization
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_tetris_game = function()
    local t = G.TETRIS_GAME
    t.active = true
    t.lost = false
    t.lines_cleared = 0
    t.drop_timer = 0
    t.grid = {}
    t.next_piece = nil
    t.hold_piece = nil
    t.can_hold = true
    t.last_move_was_rotate = false
    t.last_t_spin = false
    t.key_repeat = {
        left = { down = false, timer = 0 },
        right = { down = false, timer = 0 },
        down = { down = false, timer = 0 }
    }

    if not t.font then t.font = love.graphics.newFont(14) end
    for x = 1, t.cols do t.grid[x] = {} end

    spawn_piece()
end

local function do_move(dir)
    local t = G.TETRIS_GAME
    if dir == "left" then
        if not check_collision(t.grid, t.current_piece.shape, t.piece_x - 1, t.piece_y) then
            t.piece_x = t.piece_x - 1
            t.last_move_was_rotate = false
        end
    elseif dir == "right" then
        if not check_collision(t.grid, t.current_piece.shape, t.piece_x + 1, t.piece_y) then
            t.piece_x = t.piece_x + 1
            t.last_move_was_rotate = false
        end
    elseif dir == "down" then
        if not check_collision(t.grid, t.current_piece.shape, t.piece_x, t.piece_y + 1) then
            t.piece_y = t.piece_y + 1
            t.last_move_was_rotate = false
        end
    end
end

-- =========================
-- Update Loop
-- =========================
local old_update = love.update or function() end
function love.update(dt)
    old_update(dt)
    local t = G.TETRIS_GAME
    if not t.active or t.lost then return end

    for dir, state in pairs(t.key_repeat) do
        if state.down then
            state.timer = state.timer + dt
            if state.timer >= t.das_delay then
                state.timer = state.timer - t.das_rate
                do_move(dir)
            end
        end
    end

    t.drop_timer = t.drop_timer + dt
    if t.drop_timer >= t.drop_speed then
        t.drop_timer = 0
        if not check_collision(t.grid, t.current_piece.shape, t.piece_x, t.piece_y + 1) then
            t.piece_y = t.piece_y + 1
            t.last_move_was_rotate = false
        else
            lock_piece()
        end
    end
end

-- =========================
-- Drawing Loop
-- =========================
local old_draw = love.draw or function() end
function love.draw()
    old_draw()
    local t = G.TETRIS_GAME
    if not t.active then return end

    local realW, realH = love.graphics.getDimensions()
    local scaleX = realW / t.virtualW
    local scaleY = realH / t.virtualH
    local old_font = love.graphics.getFont()

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)

    -- Panel Box
    love.graphics.setColor(0.05, 0.06, 0.08, 0.85)
    love.graphics.rectangle("fill", t.offsetX - 10, t.offsetY - 10, (t.cols * t.tileSize) + 100, (t.rows * t.tileSize) + 20, 8, 8)

    -- Playfield Grid Background
    for x = 1, t.cols do
        for y = 1, t.rows do
            love.graphics.setColor(0.09, 0.11, 0.15, 0.9)
            love.graphics.rectangle("fill", t.offsetX + (x - 1) * t.tileSize + 1, t.offsetY + (y - 1) * t.tileSize + 1, t.tileSize - 2, t.tileSize - 2, 2, 2)
        end
    end

    -- Locked Pieces
    for x = 1, t.cols do
        for y = 1, t.rows do
            if t.grid[x][y] then
                local c = t.grid[x][y]
                love.graphics.setColor(c[1], c[2], c[3], c[4])
                love.graphics.rectangle("fill", t.offsetX + (x - 1) * t.tileSize + 1, t.offsetY + (y - 1) * t.tileSize + 1, t.tileSize - 2, t.tileSize - 2, 2, 2)
            end
        end
    end

    -- Ghost & Active Piece
    if t.current_piece then
        local ghost_y = get_ghost_y()
        local shape = t.current_piece.shape
        local c = t.current_piece.color

        love.graphics.setColor(c[1], c[2], c[3], 0.25)
        for r = 1, #shape do
            for c_idx = 1, #shape[r] do
                if shape[r][c_idx] ~= 0 then
                    local gx = t.piece_x + c_idx - 1
                    local gy = ghost_y + r - 1
                    if gy >= 1 then
                        love.graphics.rectangle("fill", t.offsetX + (gx - 1) * t.tileSize + 1, t.offsetY + (gy - 1) * t.tileSize + 1, t.tileSize - 2, t.tileSize - 2, 2, 2)
                    end
                end
            end
        end

        love.graphics.setColor(c)
        for r = 1, #shape do
            for c_idx = 1, #shape[r] do
                if shape[r][c_idx] ~= 0 then
                    local gx = t.piece_x + c_idx - 1
                    local gy = t.piece_y + r - 1
                    if gy >= 1 then
                        love.graphics.rectangle("fill", t.offsetX + (gx - 1) * t.tileSize + 1, t.offsetY + (gy - 1) * t.tileSize + 1, t.tileSize - 2, t.tileSize - 2, 2, 2)
                    end
                end
            end
        end
    end

    -- Side Stats Header
    local side_x = t.offsetX + (t.cols * t.tileSize) + 10
    love.graphics.setColor(1, 1, 1, 1)
    if t.font then love.graphics.setFont(t.font) end
    love.graphics.print("LINES: " .. t.lines_cleared, side_x, t.offsetY)

    if t.last_t_spin then
        love.graphics.setColor(1, 0.3, 0.9, 1)
        love.graphics.print("T-SPIN!", side_x, t.offsetY + 15)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("NEXT:", side_x, t.offsetY + 35)

    -- Next Piece Container
    if t.next_piece then
        love.graphics.setColor(t.next_piece.color)
        local n_shape = t.next_piece.shape
        local preview_tile = 12
        for r = 1, #n_shape do
            for c = 1, #n_shape[r] do
                if n_shape[r][c] ~= 0 then
                    love.graphics.rectangle("fill", side_x + (c - 1) * preview_tile, t.offsetY + 55 + (r - 1) * preview_tile, preview_tile - 2, preview_tile - 2, 2, 2)
                end
            end
        end
    end

    -- Hold Piece Container
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("HOLD:", side_x, t.offsetY + 115)
    if t.hold_piece then
        if t.can_hold then
            love.graphics.setColor(t.hold_piece.color)
        else
            love.graphics.setColor(t.hold_piece.color[1] * 0.5, t.hold_piece.color[2] * 0.5, t.hold_piece.color[3] * 0.5, 0.8)
        end
        local h_shape = t.hold_piece.shape
        local preview_tile = 12
        for r = 1, #h_shape do
            for c = 1, #h_shape[r] do
                if h_shape[r][c] ~= 0 then
                    love.graphics.rectangle("fill", side_x + (c - 1) * preview_tile, t.offsetY + 135 + (r - 1) * preview_tile, preview_tile - 2, preview_tile - 2, 2, 2)
                end
            end
        end
    end

    love.graphics.pop()
    love.graphics.setFont(old_font)
end

-- =========================
-- Non-Blocking Input Handlers
-- =========================
local old_keypressed = love.keypressed or function() end
function love.keypressed(key)
    local t = G.TETRIS_GAME
    if t.active and not t.lost then
        if key == "left" or key == "a" then
            t.key_repeat.left.down = true
            t.key_repeat.left.timer = 0
            do_move("left")
        elseif key == "right" or key == "d" then
            t.key_repeat.right.down = true
            t.key_repeat.right.timer = 0
            do_move("right")
        elseif key == "down" or key == "s" then
            t.key_repeat.down.down = true
            t.key_repeat.down.timer = 0
            do_move("down")
        elseif key == "up" or key == "w" then
            rotate_piece()
        elseif key == "c" or key == "lshift" or key == "rshift" then
            hold_current_piece()
        elseif key == "space" then
            t.piece_y = get_ghost_y()
            lock_piece()
        end
    end

    old_keypressed(key)
end

local old_keyreleased = love.keyreleased or function() end
function love.keyreleased(key)
    local t = G.TETRIS_GAME
    if key == "left" or key == "a" then t.key_repeat.left.down = false
    elseif key == "right" or key == "d" then t.key_repeat.right.down = false
    elseif key == "down" or key == "s" then t.key_repeat.down.down = false end

    old_keyreleased(key)
end

local end_round_original = end_round
function end_round()
    -- Call the original end_round
    end_round_original()
	if G.TETRIS_GAME.active then
		G.TETRIS_GAME.active = false
		play_sound("fn_tetris")
	end
end

-- =========================
-- Game Hook Integration
-- =========================
local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
	if G.GAME.blind and G.GAME.blind.name == 'Tetris Rift' and not G.GAME.blind.disabled and G.STATE ~= 8 then
		G.FUNCS.start_tetris_game()
	end
end

SMODS.Sound({
    key = 'tv_time',
    path = 'tv_time.ogg',
})

if ((SMODS.Mods["Deltalatro"] or {}).can_load) then

-- =========================
-- Lightners Live Game Container
-- =========================
G.LIGHTNERS_LIVE_GAME = {
    active = false,
    finished = false,
    closed = false,

    final_rank = "Z",

    score = 0,
    combo = 0,
    max_combo = 0,

    hits = 0,
    misses = 0,
    stray_misses = 0,

    perfects = 0,
    greats = 0,
    goods = 0,

    total_notes = 0,
    spawned = {},

    song_length = 150,
    countdown_duration = 3,
    lead_in = 1.5,
    start_time = 0,
    music_started = false,

    last_judgement = "",
    judgement_time = 0,

    hit_flash = 0,
    hit_flash_lane = 0,

    rank = "Z",
    accuracy = 0,
    performance = 0,

    btn_rect = nil,

    chart = nil,

    images = {}
}

local LIGHTNERS_LIVE_CHART = {
    {time = 0.000, lane = 1},
    {time = 1.821, lane = 2},
    {time = 2.452, lane = 1},
    {time = 2.941, lane = 2},
    {time = 3.492, lane = 1},
    {time = 4.082, lane = 2},
    {time = 4.550, lane = 2},
    {time = 5.221, lane = 1},
    {time = 5.750, lane = 1},
    {time = 6.259, lane = 2},
    {time = 6.869, lane = 1},
    {time = 7.317, lane = 2},
    {time = 7.968, lane = 1},
    {time = 8.499, lane = 2},
    {time = 8.968, lane = 2},
    {time = 9.497, lane = 1},
    {time = 10.118, lane = 2},
    {time = 10.586, lane = 1},
    {time = 11.257, lane = 1},
    {time = 11.787, lane = 2},
    {time = 12.296, lane = 1},
    {time = 12.907, lane = 2},
    {time = 13.355, lane = 1},
    {time = 14.006, lane = 2},
    {time = 14.537, lane = 2},
    {time = 15.006, lane = 1},
    {time = 15.535, lane = 2},
    {time = 16.156, lane = 1},
    {time = 16.624, lane = 2},
    {time = 17.295, lane = 1},
    {time = 17.825, lane = 2},
    {time = 18.334, lane = 1},
    {time = 18.945, lane = 2},
    {time = 19.393, lane = 1},
    {time = 20.044, lane = 2},
    {time = 20.575, lane = 2},
    {time = 21.044, lane = 1},
    {time = 21.573, lane = 2},
    {time = 22.194, lane = 1},
    {time = 22.662, lane = 1},
    {time = 23.333, lane = 2},
    {time = 23.863, lane = 1},
    {time = 24.372, lane = 2},
    {time = 24.983, lane = 1},
    {time = 25.431, lane = 2},
    {time = 26.082, lane = 1},
    {time = 26.613, lane = 1},
    {time = 27.082, lane = 2},
    {time = 27.611, lane = 1},
    {time = 28.232, lane = 2},
    {time = 28.700, lane = 1},
    {time = 29.371, lane = 2},
    {time = 29.901, lane = 1},
    {time = 30.410, lane = 2},
    {time = 31.021, lane = 1},
    {time = 31.469, lane = 2},
    {time = 32.120, lane = 2},
    {time = 32.651, lane = 1},
    {time = 33.120, lane = 2},
    {time = 33.649, lane = 1},
    {time = 34.270, lane = 2},
    {time = 34.738, lane = 1},
    {time = 35.409, lane = 2},
    {time = 35.939, lane = 1},
    {time = 36.448, lane = 2},
    {time = 37.059, lane = 1},
    {time = 37.507, lane = 1},
    {time = 38.158, lane = 2},
    {time = 38.689, lane = 1},
    {time = 39.158, lane = 2},
    {time = 39.687, lane = 1},
    {time = 40.308, lane = 2},
    {time = 40.776, lane = 1},
    {time = 41.447, lane = 1},
    {time = 41.977, lane = 2},
    {time = 42.486, lane = 1},
    {time = 43.097, lane = 2},
    {time = 43.545, lane = 1},
    {time = 44.196, lane = 2},
    {time = 44.727, lane = 2},
    {time = 45.196, lane = 1},
    {time = 45.725, lane = 2},
    {time = 46.346, lane = 1},
    {time = 46.814, lane = 1},
    {time = 47.485, lane = 2},
    {time = 48.015, lane = 1},
    {time = 48.524, lane = 2},
    {time = 49.135, lane = 1},
    {time = 49.583, lane = 2},
    {time = 50.234, lane = 1},
    {time = 50.765, lane = 1},
    {time = 51.234, lane = 2},
    {time = 51.763, lane = 1},
    {time = 52.384, lane = 2},
    {time = 52.852, lane = 1},
    {time = 53.523, lane = 2},
    {time = 54.053, lane = 1},
    {time = 54.562, lane = 2},
    {time = 55.173, lane = 1},
    {time = 55.621, lane = 2},
    {time = 56.272, lane = 2},
    {time = 56.803, lane = 1},
    {time = 57.272, lane = 2},
    {time = 57.801, lane = 1},
    {time = 58.422, lane = 2},
    {time = 58.890, lane = 1},
    {time = 59.561, lane = 2},
    {time = 60.091, lane = 1},
    {time = 60.600, lane = 2},
    {time = 61.211, lane = 1},
    {time = 61.659, lane = 1},
    {time = 62.310, lane = 2},
    {time = 62.841, lane = 1},
    {time = 63.310, lane = 2},
    {time = 63.839, lane = 1},
    {time = 64.460, lane = 2},
    {time = 64.928, lane = 1},
    {time = 65.599, lane = 1},
    {time = 66.129, lane = 2},
    {time = 66.638, lane = 1},
    {time = 67.249, lane = 2},
    {time = 67.697, lane = 1},
    {time = 68.348, lane = 2},
    {time = 68.879, lane = 2},
    {time = 69.348, lane = 1},
    {time = 69.877, lane = 2},
    {time = 70.498, lane = 1},
    {time = 70.966, lane = 1},
    {time = 71.637, lane = 2},
    {time = 72.167, lane = 1},
    {time = 72.676, lane = 2},
    {time = 73.287, lane = 1},
    {time = 73.735, lane = 2},
    {time = 74.386, lane = 1},
    {time = 74.917, lane = 1},
    {time = 75.386, lane = 2},
    {time = 75.915, lane = 1},
    {time = 76.536, lane = 2},
    {time = 77.004, lane = 1},
    {time = 77.675, lane = 2},
    {time = 78.205, lane = 1},
    {time = 78.714, lane = 2},
    {time = 79.325, lane = 1},
    {time = 79.773, lane = 2},
    {time = 80.424, lane = 2},
    {time = 80.955, lane = 1},
    {time = 81.424, lane = 2},
    {time = 81.953, lane = 1},
    {time = 82.574, lane = 2},
    {time = 83.042, lane = 1},
    {time = 83.713, lane = 2},
    {time = 84.243, lane = 1},
    {time = 84.752, lane = 2},
    {time = 85.363, lane = 1},
    {time = 85.811, lane = 1},
    {time = 86.462, lane = 2},
    {time = 86.993, lane = 1},
    {time = 87.462, lane = 2},
    {time = 87.991, lane = 1},
    {time = 88.612, lane = 2},
    {time = 89.080, lane = 1},
    {time = 89.751, lane = 1},
    {time = 90.281, lane = 2},
    {time = 90.790, lane = 1},
    {time = 91.401, lane = 2},
    {time = 91.849, lane = 1},
    {time = 92.500, lane = 2},
    {time = 93.031, lane = 2},
    {time = 93.500, lane = 1},
    {time = 94.029, lane = 2},
    {time = 94.650, lane = 1},
    {time = 95.118, lane = 1},
    {time = 95.789, lane = 2},
    {time = 96.319, lane = 1},
    {time = 96.828, lane = 2},
    {time = 97.439, lane = 1},
    {time = 97.887, lane = 2},
    {time = 98.538, lane = 1},
    {time = 99.069, lane = 1},
    {time = 99.538, lane = 2},
    {time = 100.067, lane = 1},
    {time = 100.688, lane = 2},
    {time = 101.156, lane = 1},
    {time = 101.827, lane = 2},
    {time = 102.357, lane = 1},
    {time = 102.866, lane = 2},
    {time = 103.477, lane = 1},
    {time = 103.925, lane = 2},
    {time = 104.576, lane = 2},
    {time = 105.107, lane = 1},
    {time = 105.576, lane = 2},
    {time = 106.105, lane = 1},
    {time = 106.726, lane = 2},
    {time = 107.194, lane = 1},
    {time = 107.865, lane = 2},
    {time = 108.395, lane = 1},
    {time = 108.904, lane = 2},
    {time = 109.515, lane = 1},
    {time = 109.963, lane = 1},
    {time = 110.614, lane = 2},
    {time = 111.145, lane = 1},
    {time = 111.614, lane = 2},
    {time = 112.143, lane = 1},
    {time = 112.764, lane = 2},
    {time = 113.232, lane = 1},
    {time = 113.903, lane = 1},
    {time = 114.433, lane = 2},
    {time = 114.942, lane = 1},
    {time = 115.553, lane = 2},
    {time = 116.001, lane = 1},
    {time = 116.652, lane = 2},
    {time = 117.183, lane = 2},
    {time = 117.652, lane = 1},
    {time = 118.181, lane = 2},
    {time = 118.802, lane = 1},
    {time = 119.270, lane = 1},
    {time = 119.941, lane = 2},
    {time = 120.471, lane = 1},
    {time = 120.980, lane = 2},
    {time = 121.591, lane = 1},
    {time = 122.039, lane = 2},
    {time = 122.690, lane = 1},
    {time = 123.221, lane = 1},
    {time = 123.690, lane = 2},
    {time = 124.219, lane = 1},
    {time = 124.840, lane = 2},
    {time = 125.308, lane = 1},
    {time = 125.979, lane = 2},
    {time = 126.509, lane = 1},
    {time = 127.018, lane = 2},
    {time = 127.629, lane = 1},
    {time = 128.077, lane = 2},
    {time = 128.728, lane = 2},
    {time = 129.259, lane = 1},
    {time = 129.728, lane = 2},
    {time = 130.257, lane = 1},
    {time = 130.878, lane = 2},
    {time = 131.346, lane = 1},
    {time = 132.017, lane = 2},
    {time = 132.547, lane = 1},
    {time = 133.056, lane = 2},
    {time = 133.667, lane = 1},
    {time = 134.115, lane = 1},
    {time = 134.766, lane = 2},
    {time = 135.297, lane = 1},
    {time = 135.766, lane = 2},
    {time = 136.295, lane = 1},
    {time = 136.916, lane = 2},
    {time = 137.384, lane = 1},
    {time = 138.055, lane = 1},
    {time = 138.585, lane = 2},
    {time = 139.094, lane = 1},
    {time = 139.705, lane = 2},
    {time = 140.153, lane = 1},
    {time = 140.804, lane = 2},
    {time = 141.335, lane = 2},
    {time = 141.804, lane = 1},
    {time = 142.333, lane = 2},
    {time = 142.954, lane = 1},
    {time = 143.422, lane = 1},
    {time = 144.093, lane = 2},
    {time = 144.623, lane = 1},
    {time = 145.132, lane = 2},
    {time = 145.743, lane = 1},
    {time = 146.191, lane = 2},
    {time = 146.842, lane = 1},
    {time = 147.373, lane = 1},
    {time = 147.842, lane = 2},
    {time = 148.371, lane = 1},
    {time = 148.992, lane = 2},
    {time = 149.200, lane = 1}
}

-- =========================
-- Image Loading
-- =========================
local function lightners_live_load_img(name)
    local f = NFS.newFileData(SMODS.Mods["Fortlatro"].path .. "/customimages/" .. name)
    return love.graphics.newImage(love.image.newImageData(f))
end

local function lightners_live_ensure_images()
    local g = G.LIGHTNERS_LIVE_GAME

    if not g.images.bg then
        g.images.bg = lightners_live_load_img("live.png")
    end
end

-- =========================
-- Activation & Reset Function
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_lightners_live_game = function()
    local g = G.LIGHTNERS_LIVE_GAME

    lightners_live_ensure_images()

    g.active = true
    g.finished = false
    g.closed = false
    g.final_rank = "Z"

    g.score = 0
    g.combo = 0
    g.max_combo = 0

    g.hits = 0
    g.misses = 0
    g.stray_misses = 0

    g.perfects = 0
    g.greats = 0
    g.goods = 0

    g.spawned = {}
    g.chart = LIGHTNERS_LIVE_CHART
    g.total_notes = #LIGHTNERS_LIVE_CHART

    g.last_judgement = ""
    g.judgement_time = 0

    g.hit_flash = 0
    g.hit_flash_lane = 0

    g.rank = "Z"
    g.accuracy = 0
    g.performance = 0

    g.btn_rect = nil

    g.countdown_duration = 3
    g.lead_in = 1.5
    g.music_started = false
    g.start_time = love.timer.getTime() + g.countdown_duration + g.lead_in
end

-- =========================
-- Local Helpers
-- =========================
local function lightners_live_dismiss_results()
    local g = G.LIGHTNERS_LIVE_GAME

    if not g.active or g.closed then
        return
    end

    g.closed = true
    g.active = false

    local rank = g.final_rank

    if rank == "Z" then
        G.GAME.ForcedFail = true
	
	elseif rank == "T" then
		G.GAME.blind.dollars = 100
    elseif rank == "S" then
        G.GAME.blind.dollars = 50

    elseif rank == "C" then
        G.GAME.blind.dollars = -G.GAME.dollars / 2
    end

    if G.GAME.blind and rank ~= "Z" then
        local blind_chips = G.GAME.blind.chips
        G.GAME.chips = math.max(G.GAME.chips, blind_chips)

        -- End the round successfully
        G.STATE = G.STATES.HAND_PLAYED
        G.STATE_COMPLETE = true
        end_round()
    end
end

local function lightners_live_finish(rank)
    local g = G.LIGHTNERS_LIVE_GAME

    g.final_rank = rank
    g.rank = rank
    g.finished = true
end

local function lightners_live_hit(lane)
    local g = G.LIGHTNERS_LIVE_GAME

    if not g.active or g.finished then
        return
    end

    local elapsed =
        love.timer.getTime() - g.start_time

    local best_note = nil
    local best_difference = nil

    for _, note in pairs(g.spawned) do
        if not note.hit
            and not note.missed
            and note.lane == lane then

            local difference =
                math.abs(elapsed - note.time)

            if difference <= 0.25
                and (
                    not best_difference
                    or difference < best_difference
                ) then

                best_note = note
                best_difference = difference
            end
        end
    end

    if not best_note then
        -- Pressing with no note in range counts as a miss
        -- (ignored during the countdown, before any notes exist)
        if elapsed >= -g.lead_in then
            g.misses = g.misses + 1
            g.stray_misses = g.stray_misses + 1
            g.combo = 0

            g.last_judgement = "MISS"
            g.judgement_time = love.timer.getTime()
        end

        return
    end

    best_note.hit = true

    g.hits = g.hits + 1
    g.combo = g.combo + 1

    if g.combo > g.max_combo then
        g.max_combo = g.combo
    end

    g.hit_flash = 1
    g.hit_flash_lane = lane
    g.judgement_time = love.timer.getTime()

    if best_difference <= 0.05 then
        g.score = g.score + 1000
        g.perfects = g.perfects + 1
        g.last_judgement = "PERFECT"

    elseif best_difference <= 0.12 then
        g.score = g.score + 750
        g.greats = g.greats + 1
        g.last_judgement = "GREAT"

    else
        g.score = g.score + 500
        g.goods = g.goods + 1
        g.last_judgement = "GOOD"
    end
end

local love_keypressed = love.keypressed

function love.keypressed(key, scancode, isrepeat)
    local g = G.LIGHTNERS_LIVE_GAME

    if g.active and not g.closed then
        if g.finished then
            if key == 'return'
                or key == 'space'
                or key == 'z'
                or key == 'x' then

                lightners_live_dismiss_results()
                return
            end
        else
            if key == 'z'
                or key == 'a'
                or key == 'left' then

                lightners_live_hit(1)

            elseif key == 'x'
                or key == 'd'
                or key == 'right' then

                lightners_live_hit(2)
            end
        end
    end

    if love_keypressed then
        love_keypressed(key, scancode, isrepeat)
    end
end

local love_mousepressed = love.mousepressed

function love.mousepressed(x, y, button, touch, presses)
    local g = G.LIGHTNERS_LIVE_GAME

    if button == 1
        and g.active
        and g.finished
        and not g.closed
        and g.btn_rect then

        local r = g.btn_rect

        if x >= r.x
            and x <= r.x + r.w
            and y >= r.y
            and y <= r.y + r.h then

            lightners_live_dismiss_results()
            return
        end
    end

    if love_mousepressed then
        love_mousepressed(
            x,
            y,
            button,
            touch,
            presses
        )
    end
end

local love_update = love.update

function love.update(dt)
    if love_update then
        love_update(dt)
    end

    local g = G.LIGHTNERS_LIVE_GAME

    if not g.active or g.finished or g.closed then
        return
    end

    local elapsed =
        love.timer.getTime() - g.start_time

    for i, note in ipairs(g.chart) do
        if not g.spawned[i]
            and elapsed >= -g.lead_in
            and elapsed >= note.time - 1.5 then

            g.spawned[i] = {
                lane = note.lane,
                time = note.time,
                hit = false,
                missed = false
            }
        end
    end

    for _, note in pairs(g.spawned) do
        if not note.hit and not note.missed then
            if elapsed - note.time > 0.25 then
                note.missed = true
                g.misses = g.misses + 1
                g.combo = 0

                g.last_judgement = "MISS"
                g.judgement_time = love.timer.getTime()
            end
        end
    end

    if g.judgement_time > 0 then
        if love.timer.getTime() - g.judgement_time > 0.8 then
            g.last_judgement = ""
        end
    end

    if g.hit_flash > 0 then
        g.hit_flash = g.hit_flash - dt

        if g.hit_flash < 0 then
            g.hit_flash = 0
        end
    end

    if elapsed >= g.song_length then
        -- Stray presses (no note in range) count against accuracy
        local attempts = g.total_notes + g.stray_misses

        g.accuracy =
            (attempts > 0)
            and (g.hits / attempts)
            or 0

        g.performance =
            (g.total_notes > 0)
            and (g.score / (g.total_notes * 1000))
            or 0

        local displayed_accuracy =
            math.floor(g.accuracy * 100 + 0.5)

        local rank = "Z"

        if displayed_accuracy >= 100 then
            rank = "T"
        elseif displayed_accuracy >= 99 then
            rank = "S"
        elseif displayed_accuracy >= 90 then
            rank = "A"
        elseif displayed_accuracy >= 85 then
            rank = "B"
        elseif displayed_accuracy >= 80 then
            rank = "C"
        end

        lightners_live_finish(rank)
    end
end

local love_draw = love.draw

function love.draw()
    if love_draw then
        love_draw()
    end

    local g = G.LIGHTNERS_LIVE_GAME

    if not g.active then
        return
    end

    local screen_w = love.graphics.getWidth()
    local screen_h = love.graphics.getHeight()

    love.graphics.push("all")

    if not g.finished then
        local elapsed =
            love.timer.getTime() - g.start_time

        local lane_width = 100
        local gap = 20

        local total_width =
            lane_width * 2 + gap

        local start_x =
            (screen_w - total_width) / 2

        local top_y = screen_h * 0.15
        local hit_y = screen_h * 0.78

        local travel_time = 1.5
        local valid_height = 58
        local perfect_height = 22

        love.graphics.setLineWidth(4)

        if g.images.bg then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(
                g.images.bg,
                0, 0, 0,
                screen_w / g.images.bg:getWidth(),
                screen_h / g.images.bg:getHeight()
            )
        else
            love.graphics.setColor(0, 0, 0, 1)

            love.graphics.rectangle(
                "fill",
                0,
                0,
                screen_w,
                screen_h
            )
        end

        love.graphics.setColor(
            0.02,
            0.02,
            0.02,
            1
        )

        love.graphics.rectangle(
            "fill",
            start_x - 20,
            top_y - 20,
            total_width + 40,
            screen_h * 0.78 - top_y + 40
        )

        love.graphics.setColor(
            0.1,
            1,
            0.2,
            1
        )

        for lane = 1, 2 do
            local x =
                (lane == 1)
                and start_x
                or (start_x + lane_width + gap)

            love.graphics.rectangle(
                "fill",
                x,
                hit_y - valid_height / 2,
                lane_width,
                valid_height
            )
        end

        for lane = 1, 2 do
            local x =
                (lane == 1)
                and start_x
                or (start_x + lane_width + gap)

            if lane == 1 then
                love.graphics.setColor(
                    1,
                    0.85,
                    0,
                    1
                )
            else
                love.graphics.setColor(
                    0.1,
                    0.5,
                    1,
                    1
                )
            end

            love.graphics.rectangle(
                "fill",
                x,
                hit_y - perfect_height / 2,
                lane_width,
                perfect_height
            )
        end

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.rectangle(
            "line",
            start_x,
            hit_y - valid_height / 2,
            lane_width,
            valid_height
        )

        love.graphics.rectangle(
            "line",
            start_x + lane_width + gap,
            hit_y - valid_height / 2,
            lane_width,
            valid_height
        )

        for lane = 1, 2 do
            local x =
                (lane == 1)
                and start_x
                or (start_x + lane_width + gap)

            if lane == 1 then
                love.graphics.setColor(
                    1,
                    0.85,
                    0,
                    1
                )
            else
                love.graphics.setColor(
                    0.1,
                    0.5,
                    1,
                    1
                )
            end

            love.graphics.rectangle(
                "line",
                x,
                hit_y - perfect_height / 2,
                lane_width,
                perfect_height
            )
        end

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.line(
            start_x,
            hit_y,
            start_x + total_width,
            hit_y
        )

        love.graphics.line(
            start_x + lane_width + gap / 2,
            top_y,
            start_x + lane_width + gap / 2,
            hit_y
        )

        do
            local key_flash =
                0.75 + 0.25 * math.sin(
                    love.timer.getTime() * 1.4
                )

            local corner_w = 260
            local edge_margin = screen_w * 0.18

            love.graphics.setFont(
                love.graphics.newFont(26)
            )

            love.graphics.setColor(
                1,
                0.85,
                0,
                key_flash
            )

            love.graphics.printf(
                "Z / A / LEFT",
                edge_margin,
                screen_h - 50,
                corner_w,
                "left"
            )

            love.graphics.setColor(
                0.1,
                0.5,
                1,
                key_flash
            )

            love.graphics.printf(
                "X / D / RIGHT",
                screen_w - corner_w - edge_margin,
                screen_h - 50,
                corner_w,
                "right"
            )
        end

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        for lane = 1, 2 do
            local x =
                (lane == 1)
                and start_x
                or (start_x + lane_width + gap)

            love.graphics.rectangle(
                "line",
                x,
                top_y,
                lane_width,
                hit_y - top_y
            )
        end

        for _, note in pairs(g.spawned) do
            if not note.hit and not note.missed then
                local time_until_hit =
                    note.time - elapsed

                local progress =
                    1 - (
                        time_until_hit /
                        travel_time
                    )

                local y =
                    top_y +
                    progress *
                    (hit_y - top_y)

                local x =
                    (note.lane == 1)
                    and start_x
                    or (start_x + lane_width + gap)

                local difference =
                    math.abs(
                        elapsed - note.time
                    )

                if difference <= 0.05 then
                    love.graphics.setColor(
                        1,
                        0.85,
                        0.05,
                        0.45
                    )

                    love.graphics.rectangle(
                        "fill",
                        x - 12,
                        y - 24,
                        lane_width + 24,
                        48
                    )

                    love.graphics.setColor(
                        1,
                        0.85,
                        0.05,
                        1
                    )

                elseif difference <= 0.25 then
                    love.graphics.setColor(
                        0.2,
                        1,
                        0.3,
                        0.35
                    )

                    love.graphics.rectangle(
                        "fill",
                        x - 9,
                        y - 22,
                        lane_width + 18,
                        44
                    )

                    love.graphics.setColor(
                        1,
                        1,
                        1,
                        1
                    )

                else
                    love.graphics.setColor(
                        1,
                        1,
                        1,
                        1
                    )
                end

                love.graphics.rectangle(
                    "fill",
                    x + 7,
                    y - 13,
                    lane_width - 14,
                    26
                )

                if note.lane == 1 then
                    love.graphics.setColor(
                        1,
                        0.85,
                        0,
                        1
                    )
                else
                    love.graphics.setColor(
                        0.1,
                        0.5,
                        1,
                        1
                    )
                end

                love.graphics.rectangle(
                    "fill",
                    x + 10,
                    y - 10,
                    lane_width - 20,
                    20
                )
            end
        end

        if g.last_judgement ~= "" then
            love.graphics.setFont(
                love.graphics.newFont(32)
            )

            local judgement_width = 300

            local judgement_x =
                (screen_w - judgement_width) / 2

            local judgement_y =
                hit_y - 100

            love.graphics.setColor(
                0,
                0,
                0,
                0.9
            )

            love.graphics.rectangle(
                "fill",
                judgement_x - 15,
                judgement_y - 8,
                judgement_width + 30,
                55,
                6,
                6
            )

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.printf(
                g.last_judgement,
                judgement_x,
                judgement_y,
                judgement_width,
                "center"
            )
        end

        love.graphics.setFont(
            love.graphics.newFont(22)
        )

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.printf(
            "Score: " .. tostring(g.score) .. "     Combo: " .. tostring(g.combo),
            0,
            screen_h - 90,
            screen_w,
            "center"
        )

        if elapsed < -g.lead_in then
            local count =
                math.ceil(-(elapsed + g.lead_in))

            if count > (g.countdown_duration or 3) then
                count = g.countdown_duration or 3
            end

            love.graphics.setColor(
                0,
                0,
                0,
                0.55
            )

            love.graphics.rectangle(
                "fill",
                0,
                0,
                screen_w,
                screen_h
            )

            love.graphics.setFont(
                love.graphics.newFont(140)
            )

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.printf(
                tostring(count),
                0,
                screen_h / 2 - 90,
                screen_w,
                "center"
            )

            love.graphics.setFont(
                love.graphics.newFont(28)
            )

            love.graphics.printf(
                "GET READY - Z/A/LEFT · X/D/RIGHT",
                0,
                screen_h / 2 + 60,
                screen_w,
                "center"
            )
        end

    else
        if g.images.bg then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(
                g.images.bg,
                0, 0, 0,
                screen_w / g.images.bg:getWidth(),
                screen_h / g.images.bg:getHeight()
            )
        else
            love.graphics.setColor(
                0,
                0,
                0,
                1
            )

            love.graphics.rectangle(
                "fill",
                0,
                0,
                screen_w,
                screen_h
            )
        end

        local card_w = 420
        local card_h = 480

        local card_x =
            (screen_w - card_w) / 2

        local card_y =
            (screen_h - card_h) / 2

        love.graphics.setColor(
            0.1,
            0.1,
            0.12,
            0.95
        )

        love.graphics.rectangle(
            "fill",
            card_x,
            card_y,
            card_w,
            card_h,
            12,
            12
        )

        love.graphics.setLineWidth(3)

        love.graphics.setColor(
            0.3,
            0.3,
            0.35,
            1
        )

        love.graphics.rectangle(
            "line",
            card_x,
            card_y,
            card_w,
            card_h,
            12,
            12
        )

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.setFont(
            love.graphics.newFont(28)
        )

        love.graphics.print(
            "STAGE CLEAR!",
            card_x + 130,
            card_y + 25
        )

        local rank_colors = {
            T = {0.2, 0.9, 1.0},
            S = {1.0, 0.85, 0.1},
            A = {0.2, 0.9, 0.3},
            B = {0.2, 0.5, 1.0},
            C = {0.9, 0.5, 0.2},
            Z = {0.9, 0.2, 0.2}
        }

        local displayed_rank =
            g.final_rank or "Z"

        local r_col =
            rank_colors[displayed_rank]
            or {1, 1, 1}

        love.graphics.setColor(
            r_col[1],
            r_col[2],
            r_col[3],
            0.2
        )

        love.graphics.rectangle(
            "fill",
            card_x + 30,
            card_y + 65,
            100,
            100,
            8,
            8
        )

        love.graphics.setColor(
            r_col[1],
            r_col[2],
            r_col[3],
            1
        )

        love.graphics.rectangle(
            "line",
            card_x + 30,
            card_y + 65,
            100,
            100,
            8,
            8
        )

        love.graphics.setFont(
            love.graphics.newFont(42)
        )

        love.graphics.print(
            displayed_rank,
            card_x + 72,
            card_y + 93
        )

        love.graphics.setFont(
            love.graphics.newFont(20)
        )

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.print(
            "Score: " .. g.score,
            card_x + 150,
            card_y + 75
        )

        love.graphics.print(
            "Max Combo: " .. g.max_combo,
            card_x + 150,
            card_y + 105
        )

        local acc_pct =
            math.floor(
                (g.accuracy or 0) * 100 + 0.5
            )

        love.graphics.print(
            "Accuracy: " .. acc_pct .. "%",
            card_x + 150,
            card_y + 135
        )

        love.graphics.line(
            card_x + 30,
            card_y + 185,
            card_x + card_w - 30,
            card_y + 185
        )

        love.graphics.setColor(
            1,
            0.85,
            0.05,
            1
        )

        love.graphics.print(
            "PERFECT:",
            card_x + 40,
            card_y + 205
        )

        love.graphics.print(
            tostring(g.perfects),
            card_x + 280,
            card_y + 205
        )

        love.graphics.setColor(
            0.2,
            0.9,
            0.3,
            1
        )

        love.graphics.print(
            "GREAT:",
            card_x + 40,
            card_y + 235
        )

        love.graphics.print(
            tostring(g.greats),
            card_x + 280,
            card_y + 235
        )

        love.graphics.setColor(
            0.2,
            0.6,
            1.0,
            1
        )

        love.graphics.print(
            "GOOD:",
            card_x + 40,
            card_y + 265
        )

        love.graphics.print(
            tostring(g.goods),
            card_x + 280,
            card_y + 265
        )

        love.graphics.setColor(
            0.9,
            0.25,
            0.25,
            1
        )

        love.graphics.print(
            "MISS:",
            card_x + 40,
            card_y + 295
        )

        love.graphics.print(
            tostring(g.misses),
            card_x + 280,
            card_y + 295
        )

        local btn_w = 200
        local btn_h = 44

        local btn_x =
            card_x + (card_w - btn_w) / 2

        local btn_y =
            card_y + 390

        g.btn_rect = {
            x = btn_x,
            y = btn_y,
            w = btn_w,
            h = btn_h
        }

        local mx, my =
            love.mouse.getPosition()

        local hover =
            mx >= btn_x
            and mx <= btn_x + btn_w
            and my >= btn_y
            and my <= btn_y + btn_h

        if hover then
            love.graphics.setColor(
                0.25,
                0.8,
                0.35,
                1
            )
        else
            love.graphics.setColor(
                0.18,
                0.65,
                0.28,
                1
            )
        end

        love.graphics.rectangle(
            "fill",
            btn_x,
            btn_y,
            btn_w,
            btn_h,
            6,
            6
        )

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.rectangle(
            "line",
            btn_x,
            btn_y,
            btn_w,
            btn_h,
            6,
            6
        )

        love.graphics.print(
            "CONTINUE",
            btn_x + 60,
            btn_y + 14
        )
    end

    love.graphics.pop()
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
	if G.GAME.blind and G.GAME.blind.name == 'Lightners Live' and not G.GAME.blind.disabled and G.STATE ~= 8 then
		G.FUNCS.start_lightners_live_game()
		play_sound("fn_tv_time")
	end
end

end

-- ============================================================================
-- KOVAAK'S GAME CONTAINER
-- ============================================================================

local KOVAAK_RESULT_TIME = 4


local KOVAAK_TASKS = {
    Beginner = {
        { name = "Static Click",     type = "static",      duration = 30, count = 5, radius = 38, par = 36 },
        { name = "Dynamic Click",  type = "dynamic", duration = 30, count = 5, radius = 40, speed = 110, par = 28 },
        { name = "Smooth Tracking",  type = "tracking",    duration = 30, radius = 36, speed = 180, par = 40 },
        { name = "Target Switching", type = "switch",      duration = 30, count = 5, radius = 34, speed = 90, kill_time = 0.45, par = 16 },
    },
    Intermediate = {
        { name = "Static Click",     type = "static",      duration = 30, count = 4, radius = 30, par = 48 },
        { name = "Dynamic Click",  type = "dynamic", duration = 30, count = 4, radius = 32, speed = 170, par = 36 },
        { name = "Smooth Tracking",  type = "tracking",    duration = 30, radius = 28, speed = 280, par = 50 },
        { name = "Target Switching", type = "switch",      duration = 30, count = 4, radius = 26, speed = 140, kill_time = 0.40, par = 22 },
    },
    Advanced = {
        { name = "Static Click",     type = "static",      duration = 30, count = 3, radius = 22, par = 60 },
        { name = "Dynamic Click",  type = "dynamic", duration = 30, count = 3, radius = 26, speed = 240, par = 44 },
        { name = "Smooth Tracking",  type = "tracking",    duration = 30, radius = 22, speed = 400, par = 60 },
        { name = "Target Switching", type = "switch",      duration = 30, count = 3, radius = 20, speed = 200, kill_time = 0.30, par = 30 },
    },
}

-- XMult formula (no cap, difficulty is a MULTIPLIER on what you earn):
--   quality = 0.5 * min(score / par, 2) + 0.5 * (accuracy / 100)     (about 0 to 1.5)
--   XMult   = 1 + KOVAAK_BASE_XMULT * quality * difficulty_multiplier
local KOVAAK_BASE_XMULT = 4
Fortlatro.kovaak_diff_mult = { Beginner = 1, Intermediate = 2, Advanced = 3 }

local KOVAAK_DESCRIPTIONS = {
    static   = "Click the targets as fast and\naccurately as you can.\nA new target appears when one is hit.",
    dynamic = "Moving targets die in one click.\nClick them fast and switch to the next!",
    tracking = "HOLD left click on the moving target.\nStay on it as long as you can.",
    switch   = "HOLD left click on a target until it dies.\nThen switch to the next one.",
}

G.KOVAAK_GAME = {
    active = false,
    state = "idle",          -- "briefing" | "countdown" | "playing" | "results"
    countdown = 0,
    difficulty = "Beginner",
    task = nil,
    timer = 0,
    result_timer = 0,
    targets = {},
    score = 0,
    on_target = 0,
    shots = 0,
    hits = 0,
    final_value = 0,
    final_accuracy = nil,
    final_xmult = 1,
    hold_time = 0,
    hold_on = 0,
    arena = { x = 0, y = 0, w = 1280, h = 720 },
    virtualW = 1280,
    virtualH = 720,
    font = nil,
    big_font = nil,
}

-- =========================
-- Helpers
-- =========================
local function kv_mouse()
    local k = G.KOVAAK_GAME
    local rw, rh = love.graphics.getDimensions()
    local mx, my = love.mouse.getPosition()
    return mx * (k.virtualW / rw), my * (k.virtualH / rh)
end

local function kv_inside(t, x, y)
    local dx, dy = x - t.x, y - t.y
    return dx * dx + dy * dy <= t.r * t.r
end

local function kv_get_difficulty()
    local d = G.GAME and G.GAME.GavDifficulty
    if not KOVAAK_TASKS[d] then d = "Beginner" end
    return d
end

local function kv_random_pos(r, avoid)
    local a = G.KOVAAK_GAME.arena
    local x, y
    for _ = 1, 30 do
        x = a.x + r + math.random() * (a.w - 2 * r)
        y = a.y + r + math.random() * (a.h - 2 * r)
        local ok = true
        for _, t in ipairs(avoid) do
            local dx, dy = x - t.x, y - t.y
            if math.sqrt(dx * dx + dy * dy) < (r + t.r) * 1.3 then ok = false break end
        end
        if ok then return x, y end
    end
    return x, y
end

local function kv_spawn_target(index)
    local k = G.KOVAAK_GAME
    local task = k.task
    local others = {}
    for i, t in ipairs(k.targets) do if i ~= index then others[#others + 1] = t end end

    local x, y = kv_random_pos(task.radius, others)
    local t = { x = x, y = y, r = task.radius, max_r = task.radius, age = 0, hp = 1, vx = 0, vy = 0, turn = 0 }

    if task.type == "switch" or task.type == "dynamic" then
        local ang = math.random() * math.pi * 2
        t.vx, t.vy = math.cos(ang) * task.speed, math.sin(ang) * task.speed
    elseif task.type == "tracking" then
        t.x = k.arena.x + k.arena.w / 2
        t.y = k.arena.y + k.arena.h / 2
        t.vx = (math.random() < 0.5 and -1 or 1) * task.speed
    end

    if index then k.targets[index] = t else k.targets[#k.targets + 1] = t end
end

local function kv_bounce(t, dt)
    local a = G.KOVAAK_GAME.arena
    t.x = t.x + t.vx * dt
    t.y = t.y + t.vy * dt
    if t.x < a.x + t.r then t.x = a.x + t.r; t.vx = math.abs(t.vx)
    elseif t.x > a.x + a.w - t.r then t.x = a.x + a.w - t.r; t.vx = -math.abs(t.vx) end
    if t.y < a.y + t.r then t.y = a.y + t.r; t.vy = math.abs(t.vy)
    elseif t.y > a.y + a.h - t.r then t.y = a.y + a.h - t.r; t.vy = -math.abs(t.vy) end
end

local function kv_sfx(name)
    local config = SMODS.current_mod and SMODS.current_mod.config
    if not config or config.sfx ~= false then play_sound(name) end
end

local function kv_ensure_assets()
    local k = G.KOVAAK_GAME
    if not k.font then
        k.font = love.graphics.newFont(30)
        k.big_font = love.graphics.newFont(48)
    end
end

local function kv_pick_task(difficulty)
    local k = G.KOVAAK_GAME
    local pool = KOVAAK_TASKS[difficulty]
    k.difficulty = difficulty
    k.task = pool[math.random(#pool)]
end

-- =========================
-- Flow
-- =========================
G.FUNCS = G.FUNCS or {}
G.FUNCS.start_kovaak_game = function()
    local k = G.KOVAAK_GAME
    kv_ensure_assets()
    kv_pick_task(kv_get_difficulty())
    k.active = true
    k.state = "briefing"
    k.targets = {}
    k.score, k.on_target, k.shots, k.hits, k.hold_time, k.hold_on = 0, 0, 0, 0, 0, 0
    k.final_value, k.final_accuracy = 0, nil
end

local function kv_begin_task()
    local k = G.KOVAAK_GAME
    local task = k.task
    k.state = "playing"
    k.timer = task.duration
    k.targets = {}
    k.score, k.on_target, k.shots, k.hits, k.hold_time, k.hold_on = 0, 0, 0, 0, 0, 0
    local n = (task.type == "tracking") and 1 or task.count
    for i = 1, n do kv_spawn_target(i) end
end

local function kv_start_countdown()
    local k = G.KOVAAK_GAME
    k.state = "countdown"
    k.countdown = 3
end

local function kv_end_task()
    local k = G.KOVAAK_GAME
    local task = k.task
    local value = k.score
    if task.type == "tracking" then
        value = math.floor((k.on_target / task.duration) * 100 + 0.5)
    end
    k.final_value = value
    local accuracy
    if task.type == "static" or task.type == "dynamic" then
        accuracy = (k.shots > 0) and (k.hits / k.shots * 100) or 0
    else
        accuracy = (k.hold_time > 0) and (k.hold_on / k.hold_time * 100) or 0
    end
    accuracy = math.floor(accuracy + 0.5)
    k.final_accuracy = accuracy
    local quality = 0.5 * math.min(value / task.par, 2) + 0.5 * (accuracy / 100)
    local diff_mult = Fortlatro.kovaak_diff_mult[k.difficulty] or 1
    k.final_xmult = math.floor((1 + KOVAAK_BASE_XMULT * quality * diff_mult) * 100 + 0.5) / 100
    k.targets = {}
    k.state = "results"
    k.result_timer = 0

    -- Practice runs never touch the run's real score
    if G.GAME and not G.GAME.Practice then
        G.GAME.GavScore = value
        G.GAME.GavAccuracy = accuracy
        G.GAME.GavXMult = k.final_xmult
    end
end

local function kv_close()
    local k = G.KOVAAK_GAME
    k.active = false
    k.state = "idle"
    k.targets = {}
end

-- =========================
-- Update Loop
-- =========================
local kv_old_update = love.update or function() end
function love.update(dt)
    kv_old_update(dt)
    local k = G.KOVAAK_GAME
    if not k.active then return end
    if G.SETTINGS and G.SETTINGS.paused then return end

    if k.state == "results" then
        k.result_timer = k.result_timer + dt
        if k.result_timer >= KOVAAK_RESULT_TIME then kv_close() end
        return
    end

    if k.state == "countdown" then
        k.countdown = k.countdown - dt
        if k.countdown <= 0 then kv_begin_task() end
        return
    end

    if k.state ~= "playing" then return end

    local task = k.task
    local mx, my = kv_mouse()
    local holding = love.mouse.isDown(1)

    if task.type == "dynamic" then
        for _, t in ipairs(k.targets) do kv_bounce(t, dt) end

    elseif task.type == "tracking" then
        local t = k.targets[1]
        t.turn = t.turn - dt
        if t.turn <= 0 then
            t.vx = (math.random() < 0.5 and -1 or 1) * task.speed * (0.6 + 0.4 * math.random())
            t.vy = (math.random() - 0.5) * task.speed * 0.4
            t.turn = 0.3 + math.random() * 0.9
        end
        kv_bounce(t, dt)
        if holding then
            k.hold_time = k.hold_time + dt
            if kv_inside(t, mx, my) then
                k.on_target = k.on_target + dt
                k.hold_on = k.hold_on + dt
            end
        end

    elseif task.type == "switch" then
        for _, t in ipairs(k.targets) do kv_bounce(t, dt) end
        if holding then
            k.hold_time = k.hold_time + dt
            for i, t in ipairs(k.targets) do
                if kv_inside(t, mx, my) then
                    k.hold_on = k.hold_on + dt
                    t.hp = t.hp - dt / task.kill_time
                    if t.hp <= 0 then
                        k.score = k.score + 1
                        kv_sfx("fn_hit")
                        kv_spawn_target(i)
                    end
                    break
                end
            end
        end
    end

    k.timer = k.timer - dt
    if k.timer <= 0 then kv_end_task() end
end

-- =========================
--allow other minigames to phase through this
-- =========================
local kv_game_draw_ref = Game.draw
function Game:draw()
    kv_game_draw_ref(self)
    local k = G.KOVAAK_GAME
    if k and k.active then
        local rw, rh = love.graphics.getDimensions()
        love.graphics.push("all")
        love.graphics.setColor(0.05, 0.06, 0.09, 1)
        love.graphics.rectangle("fill", 0, 0, rw, rh)
        love.graphics.pop()
    end
end

-- =========================
-- Drawing Loop
-- =========================
local kv_old_draw = love.draw or function() end
function love.draw()
    kv_old_draw()
    local k = G.KOVAAK_GAME
    if not k.active then return end
    kv_ensure_assets()

    local rw, rh = love.graphics.getDimensions()
    love.graphics.push("all")
    love.graphics.scale(rw / k.virtualW, rh / k.virtualH)
    local vw, vh = k.virtualW, k.virtualH

    love.graphics.setFont(k.font)

    if k.state == "briefing" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(k.big_font)
        love.graphics.printf(k.task.name, 0, vh / 2 - 190, vw, "center")
        love.graphics.setFont(k.font)
        love.graphics.setColor(0.6, 1, 0.7, 1)
        love.graphics.printf(string.upper(k.difficulty) .. "  -  " .. k.task.duration .. " seconds", 0, vh / 2 - 120, vw, "center")
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(KOVAAK_DESCRIPTIONS[k.task.type], 0, vh / 2 - 60, vw, "center")
        local footer = "CLICK ANYWHERE TO START"
        if G.GAME and G.GAME.Practice then
            footer = "1 / 2 / 3: Beginner / Intermediate / Advanced   -   ESC: quit\n" .. footer
        end
        love.graphics.printf(footer, 0, vh / 2 + 120, vw, "center")

    elseif k.state == "countdown" or k.state == "playing" then
        local task = k.task
        local mx, my = kv_mouse()
        local holding = love.mouse.isDown(1)

        for _, t in ipairs(k.targets) do
            if task.type == "tracking" then
                -- lighter when NOT being held on, darker while you are tracking it
                if holding and kv_inside(t, mx, my) then love.graphics.setColor(0.1, 0.7, 0.2, 1)
                else love.graphics.setColor(0.4, 1, 0.5, 1) end
            elseif task.type == "switch" then
                love.graphics.setColor(0.1 + 0.3 * t.hp, 0.35 + 0.6 * t.hp, 0.15 + 0.3 * t.hp, 1)
            else
                love.graphics.setColor(0.2, 0.9, 0.3, 1)
            end
            love.graphics.circle("fill", t.x, t.y, t.r)
            love.graphics.setColor(1, 1, 1, 0.9)
            love.graphics.circle("line", t.x, t.y, t.r)
        end

        -- HUD: score top-left, timer top-middle
        love.graphics.setColor(1, 1, 1, 1)
        local score_txt
        if k.state == "playing" and task.type == "tracking" then
            local elapsed = task.duration - k.timer
            local pct = elapsed > 0 and math.floor(k.on_target / elapsed * 100) or 0
            score_txt = "On target: " .. pct .. "%"
        elseif task.type == "tracking" then
            score_txt = "On target: 0%"
        else
            score_txt = "Score: " .. k.score
        end
        love.graphics.printf(score_txt, 20, 15, 500, "left")
        local shown_time = (k.state == "countdown") and task.duration or k.timer
        love.graphics.printf(string.format("%.1fs", math.max(0, shown_time)), 0, 15, vw, "center")

        if k.state == "countdown" then
            love.graphics.setColor(0, 0, 0, 0.35)
            love.graphics.rectangle("fill", 0, 0, vw, vh)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(k.big_font)
            love.graphics.printf(tostring(math.max(1, math.ceil(k.countdown))), 0, vh / 2 - 30, vw, "center")
            love.graphics.setFont(k.font)
            love.graphics.printf(task.name, 0, vh / 2 - 100, vw, "center")
        end

    elseif k.state == "results" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(k.big_font)
        love.graphics.printf("TIME'S UP!", 0, vh / 2 - 150, vw, "center")
        love.graphics.setFont(k.font)
        local val = (k.task.type == "tracking") and (k.final_value .. "% on target") or tostring(k.final_value)
        local txt = k.task.name .. "\n\nFINAL SCORE: " .. val
        txt = txt .. "\nACCURACY: " .. k.final_accuracy .. "%"
        txt = txt .. "\nXMULT: x" .. string.format("%.2f", k.final_xmult)
        love.graphics.printf(txt, 0, vh / 2 - 80, vw, "center")
    end

    love.graphics.pop()
end

-- =========================
-- Input
-- =========================
local kv_old_mouse = love.mousepressed or function() end
function love.mousepressed(rx, ry, button, istouch, presses)
    local k = G.KOVAAK_GAME
    if not k.active then
        kv_old_mouse(rx, ry, button, istouch, presses)
        return
    end
    if button ~= 1 then return end

    if k.state == "briefing" then
        kv_start_countdown()
        return
    end

    if k.state ~= "playing" then return end

    if k.state == "playing" and (k.task.type == "static" or k.task.type == "dynamic") then
        local rw, rh = love.graphics.getDimensions()
        local x, y = rx * (k.virtualW / rw), ry * (k.virtualH / rh)
        k.shots = k.shots + 1
        for i = #k.targets, 1, -1 do
            if kv_inside(k.targets[i], x, y) then
                k.hits = k.hits + 1
                k.score = k.score + 1
                kv_sfx("fn_hit")
                kv_spawn_target(i)
                return
            end
        end
    end
end

local kv_old_keypressed = love.keypressed or function() end
function love.keypressed(key, scancode, isrepeat)
    local k = G.KOVAAK_GAME
    if k.active and G.GAME and G.GAME.Practice then
        if key == "escape" then
            kv_close()
            return
        end
        if k.state == "briefing" then
            local pick = ({ ["1"] = "Beginner", ["2"] = "Intermediate", ["3"] = "Advanced" })[key]
            if pick then kv_pick_task(pick) return end
        end
    end
    -- No pausing / hotkeys while the minigame is up (ESC would open the pause menu)
    if k.active then return end

    kv_old_keypressed(key, scancode, isrepeat)
end

-- Also block the pause/options menu from any other path (gamepad Start, Options button, etc.)
local kv_options_ref = G.FUNCS.options
G.FUNCS.options = function(e)
    if G.KOVAAK_GAME and G.KOVAAK_GAME.active then return end
    return kv_options_ref(e)
end



G.FUNCS.play_minigame_kovaak_benchmark = function(e)
    if G.GAME then G.GAME.Practice = true end
    G.FUNCS.exit_overlay_menu()
    G.FUNCS.start_kovaak_game()
end


-- ============================================================================
-- FORTLATRO MINIGAMES TAB SETUP
-- ============================================================================

-- Register the atlas. SMODS handles the scaling and texture loading safely.
SMODS.Atlas {
	key = 'fn_minigames',
	path = 'minigames.png',
	px = 71,
	py = 95,
}

-- Store game configurations safely with description lines
Fortlatro.minigames = {
	{
		key = "pizza_vs_burgers",
		name = "Pizzas vs Burgers",
		desc = {
			"Fight the Durr Burger army"
		},
		pos = { x = 0, y = 0 }, 
		colour = G.C.GOLD,
		action = function()
			G.FUNCS.activatekonami()
		end
	},
	{
		key = "find_medkit",
		name = "Find Medkit",
		desc = {
			"Find the Medkit",
			"before it is too late!"
		},
		pos = { x = 1, y = 0 }, 
		colour = G.C.RED,
		action = function()
			G.FUNCS.start_find_game()
		end
	},
	{
		key = "zip_zonk_bang",
		name = "Zip Zonk Bang",
		desc = {
			"Shoot the outlaws!",
			"Avoid shooting Wonkee!",
		},
		pos = { x = 0, y = 1 }, 
		colour = G.C.ORANGE,
		action = function()
			G.FUNCS.start_carnival_game()
		end
	},
	{
		key = "delulu",
		name = "Delulu",
		desc = {
			"Keep the bar full by talking",
		},
		pos = { x = 2, y = 0 },
		colour = G.C.PURPLE,
		action = function()
			G.GAME.Practice = true
			G.GAME.MicLevel = 50
			G.GAME.InitialCooldown = 2.0
			G.GAME.YapCount = 0

			-- Safely fetch and start only the active microphone device
			local device = Fortlatro.start_microphone()
			if device then
				MicMod.active = true
			else
				pcall(function() MicMod.stop_audio() end)
			end
		end
	},
	{
		key = "dark_voyager",
		name = "Dark Voyager",
		desc = {
			"Avoid the Lasers"
		},
		pos = { x = 3, y = 0 }, 
		colour = G.C.ORANGE,
		action = function()
			G.FUNCS.start_dodge_game()
		end
	},
	{
		key = "fight_the_storm",
		name = "Fight The Storm",
		desc = {
			"Defend the atlas",
			"From incoming Husks",
		},
		pos = { x = 4, y = 0 }, 
		colour = G.C.BLUE,
		action = function()
			G.FUNCS.start_defense_game()
		end
	},
	{
		key = "deliver_the_bomb",
		name = "Deliver The Bomb",
		desc = {
			"Connect the Armory",
			"to the Launcher",
		},
		pos = { x = 5, y = 0 }, 
		colour = G.C.GREY,
		action = function()
			G.FUNCS.start_pipe_game()
		end
	},
	{
		key = "tetris_rift",
		name = "Tetris Rift",
		desc = {
			"Get the Tetris",
		},
		pos = { x = 1, y = 1 }, 
		colour = G.C.ORANGE,
		action = function()
			G.FUNCS.start_tetris_game()
		end
	},
	{
		key = "kovaak_benchmark",
		name = "Aim Trainer",
		desc = { "Complete a random KovaaK's task"},
		pos = { x = 2, y = 1 },
		colour = G.C.ORANGE,
		action = function() G.FUNCS.start_kovaak_game() end
	},

}

-- Helper function to check if a minigame boss is currently active
local function is_minigame_boss_active()
	return G.GAME and G.GAME.blind and (
		G.GAME.blind.name == 'Delulu' or
		G.GAME.blind.name == 'Dark Voyager' or 
		G.GAME.blind.name == 'Fight The Storm' or 
		G.GAME.blind.name == 'Deliver The Bomb' or
		G.GAME.blind.name == 'Tetris Rift'
	)
end

-- Registry of click actions for the UI buttons using "fn" (Sets Practice, closes UI, starts game)
G.FUNCS.play_minigame_pizza_vs_burgers = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.activatekonami()
end

G.FUNCS.play_minigame_find_medkit = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.start_find_game()
end

G.FUNCS.play_minigame_delulu = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	
	-- Initialize Mic Mod variables safely
	G.GAME.MicLevel = 50
	G.GAME.InitialCooldown = 2.0
	G.GAME.YapCount = 0

	-- Safely fetch and start only the user's active microphone
	local device = Fortlatro.start_microphone()
	if device then
		MicMod.active = true
	else
		pcall(function() MicMod.stop_audio() end)
	end
end

G.FUNCS.play_minigame_dark_voyager = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.start_dodge_game()
end

G.FUNCS.play_minigame_fight_the_storm = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.start_defense_game()
end

G.FUNCS.play_minigame_deliver_the_bomb = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.start_pipe_game()
end

G.FUNCS.play_minigame_zip_zonk_bang = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.start_carnival_game()
end

G.FUNCS.play_minigame_tetris_rift = function(e)
	if is_minigame_boss_active() then
		play_sound('cancel', 1, 0.4)
		return
	end
	if G.GAME then G.GAME.Practice = true end
	G.FUNCS.exit_overlay_menu()
	G.FUNCS.start_tetris_game()
end

-- Generates the UI block for a single minigame
function Fortlatro.generate_minigame_card(game)
	
	-- Build a crash-proof static UI Sprite using our registered atlas
	local game_sprite = Sprite(
		0, 0, 
		0.85 * G.CARD_W, 
		0.85 * G.CARD_H, 
		G.ASSET_ATLAS["fn_minigames"], 
		game.pos or {x = 0, y = 0}
	)

	-- Build description rows dynamically from the game's description array
	local desc_nodes = {}
	if game.desc then
		for _, line in ipairs(game.desc) do
			desc_nodes[#desc_nodes + 1] = {
				n = G.UIT.R,
				config = { align = "lm" },
				nodes = {
					{ 
						n = G.UIT.T, 
						config = { 
							text = line, 
							scale = 0.32, -- Smaller scale so it fits nicely under the title
							colour = G.C.UI.TEXT_LIGHT, 
							shadow = true 
						} 
					}
				}
			}
		end
	end

	-- Return block formatted as G.UIT.C (Column)
	return {
		n = G.UIT.C,
		config = { align = "cm", padding = 0.1, colour = G.C.DARK_EDITION, r = 0.1, minw = 3.8, minh = 1.8 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.05 },
				nodes = {
					-- Left Column: Container holding the static Sprite
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							colour = G.C.CLEAR,
						},
						nodes = {
							{ n = G.UIT.O, config = { object = game_sprite } }
						}
					},
					-- Right Column: Title, Description, and Play Button
					{
						n = G.UIT.C,
						config = { align = "lm", padding = 0.1 },
						nodes = {
							-- 1. Minigame Title
							{
								n = G.UIT.R,
								config = { align = "lm" },
								nodes = {
									{ n = G.UIT.T, config = { text = game.name, scale = 0.45, colour = game.colour or G.C.WHITE, shadow = true } }
								}
							},
							-- 2. Minigame Description Lines
							{
								n = G.UIT.R,
								config = { align = "lm", padding = 0.03 },
								nodes = desc_nodes
							},
							-- 3. Play Button
							{
								n = G.UIT.R,
								config = { align = "lm", padding = 0.03 },
								nodes = {
									UIBox_button({
										label = { "PLAY" },
										button = "play_minigame_" .. game.key,
										colour = G.C.GREEN,
										minw = 1.2,
										minh = 0.5,
										scale = 0.35
									})
								}
							}
						}
					}
				}
			}
		}
	}
end

-- Register the extra tab with SMODS on the mod object
Fortlatro.extra_tabs = function()
	return {
		{
			label = "Minigames",
			tab_definition_function = function()
				local grid_rows = {}
				local current_row_nodes = {}
				
				for i, game in ipairs(Fortlatro.minigames) do
					-- Create the card (now safely a Column element)
					current_row_nodes[#current_row_nodes + 1] = Fortlatro.generate_minigame_card(game)
					
					-- Group into rows of 2
					if i % 2 == 0 or i == #Fortlatro.minigames then
						-- UI FIX: If there is an odd number of games, this row only has 1 card.
						-- We insert an invisible dummy column with matching width to prevent Balatro from centering it.
						if #current_row_nodes == 1 and i == #Fortlatro.minigames then
							current_row_nodes[#current_row_nodes + 1] = {
								n = G.UIT.C,
								config = { align = "cm", padding = 0.1, colour = G.C.CLEAR, minw = 3.8, minh = 1.8 },
								nodes = {}
							}
						end

						grid_rows[#grid_rows + 1] = {
							n = G.UIT.R,
							config = { align = "cm", padding = 0.05 },
							nodes = current_row_nodes
						}
						current_row_nodes = {} -- Reset for the next row
					end
				end
				
				-- Instantiate Steamodded's custom ScrollBox wrapper component
				local scrollbox = SMODS.UIScrollBox({
					content = {
						definition = {
							n = G.UIT.ROOT,
							config = { colour = G.C.CLEAR },
							nodes = {
								{
									n = G.UIT.C,
									config = { align = "cm" },
									nodes = grid_rows,
								}
							}
						},
						config = { align = "cm" },
					},
					overflow = {
						node_config = {
							maxh = 4.5, -- Fit cleanly inside our tab box limits
							r = 0.1,
						},
					},
				})

				-- Outer standard tab node return, featuring the scrollbox object and a scrollbar
				return {
					n = G.UIT.ROOT,
					config = {
						emboss = 0.05,
						r = 0.1,
						align = "tm",
						padding = 0.1,
						colour = G.C.CLEAR
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								r = 0.1,
								minw = 8.2,
								minh = 4.7,
								align = "tm",
								padding = 0.1,
								colour = G.C.BLACK
							},
							nodes = {
								{
									n = G.UIT.C,
									config = {
										align = "cm",
										padding = 0.1,
										colour = darken(G.C.BLACK, 0.2),
										emboss = 0.05,
										r = 0.1
									},
									nodes = {
										{
											n = G.UIT.O,
											config = {
												align = "cm",
												object = scrollbox,
											},
										},
										{
											n = G.UIT.C,
											config = { align = "cm" },
											nodes = {
												SMODS.GUI.scrollbar({
													h = 4.3,
													w = 0.15,
													scroll_mult = 1.5,
													colour = G.C.GREEN,
													bg_colour = G.C.BLACK,
													scroll_collision_obj = scrollbox,
												}),
											},
										},
									}
								},
							}
						},
					}
				}
			end
		}
	}
end
-------------------------------------------------------------------
-- 1. UI INJECTION & BOSS MAPPING
-------------------------------------------------------------------
Fortlatro_Practice = Fortlatro_Practice or {}

-- Lookup table linking Boss Blind keys to their corresponding functions
Fortlatro_Practice.boss_actions = {
    ['bl_fn_DarkVoyager'] = function() G.FUNCS.start_dodge_game() end,
    ['bl_fn_Atlas']       = function() G.FUNCS.start_defense_game() end,
    ['bl_fn_Bomb']        = function() G.FUNCS.start_pipe_game() end,
    ['bl_fn_Delulu']      = function()
        G.GAME.Practice = true
        G.GAME.MicLevel = 50
        G.GAME.InitialCooldown = 2.0
        G.GAME.YapCount = 0

        -- Safely fetch and start the currently selected microphone device
        local device = Fortlatro.start_microphone()
        if device then
            MicMod.active = true
        else
            MicMod.stop_audio()
        end
    end,
	['bl_fn_Tetris']        = function() G.FUNCS.start_tetris_game() end,
}

Fortlatro_Practice.create_UIBox_blind_choice_ref = create_UIBox_blind_choice

function create_UIBox_blind_choice(type, run_info)
    -- Build default UI table
    local t = Fortlatro_Practice.create_UIBox_blind_choice_ref(type, run_info)

    -- Fetch active boss choice key
    local current_boss = G.GAME and G.GAME.round_resets and G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss

    -- Target all valid Fortlatro Bosses dynamically
    if type == 'Boss' and current_boss and Fortlatro_Practice.boss_actions[current_boss] then

        -- Construct Blue "PRACTICE" Button
        local custom_button = {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.05,
                        button = "custom_boss_practice",
                        colour = G.C.BLUE,
                        hover = true,
                        shadow = true,
                        r = 0.1,
                        minw = 2.4,
                        minh = 0.8,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = "cm" },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = "PRACTICE",
                                        scale = 0.35,
                                        colour = G.C.WHITE,
                                        shadow = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        -- Break out of column container and place under 'Up the Ante'
        if t and t.nodes then
            local old_nodes = t.nodes
            t.nodes = {
                {
                    n = G.UIT.C,
                    config = { align = "cm" },
                    nodes = {
                        { n = G.UIT.R, config = { align = "cm" }, nodes = old_nodes },
                        custom_button
                    }
                }
            }
        end
    end

    return t
end


-------------------------------------------------------------------
-- 2. DYNAMIC BUTTON ACTION HANDLER
-------------------------------------------------------------------
G.FUNCS.custom_boss_practice = function(e)
    stop_use()
    G.CONTROLLER.locks.custom_boss_practice = true

    G.E_MANAGER:add_event(Event({
        no_delete = true,
        trigger = 'after',
        blocking = false,
        blockable = false,
        delay = 0.5,
        timer = 'TOTAL',
        func = function()
            G.CONTROLLER.locks.custom_boss_practice = nil
            return true
        end
    }))

    play_sound('button')

    -- Fetch current Boss and execute mapped practice action
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.GAME.Practice = true
            
            local current_boss = G.GAME and G.GAME.round_resets and G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss
            if current_boss and Fortlatro_Practice.boss_actions[current_boss] then
                Fortlatro_Practice.boss_actions[current_boss]()
            end

            return true
        end
    }))
end


local igo = Game.init_game_object
function Game:init_game_object(...)
    local ret = igo(self, ...)
    -- preserve values if loading a save; otherwise seed to 1
    ret.find_wins    = tonumber(ret.find_wins)     or 1
    return ret
end

local original_game_update = Game.update
function Game:update(dt)
    original_game_update(self, dt)
    
    if G.STAGE ~= G.STAGES.RUN then return end


    --Ned Game Cleanup
    if G.STATE == 8 or G.STATE == 6 or G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
        if G.FIND_GAME.active then
			G.FIND_GAME.active = false
		end
    end
	
	--Dodge Game Cleanup
	if G.STATE == 8 or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
		if G.DODGE_GAME.active then
			G.DODGE_GAME.active = false
			G.DODGE_GAME.beams = {} 
			G.DODGE_GAME.shake_timer = 0
		end
	end
	
	--Find Game Cleanup
	if G.STATE == 8 or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
		if G.DEFENSE_GAME.active then
			G.DEFENSE_GAME.active = false
		end
	end
	
	--Pipe Game Cleanup
	if G.STATE == 8 or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
		if G.PIPE_GAME.active then
			G.PIPE_GAME.active = false
		end
	end
	
	--Tetris Game Cleanup
	if G.STATE == 8 or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
		if G.TETRIS_GAME.active then
			G.TETRIS_GAME.active = false
		end
	end
	
	--TV Game Cleanup
	if G.STATE == 8 or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
		if G.LIGHTNERS_LIVE_GAME and G.LIGHTNERS_LIVE_GAME.active then
			G.LIGHTNERS_LIVE_GAME.active = false
		end
	end
	
	--KOVAAKS Game Cleanup
	if G.STATE == 8 or G.STATE == G.STATES.BLIND_SELECT and not G.GAME.Practice then
		if G.KOVAAK_GAME.active then G.KOVAAK_GAME.active = false end
	end
end
