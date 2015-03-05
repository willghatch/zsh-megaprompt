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

- <code>MEGAPROMPT_STYLES</code> is an associative array of styles to color codes for different parts
- <code>MEGAPROMPT_KEYMAP_IND</code> is an associative array of keymap names to their indicators
- <code>MEGAPROMPT_DISPLAY_P</code> is an associative array of display pieces to "true" or "false"
    - <code>git_dirty</code> do you want to be informed when your git repo is dirty?  (note: this may be slow)
    - <code>git_ahead_behind</code> do you want to be informed when your git repo ahead or behind of its tracking branch?
    - <code>time</code> do you want the time of the command? (Yes -- it's useful later when you want to know when you ran something)
    - <code>username</code> do you want to see your username? (I recommend setting it to false for your normal username, true otherwise)
    - <code>host</code> do you want to see your hostname? (I recommend setting it to false unless $SSH_CLIENT or $TMUX is set)
    - <code>tty</code> do you want to see what tty you're on?
    - <code>tty</code> do you want to see what tty you're on?
- <code>MEGAPROMPT_GIT_STYLES</code> is an an associative array of regexes to colors for git branch names

These arrays are defined at the top of the source, so just look at it to see what fields exist on the ones I haven't documented.  There are a lot of fields.

Screenshots
-----------

These screenshots are out of date, but I haven't wanted to bother updating them.
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/git.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/permissions.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/jobs.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/insert.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/normal.png)

Issues
------

This was written primarily for zsh version 5.  With version 4.3.17 (currently in
debian stable) it works fine except that the keymap indicator doesn't initialize
properly until after the first command or keymap change.

The PCRE module is required for git branch coloring.  As far as I know all distributions include it.

