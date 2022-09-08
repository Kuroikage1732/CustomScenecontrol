local track = Scene.track

-- enwidenlaneslua
local leftEdgeFactor = Channel.keyframe().setDefaultEasing("l").addKey(0, 1)
local rightEdgeFactor = Channel.keyframe().setDefaultEasing("l").addKey(0, 1)

track.edgeLAlpha = track.edgeLAlpha * leftEdgeFactor
track.edgeRAlpha = track.edgeRAlpha * rightEdgeFactor

local extraLanes = {}
local criticalLines = {}
local divideLines = {}
local leftEdges = {}
local rightEdges = {}
local lanesFactor = {}
local leftEdgesFactor = {}
local rightEdgesFactor = {}
local laneStatus = {}

local function extraLane(i)
    if lanesFactor[i] ~= nil then
        return
    end
    lanesFactor[i] = Channel.keyframe().setDefaultEasing("l").addKey(0, 0)
    leftEdgesFactor[i] = Channel.keyframe().setDefaultEasing("l").addKey(0, 0)
    rightEdgesFactor[i] = Channel.keyframe().setDefaultEasing("l").addKey(0, 0)
    laneStatus[i] = Channel.keyframe().setDefaultEasing("inconst").addKey(0, 0)

    local posY = 100 * lanesFactor[i]

    extraLanes[i] = track.extraL.copy()
    extraLanes[i].translationX = track.extraL.translationX + 2.384 * (0 - i)
    extraLanes[i].translationY = Channel.min(extraLanes[i].translationY + posY, Channel.constant(0))
    extraLanes[i].colorA = extraLanes[i].colorA + 255 * lanesFactor[i]

    criticalLines[i] = track.criticalLine0.copy()
    criticalLines[i].translationX = track.criticalLine0.translationX + 2.384 * (0 - i)
    criticalLines[i].colorA = criticalLines[i].colorA + 255 * lanesFactor[i]

    if i <= 2 then
        divideLines[i] = track.divideLine45.copy()
        divideLines[i].translationX = track.divideLine45.translationX + 2.384 * (0 - i)
    else
        divideLines[i] = track.divideLine01.copy()
        divideLines[i].translationX = track.divideLine01.translationX - 2.384 * (i - 5)
    end
    divideLines[i].colorA = divideLines[i].colorA + 255 * lanesFactor[i]

    leftEdges[i] = track.edgeExtraL.copy()
    leftEdges[i].translationX = track.edgeExtraL.translationX + 2.384 * (0 - i)
    leftEdges[i].colorA = leftEdges[i].colorA + 255 * leftEdgesFactor[i]

    rightEdges[i] = track.edgeExtraR.copy()
    rightEdges[i].translationX = track.edgeExtraR.translationX - 2.384 * (i - 5)
    rightEdges[i].colorA = rightEdges[i].colorA + 255 * rightEdgesFactor[i]
end

local recentToggle = 0
addScenecontrol("enwidenlaneslua", { "duration", "toggle" }, function(cmd)
    local timing = cmd.timing
    local duration = cmd.args[1]
    local toggle = cmd.args[2]

    if toggle == recentToggle then
        return
    end

    if recentToggle == 0 then
        leftEdgeFactor.addKey(timing, leftEdgeFactor.valueAt(timing))
        leftEdgeFactor.addKey(timing + duration, 0)
        rightEdgeFactor.addKey(timing, rightEdgeFactor.valueAt(timing))
        rightEdgeFactor.addKey(timing + duration, 0)
    else
        leftEdgesFactor[1 - recentToggle].addKey(timing, leftEdgesFactor[1 - recentToggle].valueAt(timing))
        leftEdgesFactor[1 - recentToggle].addKey(timing + duration, 0)
        rightEdgesFactor[4 + recentToggle].addKey(timing, rightEdgesFactor[4 + recentToggle].valueAt(timing))
        rightEdgesFactor[4 + recentToggle].addKey(timing + duration, 0)
    end

    if toggle < recentToggle then
        for i = 0 - toggle, 1 - recentToggle, -1 do
            lanesFactor[i].addKey(timing, lanesFactor[i].valueAt(timing))
            lanesFactor[i].addKey(timing + duration, 0)
            laneStatus[i].addKey(timing, 0)
        end
        for i = 5 + toggle, 4 + recentToggle, 1 do
            lanesFactor[i].addKey(timing, lanesFactor[i].valueAt(timing))
            lanesFactor[i].addKey(timing + duration, 0)
            laneStatus[i].addKey(timing, 0)
        end
    end

    for i = 0, 1 - toggle, -1 do
        extraLane(i)
        lanesFactor[i].addKey(timing, lanesFactor[i].valueAt(timing))
        lanesFactor[i].addKey(timing + duration, 1)
        laneStatus[i].addKey(timing, 1)
    end
    for i = 5, 4 + toggle, 1 do
        extraLane(i)
        lanesFactor[i].addKey(timing, lanesFactor[i].valueAt(timing))
        lanesFactor[i].addKey(timing + duration, 1)
        laneStatus[i].addKey(timing, 1)
    end

    if toggle == 0 then
        leftEdgeFactor.addKey(timing, leftEdgeFactor.valueAt(timing))
        leftEdgeFactor.addKey(timing + duration, 1)
        rightEdgeFactor.addKey(timing, rightEdgeFactor.valueAt(timing))
        rightEdgeFactor.addKey(timing + duration, 1)
    else
        leftEdgesFactor[1 - toggle].addKey(timing, leftEdgesFactor[1 - toggle].valueAt(timing))
        leftEdgesFactor[1 - toggle].addKey(timing + duration, 1)
        rightEdgesFactor[4 + toggle].addKey(timing, leftEdgesFactor[4 + toggle].valueAt(timing))
        rightEdgesFactor[4 + toggle].addKey(timing + duration, 1)
    end

    recentToggle = toggle
end)

