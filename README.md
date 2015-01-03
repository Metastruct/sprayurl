SprayURL - Custom Sprays from the Internet!
========
About

- SprayURL is a easy to use addon. It allows players to create a spray using an image from the internet, whitout having to create the spray. 
- Also the textures are HD, instead of that low quality spray texture. 

How to use
========

Its quite simple! Just bind a key to sprayurl 
Example : 
bind "p" "sprayurl"

To set a different texture : 
- Press C (context menu) 
- Click on SprayURL Menu 
- Grab a texture from the internet (for example :http://fc08.deviantart.net/fs71/f/2014/100/3/8/b1_in_hd_by_tomajko-d7dz8iy.png) place it on the URL box and click Set 

And your done! Your texture should work just fine. 

Commands
========

- CLIENT SIDE

sprayurl_enabled 1/0 (Enables/Disables SprayURL)

sprayurl_clearchache (Clears ALL the saved materials)

sprayurl_maxretry <number> (default 10) (Max retries to download the texture)

sprayurl_texture "texture" (note it requires "") (The Spray Texture)

- SERVER SIDE

sprayurl_plyCooldown <number> (Cooldown between sprays.) (Only Applies to Players, not Admins)

Known Issues
========

Currently its not possible to make 1 spray per player (like normal sprays)
Some Textures might not download / show (sprayurl_clearchache) will fix that problem, then just ask for him to spray again.
Spray Size is small. I haven't found a way to fix it. (sorry big images :()

This is currently in BETA. There might be other issues.