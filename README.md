mt-plugin-photocontest
======================

This plugin allows you to run a photo contest on an MT blog with public photo submissions enabled.

Installation & setup:
---------------------
* Install the plugin by copying the PhotoContest folder into the /plugins folder of the MT installation
* Log in to MT and let the installer run
* Create two new custom fields (see the images in the documentation folder).  Make sure the basename is exactly as shown.
* In the 'Create Entry' template module, add following line just before the 'Kopf' include:

  &lt;mt:include module="Photo Contest Form Javascript">
  
* Republish the 'Create Entry' template

Optional step to give each author a starting amount of photos to submit before the 1st of the month:
* Copy the taskmaster script from the 'tools' folder into the 'tools' folder of the MT installation
* Edit Plugin.pm and temporarily comment out the line

	if (($dayOfMonth == "1") && ($hour < 2)){
	
	and the } that closes the block.

* Run following command from inside the MT home directory (it takes a while to complete):

 tools/task-master forcerun reset_available_contestphotos

* Don't forget to uncomment the line again after that.

Usage:
-------
* The photo upload form should now show an extra checkbox allowing the user to submit the uploaded photo for the contest
* A message appears next to this checkbox indicating how many photos they can still submit
* If this number is zero, the checkbox is disabled
* When submitting a photo, the number of remaining photos is decremented
* To show the contest photos for a month, create a Monthly archive, and instead of plain &lt;mt:entries> use &lt;mt:entries field:add\_to\_contest="1">.  Note: a system template module named "Photo Contest Photos" is available with an example.


