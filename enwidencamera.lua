local camera = Scene.gameplayCamera
local skyInputLine = Scene.skyInputLine
local skyInputLabel = Scene.skyInputLabel

local enwidenCameraFactor = Channel.keyframe().setDefaultEasing("l").addKey(0, 0);

camera.translationY = camera.translationY + enwidenCameraFactor * 4.5
camera.translationZ = camera.translationZ + enwidenCameraFactor * 4.5
skyInputLine.translationY = skyInputLine.translationY + enwidenCameraFactor * 2.745
skyInputLine.scaleX = skyInputLine.scaleX + enwidenCameraFactor * 2.745
skyInputLabel.translationY = skyInputLabel.translationY + enwidenCameraFactor * 2.745

addScenecontrol("enwidencameralua", {"duration", "toggle", "easing"}, function(cmd)
    local timing = cmd.timing
    local duration = cmd.args[1]
    local toggle = cmd.args[2]
    local easing = cmd.args[3]

    enwidenCameraFactor.addKey(timing, enwidenCameraFactor.valueAt(timing), easing)
    enwidenCameraFactor.addKey(timing + duration, toggle, easing)
end)