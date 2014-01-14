OARSI
=====

The 2013 redesign of the OARSI website. The first AH site built using Vagrant.

###Plugins Needed
*  Berkshelf
*  Omnibus

Install using:
*  vagrant plugin install vagrant-berkshelf
*  vagrant plugin install vagrant-omnibus

## Menu Import
Maksim created a helper module/feature called "menu_feature" which adds a drush command for creating a txt file full of the menu paths. In order for the menu to be included, add the menu in question to the list of menus ($menu_files) within the menu_feature_menus() function. Located on line 10 of the menu_feature.module file.

To create/rewrite the exported menu files the drush command must be run from the command line. The following drush commands are being added by the menu_feature feature.
* mf-export = Exports the menus listed in the menu_feature.module to txt files within the root of the feature directory.
* mf-import = This does the opposite and imports the same listed menus.
 * This command is already being triggered from the build script.

## Setup Elysia Cron on Vagrant
Setting cron instructions. Elysia Cron must be instaled and running for this to work.
* On command line: crontab -e
* Check to not duplicate then paste the appropriate line from below at the end of the file.
 * \* \* \* \* \* wget -O - -q -t 1 http://oarsi.dev/sites/all/modules/contrib/elysia_cron/cron.php?cron_key=cD3dZ-hS14c0f-jt9L4JmKLRD4uu7NGTqX_eTC300Qo
 * \* \* \* \* \* wget -O - -q -t 1 http://oarsi.stage.org/sites/all/modules/contrib/elysia_cron/cron.php?cron_key=cD3dZ-hS14c0f-jt9L4JmKLRD4uu7NGTqX_eTC300Qo
 * \* \* \* \* \* wget -O - -q -t 1 http://oarsi.org/sites/all/modules/contrib/elysia_cron/cron.php?cron_key=cD3dZ-hS14c0f-jt9L4JmKLRD4uu7NGTqX_eTC300Qo
* Pressing control + x then enter y to save and press enter.

## VPN Setup
Here are the instructions for setting up the vpn on Debian Squeeze. 
- Install Cisco VPN client with the following command "apt-get install vpnc" 
- Create a config file in /etc/vpnc. Name it appropriately according to the connection. For example, "ah-vpn.conf". Here are the contents:
	IPSec gateway 66.117.60.133
	IPSec ID AH-tg
	IKE Authmode psk
	IPSec secret emotbo33
	Xauth username <your_username>
	Xauth password <your_password>
- Test: To connect, use the command "vpnc ah-vpn", where ah-vpn is the name of your config file. To disconnect, the command is "vpnc-disconnect" 
- Test: SSH to the internal address. For example the stage server SSI supports is 10.89.0.6 and Prod is 10.89.0.5

# CHANGELOG
=====
* 2013-11-21 - Updated Editorial tools to use custom workbench views instead of default views. Run update.php to see changes. -MC
* 2013-11-14 - Updated Hansel export in www/build/hansel_export
* 2013-11-12 - Add hansel current export of settings in www/build/hansel_export
 * Admin hansel from /admin/config/search/hansel
 * Rules can be imported into /admin/config/search/hansel/import
* 2013-11-12 - Applied patched per instructions from the securepages module. - MC
 * drupal-https-only-961508-23-32.patch
 * 471970_0.patch
 * This module is not intended for local development so it's not in the mods_enabled file. The server admin must enable it and add $conf['https'] = TRUE; to the settings.php file.
* 2013-11-11 - Updated theme menu.inc to alter login link within global menu to change based on the user. The initial login link must already exists. - MC
* 2013-10-18 - Change the vagrant IP and URL - MC
 * Now you must use URL dev.oarsi.org on IP 172.16.10.27
* 2013-10-18 - Updated the JS script in the contrib module external_iframe. - MC
* 2013-10-14 - Added Elysia Cron instructions
* 2013-08-14 - Added the Drupal 7 version of our sponsor slider. Custom flexslider functions were rewritten within the feature to handle the 4 logos per slide output. - MC
* 2013-08-07 - Changed the build script so that features are only installed after all other regular modules have been installed. - MC
* 2013-08-05 - Updated ref db. - MC
* 2013-08-01 - Added patch for workbench_moderation module to enable features access
 * Note if new fields are added to the Workbench Moderation States or Transsitions  lists the field also be added to the feature before it will be included in a feature update.
* 2013-07-31 - Updated the drupal.sql file on Dropbox - MC
 * The db from yesterday resulted in an error during the build script.
* 2013-07-30 - Updated the drupal.sql file on Dropbox - MC
* 2013-07-30 - Added "IS_DEVEL" to the build script. If this is set to true, drush will genaerat content from the new "devel_generate_content" file. - MC
 * To add more auto-generate content to the "devel_generate_content" file, add the following where "TYPE" is the machine name of the content type: 5 0 --types=TYPE --kill
  * 5 = Number of nodes to generate.
  * 0 = Maximum number of comments to generate.
  * --types= A comma delimited list of content types to create. Defaults to page,article.
  * --kill = Delete all content before generating new content.
