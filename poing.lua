-- a game of pong but you are the ball
w = 320
h = platform.window:height()
isGameState = true
score = 0

local ball = {
    x = w / 2,
    y = h / 2,
    radius = 10,
    dx = 1.5,
    dy = 1.5,
    color = {
        r = 255,
        g = 255,
        b = 255,
    },
}

local p1 = {}
p1.width = 4
p1.height = 25
p1.speed = 1.1
p1.y = h / 2 - p1.height / 2
p1.x = 2

settings = {
    index = 1,
    seizureBall = false,
}

function getRandomColor()
    local r = math.random(255)
    local g = math.random(255)
    local b = math.random(255)
    return {r,g,b}
end

function on.timer()
    if not isGameState then
        platform.window:invalidate()
        return
    end
    ball.x = ball.x + ball.dx
    ball.y = ball.y + ball.dy

    if ball.dx < 0 and ball.x < w / 2 + w / 4 then
        if ball.y > p1.y + p1.height/2 then
            p1.y = p1.y + p1.speed
        elseif ball.y < p1.y + p1.height/2 then
            p1.y = p1.y - p1.speed
        end
    end
    -- top/bottom collision
    if ball.y - ball.radius < 0 or ball.y + ball.radius > h then
        ball.dy = -ball.dy
    end
    -- left paddle collision
    if ball.x - ball.radius <= p1.x + p1.width and
       ball.y >= p1.y and ball.y <= p1.y + p1.height then
        ball.dx = math.abs(ball.dx)
        score = score - 1
        p1.speed = p1.speed - 0.1
    end
    -- wall collision
    if ball.x + ball.radius > w then
        ball.dx = -math.abs(ball.dx)
    end

    -- ball scoring
    if ball.x - ball.radius < 0 then
        ball.x = w/2
        ball.y = h/2
        ball.dx = -ball.dx
        score = score + 1
        p1.speed = p1.speed + 0.1
    end

    p1.y  = math.max(0,math.min(h - p1.height, p1.y))
    platform.window:invalidate()
end

function on.escapeKey()
    isGameState = not isGameState
end

function on.arrowUp()
    if not isGameState then
        settings.index = settings.index - 1
    end
    if isGameState then
        ball.dy = -math.abs(ball.dy)
    end
end

function on.arrowDown()
    if isGameState then
        ball.dy = math.abs(ball.dy)
    end
    if not isGameState then
        settings.index = settings.index + 1
    end
end

function on.arrowLeft()
    if not isGameState then
        if settings.index == 1 then
            settings.seizureBall = not settings.seizureBall
        end
    end
end

function on.arrowRight()
    if not isGameState then
        if settings.index == 1 then
            settings.seizureBall = not settings.seizureBall
        end
    end
end

function on.paint(gc)
    gc:setColorRGB(0,0,0)
    gc:fillRect(0,0,w,h)

    if isGameState then
        gc:setColorRGB(255,255,255)
        gc:fillRect(p1.x, p1.y, p1.width, p1.height)
        gc:drawString(score, w/2 - gc:getStringWidth(score)/2, 0, "top")
        local randomColor = getRandomColor()
        if settings.seizureBall then
            gc:setColorRGB(randomColor[1],randomColor[2],randomColor[3])
        else
            gc:setColorRGB(255,255,255)
        end
        gc:fillArc(ball.x,ball.y,ball.radius,ball.radius,0,360)
    else
        gc:setColorRGB(255,255,255)
        gc:drawString("Poing", w/2 - gc:getStringWidth("Poing")/2, 10, "top")
        gc:drawString("Seizure Ball  " .. tostring(settings.seizureBall), w/2 - gc:getStringWidth("Seizure Ball")/2, h/2, "middle")
        gc:drawString("Settings active", w - gc:getStringWidth("Settings active"),h, "bottom")
    end
end

timer.start(0.01) -- keep this line at the bottom