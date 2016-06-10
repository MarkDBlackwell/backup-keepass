=begin
Author:            Mark D. Blackwell.
Author's email:    markdblackwell01 AT gmail.com.
Change dates:
(mdb) March 5, 2011 - written
(mdb) March 10, 2011 - some change
(mdb) September 14, 2011 - allow 'open' of extension, '.rb' by editor, not Ruby interpreter
(mdb) July 18, 2012 - use Ruby in PATH
(mdb) June 9, 2016 - refactor; short wait, so bootup can complete

Program name:      Back Up KeePass.
Usage:             Runs on boot.
Applies to:        Users of KeePass Password Safe, who also use Dropbox on Microsoft Windows.
Justification:     Can give you more protection from Dropbox losing or altering your passwords.
Function summary:  At boot, copies a KeePass database to another (time-stamped) file name.

Background:
  Something like Dropbox can be used to access your latest password changes while you are on other computers.
  In other words, it can keep a KeePass Password Safe database up to date.
  It does this between computers, automatically synchronizing the contents of a Dropbox folder.
  But, synchronization might be dangerous!
  You might lose your latest changes, or even conceivably your whole password database.

Requirements:
  o. Microsoft Windows.
  o. Ruby language is installed.
  o. Your Dropbox location is "%USERPROFILE%\My Documents\Dropbox" (right under your My Documents folder, as usual).

Setup instructions:
  1. First (for safety), copy your KeePass database to some other (backup) location.
  2. In "My Documents\Dropbox", make a folder called, "KeePass". (In full, "%USERPROFILE%\My Documents\Dropbox\KeePass".)
  3. Move your KeePass database to the folder.
  4. Copy the shortcut, "backup-keepass" from this program's installation directory to anywhere in your Windows startup folder.
  5. Under tab, "Shortcut" of its properties, "Start in" should contain "%USERPROFILE%\My Documents".
  6. Click the new shortcut.
  7. Verify that a currently-timestamped copy (with the right, same length) of your database exists now in the folder, "%USERPROFILE%\My Documents\KeePass-backups".
  8. In KeePass, browse for your database at the new location (once, assuming you've set Keepass' option to remember the database location).
  9. Every time you think of it later, delete all but the latest timestamped copy.

References:
  Dropbox - http://www.dropbox.com/
  KeePass - http://keepass.info/
  Ruby in PATH - http://stackoverflow.com/a/3556589/1136063
=end

require 'pathname'

EMPTY = String.new.freeze
SHORT_WAIT         =          5   * 60 # Seconds.
SHORT_WAIT_SECONDS = SHORT_WAIT   % 60 
SECONDS_PHRASE = 0 == SHORT_WAIT_SECONDS ? EMPTY : " #{SHORT_WAIT_SECONDS} seconds"
SHORT_WAIT_MINUTES = SHORT_WAIT.div 60
SHORT_WAIT_STRING = "#{SHORT_WAIT_MINUTES} minutes#{SECONDS_PHRASE}"
BOOTUP_MESSAGE = \
    "Waiting #{SHORT_WAIT_STRING} for:" \
    " bootup," \
    " Internet access," \
    " (something like) Dropbox to fetch a (possibly-)updated Keepass database," \
    " etc. ...\n"
::Kernel.print BOOTUP_MESSAGE
::Kernel.sleep SHORT_WAIT

DATABASE = 'Database.kdb'
WORKING  = ::Pathname.new ::Dir.pwd
T = ::Time.now
CHANGING = ::Kernel.sprintf '%04d-' + '%02d-'*2 + '%02d.'*3,
    T.year, T.month, T.day, T.hour, T.min, T.sec
READ_ONLY, WRITE_ONLY = %w[r w]

FROM, TO =
    [ %w[  Dropbox  KeePass  ],  %w[ KeePass-backups  ] ].zip(
    [   READ_ONLY,                 WRITE_ONLY           ],
    [   EMPTY,                     CHANGING             ]).
    map do |nodes, mode, prefix|
  path = WORKING.join(*nodes).realpath.join prefix + DATABASE
  ::File.new path, mode + 'b'
end

# Use methods of File's parent class, IO:
BYTES = TO.write FROM.read
::Kernel.print "#{BYTES} bytes copied.\n"

[FROM, TO].each{|e| e.close}

VISIBLE_RESULTS_MESSAGE = 'Keeping the results visible for a UX-reasonable time.'
::Kernel.print VISIBLE_RESULTS_MESSAGE

VISIBLE_RESULTS_WAIT = 1 * 60 # Seconds.
::Kernel.sleep VISIBLE_RESULTS_WAIT
