# WRONG BIN!
## Video Demo:   [Here](https://www.youtube.com/watch?v=oi8hz2pyX1s&ab_channel=TrustyTea)

# Short Description:

This project is a mini-game that concists of you, a trash bin who doesn't want to pick up trash anymore, and falling pieces of trash.
These pieces of trash increase in speed as time goes on, and they will multiply as time goes on as well, making it harder and harder to survive.

# Inception
When I started thinking of what kind of game I wanted to create, I knew I wanted to try something that would:
1. Get Harder as time passed
2. Have score based upon how long the player could survive for
3. Have the player's movement decide the pace of the game

With this in mind, I initially thought of a game where the player was on top a platform and they had to fight the wind from pushing them off. There would be obstacles that would fly down from above that would interrupt the player and try and cause them to fall. I started to build the system where objects would spawn every few seconds and as I was talking it over with my dad, he mentioned an idea that I really liked. He mentioned the Star Wars scene where they are in the trash compactor and they had to escape last second, he said it would be cool to have the window shrink overtime to the point where you wouldn't be able to do anything, and the only way to escape would be to collect a few 'key' objects to move onto the next level. I really enjoyed this idea so I tried to go for it.

# Problems Arise
I was really on board with the idea and I really wanted to make it work! I thought it was something I had never seen before and it would have been a fun game to play. While reading documentation and trying multiple different functions, there didn't seem to be a viable way that I could shrink the actual size of the window without a negative side effect. I would use `love.graphics.setScissor()`, but this seemed to only shrink the visible play space, and not the window, causing a weird right side of the screen to seem laggy which was unintended and needed to be fixed. I then decided to try `love.window.setMode`, changing the width of the screen each time an object was spawned. This seemed to work, only the screen would destory itself, and then re-create itself with the smaller screen size each time a new object spawned. This was obviously not intended, and through a while of researching, I felt that it would be impossible to do what I wanted so I thought of a different idea.

# A New Idea
I wanted to keep to the theme of falling trash, so I thought about an old iPhone game I used to play where the object of the game was to fling pieces of paper into a bin from various angles and distances in an office. I thought that it was a very simple enough game to recreate, but I wanted to reverse the role and make it so you wanted to avoid the trash instead of picking it up. I turned the player into a trash bin, changed the background image to that of an office, and the falling trash to pieces of crumpled paper.

# Game Mechanics
I knew that normally, players would think to catch the papers, but I wanted to do something a little different so I made the trash bin one that doesn't want to pick up paper. I ran into problems with the overall feel of the game as I play tested throughout development. I noticed that it was VERY easy to play so I decided to decrease the spawning interval each time objects were spawned. I ended up doing my math wrong the first time and within 10 seconds of the game, there would be 100s of trash falling from the sky, it was pretty funny to watch my family's reaction to that. Once I got the spawn rate fixed, I also noticed that because I was adding a vertical motion to the paper, most times, they would just fly off the screen. I ended up making it so that the paper would bounce off the screen once they hit the edge of the screen, making it a little more chaotic for the player. I ended up doing a simmilar thing to the player, making sure that they were limited to the screen and couldn't move out of bounds, at one point you were able to stand outside the window and let all the paper bounce around and you could get very high scores. 3 Lives were given so that you could make a few mistakes or account for some crazy snipes from the papers. I don't think I have balancing to 100%, but I enjoy trying to beat my high score each time.