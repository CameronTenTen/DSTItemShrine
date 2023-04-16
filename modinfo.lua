name = "Item Submission Shrine"
description = [[
Creates a prefab for players to submit items. These submissions are tracked and output to a csv file.
Intended as a generic mod for tracking items in a competitive gamemode.
Requires the companion mod (Item Submission Exporter) to function.
The organiser could run more complicated scoring systems either externally (as a spreadsheet), or in the companion mod scripts.
Shrine should be added to the world using `c_spawn("scorershrine")`.
Plan to make it part of world gen in future.
]]
author = "camerontenten"
version = "0.1"
forumthread = ""
api_version_dst = 10
all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {}

-- inputter, consumer, counter, importer, interface
-- scoreShrine, submissionshrine, itemshrine

-- Brainstorm of potential config options:
-- can the asset be configurable? so we can have a setting for which assets to use?
-- Should the shrine be added as part of world gen? next to the florid postern?
-- no build area size
configuration_options =
{
	{
		name = "ANNOUNCE_SUBMISSION",
		label = "Announcement Type",
		hover = "What kind of announcement to make when a player makes a submission",
		options =
		{
			{description = "None", data = "none"},
			{description = "Local", data = "local"},
			{description = "Global", data = "global"},
			{description = "Both", data = "both"},
		},
		default = "local"
	},
}
