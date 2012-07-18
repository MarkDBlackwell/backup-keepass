=begin
Author:            Mark D. Blackwell.
Author's email:    markdblackwell01 AT gmail.com.
Change dates:
(mdb) March 5, 2011 - written
(mdb) March 10, 2011 - some change
(mdb) September 14, 2011 - allow 'open' of extension, '.rb' by editor, not Ruby interpreter
(mdb) July 18, 2012 - use Ruby in PATH

Program name:      Back Up KeePass.
Usage:             Runs on boot.
Applies to:        Users of KeePass Password Safe, who also use Dropbox on Microsoft Windows.
Justification:     Can give you more protection from Dropbox losing or altering your passwords.
Function summary:  At boot, copies a KeePass database to another (time-stamped) file name.

Background:
  Dropbox can be used to access your latest password changes while you are on other computers.
  In other words, it can keep a KeePass Password Safe database up to date.
  It does this between computers, automatically synchronizing the contents of a Dropbox folder.
  But, synchronization might be dangerous! You might lose your latest changes, or even your whole password database.

Requirements:
  o. Microsoft Windows.
  o. Ruby language.
  o. Your Dropbox location is "%USERPROFILE%\My Documents\Dropbox" (right under your My Documents folder as usual).

Setup instructions:
  1. Copy your KeePass database to another (backup) location.
  2. In "My Documents\Dropbox", make a folder called, "KeePass". (In full, "%USERPROFILE%\My Documents\Dropbox\KeePass".)
  3. Move your KeePass database to the folder.
  4. Copy the shortcut, "backup-keepass" from this program's installation directory to your Windows startup folder.
  5. Under tab, "Shortcut" of its properties, "Start in" should contain "%USERPROFILE%\My Documents".
  6. Click the new shortcut.
  7. Verify that now a currently-timestamped copy (with the right length) of your database exists in the folder, "%USERPROFILE%\My Documents\KeePass-backups".
  8. In KeePass, browse for your database at the new location.
  9. Every time you think of it later, delete all but the latest timestamped copy.

References:
  Dropbox - http://www.dropbox.com/
  KeePass - http://keepass.info/
  Ruby in PATH - http://stackoverflow.com/a/3556589/1136063
=end

require 'pathname'

WORKING=Pathname Dir.pwd
DATABASE='Database.kdb'
T=Time.now
CHANGING=sprintf '%04d-'+'%02d-'*2+'%02d.'*3, T.year, T.month, T.day, T.hour, T.min,
    T.sec
READ_ONLY,WRITE_ONLY = %w[r w]
FROM,TO=[READ_ONLY,WRITE_ONLY].zip(
    ['',CHANGING],
    [ %w[  Dropbox  KeePass  ],  %w[ KeePass-backups  ] ]
    ).map{|mode,prefix,nodes|
    File.new WORKING.join(*nodes).realpath.join(prefix + DATABASE), mode + 'b'}
print "#{TO.write FROM.read} bytes copied.\n"
sleep 5 # Keep the message visible for a UX-reasonable time.
