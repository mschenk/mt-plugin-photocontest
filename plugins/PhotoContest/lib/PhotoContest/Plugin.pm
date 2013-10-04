package PhotoContest::Plugin;

# Reset the number of photos a user can submit to the photo contest.
# This function gets run every hour, but it only does something on the first day of the month if the hour is less than two (i.e. in the middle of the night)
sub contestphotosreset {
	use CustomFields::Field;
	(my $second, my $minute, my $hour, my $dayOfMonth, my $month, my $yearOffset, my $dayOfWeek, my $dayOfYear, my $daylightSavings) = localtime();
	if (($dayOfMonth == "1") && ($hour < 2)){
		MT->log("Starting reset of monthly contest photo quota for all users");
		# Load the definition of the custom field to be able to get the default value
		my $field = CustomFields::Field->load({'basename' => 'contestphotosleft'});
		# Loop over all authors and reset the value of the field to the default
		my $iter = MT::Author->load_iter();
		while (my $author = $iter->()) {
			$author->meta('field.contestphotosleft', $field->default);
			$author->save();
		}
		MT->log("Reset of monthly contest photo quota for all users finished!");
	}
}

# Return a JSON based indication of the number of photos the currently logged in user
# can still post to the contest this month
# This function can be called via the url ending in mt-cp.cgi?__mode=contestphotosleft
sub contestphotosleft {
        my $app = shift;
        my $user = $app->_login_user_commenter();
        return "{'error': 'Not logged in'}" unless $user; 
        return "{'contestphotosleft': ".$user->meta('field.contestphotosleft')."}";
}

# Call this function to decrement the number of photos a user can post to the photo contest this month
# Returns a JSON based indication of the number of photos the currently logged in user
# can still post to the contest this month
# This function can be called via the url ending in mt-cp.cgi?__mode=decrementcontestphotosleft
sub decrementcontestphotosleft {
        my $app = shift;
        my $user = $app->_login_user_commenter();
        return "{'error': 'Not logged in'}" unless $user; 
        my $left = $user->meta('field.contestphotosleft');
        # Only decrement if there is actually something left to decrement...
        if ($left > 0){
        	$user->meta('field.contestphotosleft', --$left);
        	$user->save();
        }
        return "{'contestphotosleft': ".$user->meta('field.contestphotosleft')."}";
}


1;

