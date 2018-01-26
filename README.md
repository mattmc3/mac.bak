# mac.bak Bash rsync backup utility to grab files off my Mac

## What is it?

Mac.bak is a way to backup your Mac via copying settings files
from various places on your Mac where apps store their configs.

This project is simply a tiny bash script that leverages
rsync's `--incude-from` switch, and also runs custom `backup.sh` scripts for
backups that aren't simply file copies.

The application instructions for backups started as modified .cfg files from
the excellent [Mackup][1] project. Mac.bak doesn't need mackup, but its apps
dir contains include-from.rsync files generated from that project.

Mac.bak runs an rsync command against your Mac's `$HOME` to backup whatever
files were specified in the apps directory. That's it. Dirt simple, and no
messy symlinking. No installation necessary.

No other part of Mackup is used except its configs. You can still use Mackup
too if you want to, but Mac.bak only borrows the file locations from the Mackup
project's configs, not any of the code.

To get started, have a look at the bash script file named `mac.bak.sh` - the
code is well commented.

## Why

Many other backup products work by makeng symlinks of files from your system
some other location (like Dropbox) for an easy cloud-sync of your important Mac
files. While this may work well for some, symlinking all your files has some
drawbacks.

- Some apps don't take too well to symlinks
- If you delete a file, you have to rely on Dropbox or whatever you synced to
  to recover it.
- Since your backed up files have to be symlinked, it's awkward for other
  symlinking strategies employed elsewhere (ie: dotfiles)
- Symlinking isn't so much a backup as it is a cloud-sync strategy. If you have
  to go back in time to get an older file version, you have to rely on Dropbox
  or git.
- Not all files on every system should be the exact same. Symlinking across
  machines forces that conformity.

Mac.bak instead is a classic file copy based backup.

## How it works

Rsync is a powerful tool, but surprisingly underutilized for Mac backups.
Mac.bak leverages the excellent work of Mackup contributors and the power of
`rsync` to make an easy way to take backups of your important Mac files. Using
only a small handful of lines of bash scripting, Mac.bak leverages a curated
list of files and directories to make a file that rsync can use to backup your
system. See the [man page for rsync][2] for
more info.

Files are backed up to a location you specify when calling the script.

## Storing your backup

Mac.bak just gets you a current backup. Getting it offsite is your
responsiblity. Having point-in-time recoverability is your responsibility.
Dropbox or a private git repo are great solutions for this.

I recommend running a cron job to take a regular backup and check it into git
automatically.

## Customizing

Mac.bak provides a custom directory where you can add your own .txt files in
the same format rsync supports. Feel free to add your own customizations.

## Restoring to a new system

Mac.bak leverages the power of rsync. Restores are as easy as rsync-ing the
other direction.

Running this command will show you what will be restored `rsync -acv --dry-run
"$BACKUP_DIR/" "$HOME/"`

Once you are sure you are ready, remove `--dry-run`. Note that the trailing
slashes are important to rsync.

`rsync -acv "$BACKUP_DIR/" "$HOME/"`

Mac.bak doesn't run restores, because it doesn't need to. Everything is ready
for you to `rsync` restore however you see fit. All you have to do is get your
backup files snapshotted to your new machine and run the restore.

## What if I want this script to do things differently

Fork me on github!

## Caveat Emptor - WARNINGs and notes

Some things to note:

- Remember, your config files may contain PRIVATE information. Be careful
  where / how you store them. Mac.bak doesn't use cloud storage, but in order
  to have a backup you will probably chose to sync the backups from Mac.bak.
  Choose wisely.
- Don't run random scripts you got off the internet without reading them!
  Verify that this script does what you expect, that it is taking a thorough
  backup of all the files you expect, and be sure that it runs frequently
  before you rely on it for your backups.
- The rsync command in Mac.bak does use the `--delete-excluded` option of rsync
  by default, which means that missing files from your Mac will be removed from
  your backup directory. That may be what you want. It may not.
- The .cfg format for Mackup could change since we don't control that. If that
  happens, open an issue or submit a PR so the `sed/awk` processing done by
  Mac.bak can be modified to support other scenarios. If things go too haywire,
  Mac.bak may start maintaining its own configs. If that happens, they will
  just be in the rsync format.
- Remember, Mac.bak only keeps a current copy of your files. If you want
  history, I recommend checking your configs into a private git repo.
- Remember Mac.bak is not a real time backup. I recommend adding a regular run
  of Mac.bak to your crontab or when you log in.

## TODOs

- [x] Provide `--dry-run` option to Mac.bak script
- [x] Provide option to enable `--delete-excluded` option to Mac.bak script
- [ ] Add a cron/.bash_profile helper script for automating git backups

## Attribution

Mackup is a great project, and many props to
[Laurent Raufaste][3] for all his work on it. I and many
others prefer something different for Mac backups, but that doesn't diminish
the great work done on that project.

## License

Since this project leverages mackup ever so slightly, I want to abide
by the terms of the Mackup licence, which is GPL 3.0. This software is
distributed without warrenty of any kind. See LICENSE for details.

[1]: https://github.com/lra/mackup
[2]: https://linux.die.net/man/1/rsync
[3]: https://github.com/lra
