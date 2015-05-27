myApp.controller('AccountCtrl', function($scope,$state, StorageService, DonationService) {

	$scope.settings = {
			enableFriends: true
    }

    console.log("account controller here");
	$scope.changePassword = function(){
		//alert('in details');
		$state.go('tab.changepassword');
		//  {'id': '101'}
	}

	$scope.logOff = function(){
		StorageService.resetCurrentUser();
		$state.go('login', {}, { reload: true });
	}

	var promise = DonationService.findDonationsFromUser();
	promise.then(function(results,err){
		if(!err){
	      $scope.donations = results;
	      $scope.totalDonation = results.totalDonation;
	      console.log('donations ', $scope.donations);
	    }
	    else {
	      console.log('error is: ', err);
	    }
	});
})