
state("mesen", "v0.9.9") 
{
    byte level:         "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x012;
    byte start:         "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x3B5;
    byte start2:        "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x3B6;
    byte complete:      "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x033;
    byte pauseComplete: "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x0EB;
    byte BikeGlitch:    "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x650;
    byte BikeGlitch2:   "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x318;
    uint screen:        "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x052;
    uint warpScreen:    "Mesenore.dll", 0x42E0F30, 0xB8, 0x58, 0x06;
}

startup
{
    settings.Add("gLevels", true, "Levels");erfdsf
    settings.Add("gWarps", true, "Warps");

    settings.Add("lvl1", true, "Ragnarok's Canyon", "gLevels");
    settings.Add("lvl2", true, "Wookie Hole", "gLevels");
    settings.Add("lvl3", true, "Turbo Tunnel", "gLevels");
    settings.Add("lvl4", ue, "Arctic Caverns", "gLevels");
    settings.Add("lvl5", true, "Surf City", "gLevels");
    settings.Add("lvl6", true, "Karnath's Lair", "gLevels");
    settings.Add("lvl7", true, "Volkmire's Inferno", "gLevels");
    settings.Add("lvl8", true, "Intruder Excluder", "gLevels");
    settings.Add("lvl9", true, "Terra Tubes", "gLevels");
    settings.Add("lvl10", true, "Rat Race", "gLevels");
    settings.Add("lvl11", true, "Clinger Winger", "gLevels");
    settings.Add("lvl12", true, "The Revolution", "gLevels");
    settings.Add("lvl13", true, "Armageddon", "gLevels");

    settings.Add("warp1", true, "Warp in Level 1", "gWarps");
    settings.Add("warp2", true, "Glitch in Turbo Tunnel", "gWarps");
    settings.Add("warp3", true, "Warp in Level 3", "gWarps");
    settings.Add("warp4", true, "Warp in Level 4", "gWarps");
    settings.Add("warp6", true, "Warp in Level 6", "gWarps");
    settings.Add("warp10", true, "Warp in Level 10", "gWarps");
}

init
{
    // Detect FCEUX version

    var module = modules.SingleOrDefault(x => String.Equals(x.ModuleName, "fceux.exe", StringComparison.OrdinalIgnoreCase));

    if (module != null)
    {
        switch (module.ModuleMemorySize)
        {
            case 4579328:
                version = "v2.2.2";
                return;
            case 4747264:
                version = "v2.2.3";
                return;
            case 5877760:
                version = "v2.3.0";
                return;
        }
    }

    // Detect Mesen version

    module = modules.SingleOrDefault(x => String.Equals(x.ModuleName, "mesen.exe", StringComparison.OrdinalIgnoreCase));

    if (module != null)
    {
        switch (module.ModuleMemorySize)
        {
            case 10067968:
                version = "v0.9.7";
                return;
            case 11714560:
                version = "v0.9.9";
                return;
        }
    }
}

split
{
    if ((old.complete != 0x81) && (current.complete == 0x81) && ((current.pauseComplete & 0xFE) == 0x80))
    {
        switch ((int)current.level)
        {
            case 1:
                if (settings["lvl1"])
                    return true;
                break;
            case 2:
                if (settings["lvl2"])
                    return true;
                break;
            case 3:
                if (settings["lvl3"])
                    return true;
                break;
            case 4:
                if (settings["lvl4"])
                    return true;
                break;
            case 5:
                if (settings["lvl12"])
                    return true;
                break;
            case 6:
                if (settings["lvl7"])
                    return true;
                break;
            case 7:
                if (settings["lvl8"])
                    return true;
                break;
            case 8:
                if (settings["lvl6"])
                    return true;
                break;
            case 9:
                if (settings["lvl10"])
                    return true;
                break;
            case 10:
                if (settings["lvl11"])
                    return true;
                break;
            case 11:
                if (settings["lvl9"])
                    return true;
                break;
            case 12:
                if (settings["lvl5"])
                    return true;
                break;
        }
    }

    if ((current.BikeGlitch == 0x0F) && (old.BikeGlitch2 != 0x93) && (current.BikeGlitch2 == 0x93))
    {
        switch ((int)current.level)
        {
            // Bike Glitch
            case 3:
                if (settings["warp2"])
                    return true;
                break;

            // The Revolution
            case 5:
                if (settings["lvl12"])
                    return true;
                break;
        }
    }

    // Armageddon (end game)
    if ((old.screen == 0x0F241404) && (current.screen == 0x0F201C0C) && ((current.level & 0xFE) == 0xFE) && (settings["lvl13"]))
        return true;

    // Warps
    if (((old.warpScreen != 0x0F382205) && (current.warpScreen == 0x0F382205)) || ((old.warpScreen != 0x0F121620) && (current.warpScreen == 0x0F121620)))
    {
        switch ((int)current.level)
        {
            case 1:
                if (settings["warp1"])
                    return true;
                break;
            case 3:
                if (settings["warp3"])
                    return true;
                break;
            case 4:
                if (settings["warp4"])
                    return true;
                break;
            case 8:
                if (settings["warp6"])
                    return true;
                break;
            case 9:
                if (settings["warp10"])
                    return true;
                break;
        }
    }
}

reset
{
    return ((old.level != 0x00) && (current.level == 0x00));
}

start
{
    return (current.level == 0x01) && (((old.start == 0x05) && (current.start == 0x04)) ||
        ((old.start2 == 0x05) && (current.start2 == 0x04)));
}