-- displaytrack
local trackFactor = Channel.keyframe().setDefaultEasing("l").addKey(0, 1)

track.colorA = track.colorA * trackFactor
track.divideLine12.colorA = track.divideLine12.colorA * trackFactor
track.divideLine23.colorA = track.divideLine12.colorA * trackFactor
track.divideLine34.colorA = track.divideLine12.colorA * trackFactor
track.criticalLine1.colorA = track.criticalLine1.colorA * trackFactor
track.criticalLine2.colorA = track.criticalLine1.colorA * trackFactor
track.criticalLine3.colorA = track.criticalLine1.colorA * trackFactor
track.criticalLine4.colorA = track.criticalLine1.colorA * trackFactor

addScenecontrol("displaytrack", { "duration", "toggle" }, function(cmd)
    local timing = cmd.timing
    local duration = cmd.args[1]
    local toggle = cmd.args[2]

    trackFactor.addKey(timing, trackFactor.valueAt(timing))
    trackFactor.addKey(timing + duration, toggle)
end)

local function setEdge(timing, duration, lane, toggle)
    if laneStatus[lane] == nil or laneStatus[lane].valueAt(timing) == toggle then
        return
    end

    notify(toggle)

    if toggle == 1 then
        if laneStatus[lane - 1] ~= nil and laneStatus[lane - 1].valueAt(timing + 1) == 1 then
            rightEdgesFactor[lane - 1].addKey(timing, rightEdgesFactor[lane - 1].valueAt(timing))
            rightEdgesFactor[lane - 1].addKey(timing + duration, 0)
        else
            leftEdgesFactor[lane].addKey(timing, leftEdgesFactor[lane].valueAt(timing))
            leftEdgesFactor[lane].addKey(timing + duration, 1)
        end
        if laneStatus[lane + 1] ~= nil and laneStatus[lane + 1].valueAt(timing + 1) == 1 then
            leftEdgesFactor[lane + 1].addKey(timing, leftEdgesFactor[lane + 1].valueAt(timing))
            leftEdgesFactor[lane + 1].addKey(timing + duration, 0)
        else
            rightEdgesFactor[lane].addKey(timing, rightEdgesFactor[lane].valueAt(timing))
            rightEdgesFactor[lane].addKey(timing + duration, 1)
        end
    else
        if laneStatus[lane - 1] ~= nil and laneStatus[lane - 1].valueAt(timing + 1) == 1 then
            rightEdgesFactor[lane - 1].addKey(timing, rightEdgesFactor[lane - 1].valueAt(timing))
            rightEdgesFactor[lane - 1].addKey(timing + duration, 1)
        else
            leftEdgesFactor[lane].addKey(timing, leftEdgesFactor[lane].valueAt(timing))
            leftEdgesFactor[lane].addKey(timing + duration, 0)
        end
        if laneStatus[lane + 1] ~= nil and laneStatus[lane + 1].valueAt(timing + 1) == 1 then
            leftEdgesFactor[lane + 1].addKey(timing, leftEdgesFactor[lane + 1].valueAt(timing))
            leftEdgesFactor[lane + 1].addKey(timing + duration, 1)
        else
            rightEdgesFactor[lane].addKey(timing, rightEdgesFactor[lane].valueAt(timing))
            rightEdgesFactor[lane].addKey(timing + duration, 0)
        end
    end
end

addScenecontrol("extralane", { "lane", "duration", "toggle" }, function(cmd)
    local timing = cmd.timing
    local lane = cmd.args[1]
    local duration = cmd.args[2]
    local toggle = cmd.args[3]
    if toggle ~= 0 then
        toggle = 1
    end

    extraLane(lane - 1)
    extraLane(lane)
    extraLane(lane + 1)

    if laneStatus[lane].valueAt(timing + 1) == toggle then
        return
    end

    setEdge(timing, duration, lane, toggle)

    lanesFactor[lane].addKey(timing, lanesFactor[lane].valueAt(timing))
    lanesFactor[lane].addKey(timing + duration, toggle)
    laneStatus[lane].addKey(timing, toggle)
end)
