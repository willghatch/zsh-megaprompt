Depends
-------

You must load [zsh-hooks](https://github.com/willghatch/zsh-hooks) before this plugin.

Install
-------

I recommend using [zgen](https://github.com/tarjoilija/zgen).  Here is how to do it with zgen:

    zgen load willghatch/zsh-hooks
    zgen load willghatch/zsh-megaprompt

Otherwise, just source the .zsh files

Features
--------

- Maximal information
- Directory coloring based on permissions/ownership
- shows git/hg branch if in repo
- shows current keymap indicator (I suggest replacing vi-ins with emacs, then you get the best of both worlds)
- shows exit status if non-zero
- shows number of jobs if non-zero
- shows time (useful when you want to know when you ran an old command)
- shows history number (useful for history expansion)
- shows user/host
- configure which of these are displayed

Configuration
-------------

- <code>MEGAPROMPT_STYLES</code> is an array for color codes for different parts
- <code>MEGAPROMPT_KEYMAP_IND</code> is an array of keymap indicators
- <code>MEGAPROMPT_DISPLAY_P</code> is an array containing true or false - determines what pieces are displayed

There are a lot of elements... they're at the top of the source, so just look at it.

Screenshots
-----------

![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/git.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/permissions.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/jobs.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/insert.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/normal.png)

Recommendations
---------------

If you usually use the same username, consider setting `MEGAPROMPT_DISPLAY_P[username]=false` when you are that user -- it will make it stand out when you DO have a different username.  Similarly, consider displaying the host only if `$SSH_CLIENT` is set, to make terminals with remote connections stand out (Note: if you use screen or tmux, you might also turn hostname on while using them).

Issues
------

This was written primarily for zsh version 5.  With version 4.3.17 (currently in
debian stable) it works fine except that the keymap indicator doesn't initialize
properly until after the first command or keymap change.

Roadmap
-------

I want to put in an option to get more git status info, and any other useful information I can think of.  I haven't yet because the computer I use the most gives me git status slowly due to NFS delays.
