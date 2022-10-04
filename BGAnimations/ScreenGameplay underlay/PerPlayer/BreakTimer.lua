local player = ...
local pn = ToEnumShortString(player)

if ECS.Mode ~= "ECS" and ECS.Mode ~= "Speed" then return end

local PlayerState = GAMESTATE:GetPlayerState(player)
local streams = GetStreamSequences(SL[pn].Streams.NotesPerMeasure, 16)
local streamIndex = 1
local prevMeasure = -1

local start_time = GetTimeSinceStart()
local stream_time = ECS.Mode == "Speed" and 8 or 15

-- Returns whether or not we've reached the end of this stream segment.
local IsEndOfStream = function(currMeasure, Measures, streamIndex)
	if Measures[streamIndex] == nil then return false end

	-- a "segment" can be either stream or rest
	local segmentStart = Measures[streamIndex].streamStart
	local segmentEnd   = Measures[streamIndex].streamEnd

	local currStreamLength = segmentEnd - segmentStart
	local currCount = math.floor(currMeasure - segmentStart) + 1

	return currCount > currStreamLength
end


local Update = function(self, delta)
  local currMeasure = (math.floor(PlayerState:GetSongPosition():GetSongBeatVisible()))/4
  if currMeasure > prevMeasure then
    prevMeasure = currMeasure

    if IsEndOfStream(currMeasure, streams, streamIndex) then
			streamIndex = streamIndex + 1
		end
  end

  -- We are in a stream
  if not streams[streamIndex].isBreak and stream_time > 0 then
    stream_time = math.max(0, stream_time - delta)
  end
end

return Def.ActorFrame{
  InitCommand=function(self)
		self:queuecommand("SetUpdate")
	end,
	SetUpdateCommand=function(self) self:SetUpdateFunction( Update ) end,
  ScreenChangedMessageCommand=function(self)
    ECS.RemainingTimeSpentInStreams = stream_time
  end
}