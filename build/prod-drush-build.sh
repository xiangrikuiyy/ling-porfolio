#!/usr/bin/env bash

# Update these lines to use a reference database file.  If the file does not exist, the build will fail
# TODO: Should this fetch and/or use the site-install command instead?
USE_REF_DB=false
REF_DB_FILENAME='drupal.sql'

IS_DEVEL=false

# Set the drush command and base path, you sohuldn't need to worry about these values
# Pass all arguments to drush
while [ $# -gt 0 ]; do
  drush_flags="$drush_flags $1"
  shift
done

drush="drush $drush_flags"

build_path=$(dirname "$0")
ref_db_path=$build_path/ref_db/$REF_DB_FILENAME

function setup_site() {
	if $USE_REF_DB; then
		if [ -f $ref_db_path ] ; then
			# import the ref db
			$drush sqlc -y < $ref_db_path
		else
			# fail!
			echo "ERROR: The Reference database file $ref_db_path could not be found"
			exit 1
		fi
	else
		$drush si -y --account-name=root_admin --account-pass=7nw7d7@m --site-name=OARSI #minimal
	fi
}

# Take one backup of the current DB
$drush sql-dump > $build_path/ref_db/auto_backup_drupal.sql

# Run the necessary commands
# $drush sql-drop -y &&
# setup_site &&
# $drush -y updatedb &&
# $drush cache-clear all &&
$drush pm-enable $(cat $build_path/themes_enabled | tr '\n' ' ') -y &&
$drush pm-disable $(cat $build_path/themes_purge | tr '\n' ' ') -y &&
$drush pm-enable $(cat $build_path/mods_enabled | tr '\n' ' ') -y &&
$drush pm-disable $(cat $build_path/mods_purge | tr '\n' ' ') -y &&
$drush pm-uninstall $(cat $build_path/mods_purge | tr '\n' ' ') -y &&
$drush cache-clear all &&
$drush updatedb -y &&
$drush cache-clear all -y &&
$drush features-revert-all -y &&
$drush cache-clear all -y &&
$drush pm-disable overlay comment contact shortcut toolbar -y

# Run features
$drush pm-enable $(cat $build_path/mods_features_enabled | tr '\n' ' ') -y &&
$drush cache-clear all &&
$drush updatedb -y &&
$drush cache-clear all -y &&
$drush features-revert-all -y &&
$drush cache-clear all -y

# Import menus
$drush mf-import

# Force these 2 features to revert as they enforce certain menu items Post Feature Revert
$drush features-revert --force ah_mega_menu -y &&
$drush features-revert --force site_skeleton -y &&
$drush cache-clear all -y &&
$drush updatedb -y &&
$drush cache-clear all -y

# Run features
$drush pm-enable roles_and_permissions -y &&
$drush cache-clear all &&
$drush updatedb -y &&
$drush cache-clear all -y &&
$drush features-revert-all -y &&
$drush cache-clear all -y

# If the site is in development, we should generate some content
if $IS_DEVEL; then
	# Generate promotion content
	$drush generate-content 5 0 --types=promotion --kill
	# Generate event content
	$drush generate-content 5 0 --types=event --kill

	# Generate Sponsor levels before sponsors
	$drush generate-terms sponsor_levels 4 --kill
	# Generate sponsor content
	$drush generate-content 20 0 --types=sponsor --kill
	# Generate Library Entry content
	# $drush generate-content 10 0 --types=library_entry --kill
fi

#$drush sql-drop -y &&
#$drush sqlc < $build_path/ref_db/slaughterhouse/drupal.sql -y &&
#rm -rf /var/drupals/loggia/www/sites/loggia.dev/files &&
#tar -zxvf $build_path/ref_db/slaughterhouse/files.tar.gz -C /var/drupals/loggia/www/sites/loggia.dev/ &&
#$drush updatedb -y &&
#$drush cc all -y &&
#$drush en $(cat $build_path/mods_enabled | tr '\n' ' ') -y &&
#$drush dis $(cat $build_path/mods_purge | tr '\n' ' ') -y &&
#$drush pm-uninstall $(cat $build_path/mods_purge | tr '\n' ' ') -y &&
#$drush cc all &&
#$drush updatedb -y &&
#$drush cc all -y &&
#$drush fra -y &&
#$drush cc all -y &&
#$drush dis comment shortcut overlay toolbar -y &&
#$drush fr -y --force commons_main_menu &&
#$drush cc menu &&

#$drush scr $build_path/script/set_theme.php &&
#$drush scr $build_path/script/feeds_import.php

#$drush cron
#wget -O ../distro.make https://raw.github.com/MrMaksimize/Drupal-BoilerPlate/base/distro.make &&
#mv sites ../ &&
#rm -rf * &&
#$drush make --no-cache ../distro.make . &&
#rm -rf sites &&
#mv ../sites . &&
#mkdir sites/all &&
#mkdir sites/all/modules &&
#mkdir sites/all/themes &&
#$drush si -y --account-pass='drupaladm1n' drupalbp


#rm -rf * &&
#$drush make --no-cache ../distro.make . &&
#$drush si -y --account-pass='drupaladm1n' drupalbp
