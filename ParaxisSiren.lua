-- Copyright (C) 2017  Walter Kuppens
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local PARAXIS_DEBUFF = "Paraxis Incoming"
local UPDATE_INTERVAL = 10.0
local warningActive = false

-- Calls ParaxisSirenDebuffHandler every 10 seconds while the Paraxis is in
-- view.
function ParaxisSirenUpdate(self, elapsed)
    if warningActive then
        self.lastUpdate = self.lastUpdate + elapsed
    else
        self.lastUpdate = 0
    end

    if self.lastUpdate > UPDATE_INTERVAL then
        self.lastUpdate = 0
        ParaxisSirenDebuffHandler()
    end
end

-- Filters out irrelevant aura events and calls ParaxisSirenDebuffDetected
-- whenever a debuff event relevant to the player is detected.
function ParaxisSirenEventDispatcher(self, event, arg1)
    if event == "UNIT_AURA" and arg1 == "player" then
        ParaxisSirenDebuffDetected(arg1)
    end
end

-- Toggles the state of the warningActive global when depending on the state of
-- the Paraxis debuff. This function will also play the sound immediately when
-- toggled for the first time.
function ParaxisSirenDebuffDetected(unitID)
    local debuff = UnitDebuff(unitID, PARAXIS_DEBUFF)
    if debuff == PARAXIS_DEBUFF then
        -- Start the sound ASAP, the timer should trigger for the first time
        -- just as the first sound ends.
        if not warningActive then
            ParaxisSirenDebuffHandler()
        end

        warningActive = true
    else
        warningActive = false
    end
end

-- Plays an air raid siren sound ideally when the Paraxis is in view.
function ParaxisSirenDebuffHandler()
    PlaySoundFile("Interface\\AddOns\\ParaxisSiren\\Media\\Sound\\siren.ogg", "Master")
end
