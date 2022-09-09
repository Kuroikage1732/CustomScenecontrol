addMacro("DisplayExtraLane", function ()
    local request =  EventSelectionInput.requestEvents(
        EventSelectionConstraint.create().hold()
    )
    
    coroutine.yield()
    local holds = request.result["hold"]

    local batchCommand = Command.create()

    for i, v in ipairs(holds) do
        batchCommand.add(Event.scenecontrol(v.timing, "extralane", v.timingGroup, v.lane == 0 and "0" or v.lane, v.endTiming - v.timing, 1).save())
        batchCommand.add(v.delete())
    end

    batchCommand.commit()
end)

addMacro("HideExtraLane", function ()
    local request =  EventSelectionInput.requestEvents(
        EventSelectionConstraint.create().hold()
    )
    
    coroutine.yield()
    local holds = request.result["hold"]

    local batchCommand = Command.create()

    for i, v in ipairs(holds) do
        batchCommand.add(Event.scenecontrol(v.timing, "extralane", v.timingGroup, v.lane == 0 and "0" or v.lane, v.endTiming - v.timing, "0").save())
        batchCommand.add(v.delete())
    end

    batchCommand.commit()
end)