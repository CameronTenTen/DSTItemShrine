# DSTItemShrine
DST Mod that adds a prefab called `scorershrine`. This is based on the pig king and allows players to submit items.  
Intended as a generic mod, the rules and results of item submission are fully configurable in the companion mod (DSTItemShrineExporter)[CameronTenTen/DSTItemShrineExporter].  
The shrine should be added to the world using `c_spawn("scorershrine")`.

This part of the mod is required on all clients, while the exporter is server only.  This allows the exporter scripts to be customised on the server without needing to share those changes to the clients.  


### Configuration
Feedback when a player submits an item can either be a server wide announcement, or a message from the shrine
Announcement Type
  - "None" = No messages
  - "Local" = Message above the shrine only
  - "Global" = Chat notification message only
  - "Both" = Both local and global

