I like to run the RStudio dailies since Kevin Ushey is always adding good stuff 
(and it's super-easy to use a stable version if the daily is wobbly). 

Rename `rsupd.bash` to just `rsupd` (I wanted it to render nicely in the gist so I had to put 
an extension on it) then put the `rsupd` script into `/usr/local/bin` and (from a command prompt) do `chmod 755 /usr/local/bin/rsupd`

Now, copy the `is.rud.UpdateRStudio.plist` to  `~/Library/LaunchAgents` if you want the update to happen automatically. Change the hour/minute if 0730 AM doesn't work for you for some reason. Then use: `launchctl load -w ~/Library/LaunchAgents/is.rud.UpdateRStudio.plist` to load it (use `unload` vs `load` to, well, _unload_ it).

If you want to run it by hand, just enter `rsupd` as a command prompt.

As stated in the `rsupd.bash` script, it requires external utilities, so read the comments and ensure you've done that, otherwise the script won't work!