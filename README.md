Megaprompt
==========

A heroic Zsh prompt from the year 20XX.

Screenshots
-----------

These screenshots are out of date, but I haven't wanted to bother updating them.
For example, they don't show styling in the PWD display of git repo root or mount point, and they don't reflect some of the default styles.

![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/git.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/permissions.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/jobs.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/insert.png)
![Example](https://github.com/willghatch/zsh-megaprompt/raw/master/img/normal.png)

Features
--------

- maximal information
- directory coloring based on permissions/ownership
- directory styling to show git repo roots (default bold)
- directory styling to show mount points (default reverse video)
- shows git/hg branch name if in repo
- shows current keymap indicator (I suggest replacing vi-ins with emacs, then you get the best of both worlds)
- shows exit status if non-zero
- shows number of jobs if non-zero
- shows time (useful when you want to know when you ran an old command)
- shows history number (useful for history expansion)
- shows user/host
- configure which of these are displayed
- gives up on slow commands after a configurable timeout
- a single switch to turn off all of the extra data gathering

Configuration
-------------

- <code>MEGAPROMPT_STYLES</code> is an associative array of styles to color codes or strings for different parts
- <code>MEGAPROMPT_KEYMAP_IND</code> is an associative array of keymap names to their indicators
- <code>MEGAPROMPT_PRE_FUNCTION</code> is the name of a function to call to generate a prefix to the prompt.  This allows you to add something custom before the start of the prompt.
- <code>MEGAPROMPT_DISPLAY_P</code> is an associative array of display pieces to "true" or "false"
    - <code>extra_analysis</code> do you want any of the extra data at all?  This is the master switch described under Slow Directories below.
    - <code>git_dirty</code> do you want to be informed when your git repo is dirty?  (note: this may be slow)
    - <code>git_untracked</code> do you want to be informed when your git repo is has untracked files?
    - <code>git_ahead_behind</code> do you want to be informed when your git repo ahead or behind of its tracking branch?
    - <code>git_submodule_unpushed</code> do you want a loud warning when your git repo pins (in HEAD or the index) a submodule commit that is not on any of that submodule's remotes?  Pushing the repo then would publish a commit nobody else can fetch.  (shown as `S▲` and the number of such submodules, counting nested ones, in black on red)
    - <code>git_worktrees</code> do you want to see how many worktrees your git repo has?  (shown as `W` and the count, only when there is more than one)
    - <code>time</code> do you want the time of the command? (Yes -- it's useful later when you want to know when you ran something)
    - <code>username</code> do you want to see your username? (I recommend setting it to false for your normal username, true otherwise)
    - <code>host</code> do you want to see your hostname? (I recommend setting it to false unless $SSH_CLIENT or $TMUX is set)
    - <code>tty</code> do you want to see what tty you're on?
    - <code>histnum</code> do you want to see what history number you're on? (useful for history expansion)
    - <code>hrule</code> do you want a horizontal line to go to the end of the line to visually delimit output from different commands?
    - <code>truncate</code> do you want to truncate the top line if it is longer than your terminal? (this also happens if hrule is on)
    - <code>branch_style_regex</code> do you want to match branch styles using regex (requires zsh to be compiled with PCRE support)?
    - <code>pwd_mount</code> do you want to have mount points highlighted in the directory display?
- <code>MEGAPROMPT_GIT_STYLES</code> is an an associative array of regexes to colors for git branch names

These arrays are defined at the top of the source, so just look at it to see what fields exist on the ones I haven't documented.  There are a lot of fields.

Slow Directories
----------------

Gathering all of this information means running commands (git, hg, mount, stat) that are fast in most places, but not everywhere.
A remote mount, a very large repository, or a repository with many submodules can make them slow enough to make the shell feel unresponsive.
There are two ways to deal with that.

First, each command that can be slow is given a limited amount of time to finish.
<code>MEGAPROMPT_TIMEOUTS</code> is an associative array of durations in seconds (fractions are fine), keyed by the thing being looked up (`git_branch`, `git_dirty`, `git_untracked`, `pwd_mount`, and so on -- they are listed at the top of the source).
Any key that is not set uses <code>MEGAPROMPT_TIMEOUTS[default]</code>, which is 1 second.
A duration of `0` means to wait as long as it takes, which is how the prompt behaved before timeouts existed.

When a check is given up on, its answer is unknown, so the prompt shows <code>git_timeout_mark</code> (default `T`) rather than the mark for the check itself.
A `D` means the repo is dirty; a `T` means the prompt does not know.
Likewise, if the branch name itself could not be looked up in time, <code>git_branch_unknown</code> (default `?`) is shown in place of the branch name.

The waiting is done by zsh itself, so nothing runs but the command being timed.
This needs the `zsh/system` and `zsh/datetime` modules; without them nothing is timed out.
<code>MEGAPROMPT_MISC[timeout_method]</code> is worked out at load time and is either `native` or `none`; set it to `none` yourself to turn all of the timeouts off.

`timeout(1)` is deliberately not used, even as a fallback.
It would be another process for every check, and the uutils implementation of it -- which some distributions install as `timeout` -- takes about 100ms per call no matter how quick the command is, which costs more than the slowness being avoided.

Second, when even waiting for the timeouts is too slow, `mp-extras` turns off all of the extra data gathering: git, hg, and the mount point, git root, ownership, and permission styling of the directory display.

    mp-extras          # toggle
    mp-extras off      # turn it off
    mp-extras on       # turn it back on
    mp-extras status   # just say which it is

While the extras are off, <code>extras_off_mark</code> is shown in the prompt, so that a prompt with nothing extra in it can be told apart from a directory with nothing extra to report.

Tests
-----

    zsh test/megaprompt-test.zsh

Depends
-------

You must load [zsh-hooks](https://github.com/willghatch/zsh-hooks) before this plugin.

Install
-------

I recommend using [zgen](https://github.com/tarjoilija/zgen).  Here is how to do it with zgen:

    zgen load willghatch/zsh-hooks
    zgen load willghatch/zsh-megaprompt

Otherwise, just source the .zsh files

Issues
------

- This was written primarily for zsh version 5.  With version 4.3.17
  it works fine except that the keymap indicator doesn't initialize
  properly until after the first command or keymap change.
- The hrule option (`MEGAPROMPT_DISPLAY_P[hrule]=true`) and the truncate option don't 
  work well below zsh version 5.0.7 -- they are truncated a little too early and
  therefore don't span the whole line like they are supposed to.
- The PCRE module is required for git branch coloring.  As far as I know all distributions include it.

Why
---

I have occasionally updated this prompt because I use it.
Why not use something like [Starship](https://starship.rs/) instead?
Most people will probably prefer something like Starship.
But Megaprompt predated Starship, and at the time I wrote it I didn't like any of the alternatives I saw.
Moreover, Megaprompt still has some features that I have yet to see on other prompts, such as styling the PWD display to show extra information (eg. ownership, permissions, mount points, and git repo roots).
I like these features, so I keep using (and even on rare occasions updating) this prompt.

Future Work
-----------

I would like to split my prompt into:

1. static information about the previous command, with maximal information.  This should include the date and time the process ended, its run time, exit status, etc.
2. dynamic information while composing a new command.  This section should update to, for example, show an indicator of the current input state (keymap), the current time, current git data, etc.  I'm not certain how updates should be handled -- I don't want constant updating of prompts that I won't look at for hours.  But I find it mildly grating when I go back to a shell session that has a prompt that has become out of date (eg. with respect to git status).  It should also only show information that I care about while composing a new command.
3. static information about the new command.  This should replace the dynamic information at the time that the command is run.  It likely should show much more information than the dynamic prompt.  For example, it should show the date and time that the command was run, so I can easily tell how long a program has been running.  There is a notable problem with typical prompts showing the time that you can typically tell either when a command was run, or (more likely) when the previous command finished.  I want to be able to see both of these when I look at historical data in a shell session.

Parts 1 and 3 should potentially be shown together, which either requires some duplication or fancy terminal integration (of questionable wisdom) to edit historical prompts or (possibly wiser) that has a different paradigm than just showing ANSI code output from commands.
But I find that it is not infrequent that I want more historical data when I look at shell prompts, especially when I'm coming back to a shell session that I left idle, especially one that I left on a remote machine (eg. a tmux session that I disconnected from but am coming back to, potentially days later).
