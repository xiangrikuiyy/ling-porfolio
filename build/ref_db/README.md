# Reference Database Folder
=====

Place the copy of the reference database you want to use in this folder.

In order to use a reference database, edit the build/drupal-build.sh file to reflect the appropriate setup, e.g. enable the use of reference database, the name of the refernece database file.
## Drush DB Dump
The following command assumes that you are in the root of the /www folder.

    drush sql-dump > ../build/ref_db/backup_drupal.sql

The following command will replace the current DB with whatever .sql file you choose. Good for bringing back an auto_backup_drupal.sql file.

    $(drush sql-connect) < backup.sql
     

# CHANGELOG
=====
* 2013-08-07 - Cleaned out the db of all content and users to avoid DB permission table issues during build out. - MC
* 2013-08-05 - Added admin, publisher and test accounts to the DB. - MC
* 2013-07-23 - Update Reference DB for current setup - MC
* 2013-07-19 - Initial Reference Database - JK
